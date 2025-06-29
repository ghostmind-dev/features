#!/bin/bash

set -e

# Import feature options
INSTALL_FEATURE=${INSTALLFEATURE:-"true"}
THEME=${THEME:-"codespaces"}
INIT_ZSH_THEME=${INITZSHTHEME:-""}
INIT_ZSH_PLUGINS=${INITZSHPLUGINS:-""}

# Hardcoded plugins that we always use
HARDCODED_PLUGINS="git zsh-autosuggestions zsh-syntax-highlighting zsh-completions"

# Non-built-in plugins that need installation
NON_BUILTIN_PLUGINS="zsh-autosuggestions zsh-syntax-highlighting zsh-completions"

echo "==========================================================================="
echo "Feature       : ZSH Plugin Manager"
echo "Description   : Installs ZSH themes, plugins and sets environment variables"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://github.com/ohmyzsh/ohmyzsh"
echo "Options       :"
echo "    INSTALLFEATURE=\"${INSTALL_FEATURE}\""
echo "    THEME=\"${THEME}\""
echo "    INITZSHTHEME=\"${INIT_ZSH_THEME}\""
echo "    INITZSHPLUGINS=\"${INIT_ZSH_PLUGINS}\""
echo "    Hardcoded plugins: ${HARDCODED_PLUGINS}"
echo "==========================================================================="

# Function to clone git repository with timeout and retry
clone_with_timeout() {
    local repo_url="$1"
    local target_dir="$2"
    local depth_arg="$3"
    local max_attempts=3
    local timeout_seconds=60
    
    for attempt in $(seq 1 $max_attempts); do
        echo "Attempt $attempt/$max_attempts: Cloning $repo_url..."
        
        if timeout ${timeout_seconds} git clone ${depth_arg:+--depth=$depth_arg} "$repo_url" "$target_dir" 2>/dev/null; then
            echo "✅ Successfully cloned $repo_url"
            return 0
        else
            echo "⚠️  Clone attempt $attempt failed (timeout or error)"
            if [ $attempt -eq $max_attempts ]; then
                echo "❌ Failed to clone $repo_url after $max_attempts attempts"
                return 1
            fi
            echo "Waiting 5 seconds before retry..."
            sleep 5
        fi
    done
}

# Determine the user to configure
if [ -n "${_REMOTE_USER}" ]; then
    USERNAME="${_REMOTE_USER}"
elif [ -n "${USERNAME}" ]; then
    USERNAME="${USERNAME}"
else
    USERNAME="vscode"
fi

# Get user home directory
USER_HOME=$(eval echo "~${USERNAME}")
echo "Configuring ZSH for user: ${USERNAME} (home: ${USER_HOME})"

# Set ZSH custom directory
ZSH_CUSTOM="${USER_HOME}/.oh-my-zsh/custom"

if [ "${INSTALL_FEATURE}" = "true" ]; then
    echo "Installing ZSH themes and plugins..."
    
    # Ensure Oh My Zsh custom directory exists
    if [ ! -d "${ZSH_CUSTOM}" ]; then
        echo "Warning: Oh My Zsh custom directory not found at ${ZSH_CUSTOM}"
        echo "Make sure Oh My Zsh is already installed."
        exit 1
    fi
    
    # Install theme based on selection
    echo "Installing theme: ${THEME}"
    case "${THEME}" in
        "spaceship")
            echo "Installing Spaceship theme..."
            if [ ! -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
                if runuser -l "${USERNAME}" -c "$(declare -f clone_with_timeout); clone_with_timeout 'https://github.com/spaceship-prompt/spaceship-prompt.git' '${ZSH_CUSTOM}/themes/spaceship-prompt' '1'"; then
                    echo "✅ Spaceship theme cloned successfully"
                else
                    echo "❌ Failed to clone Spaceship theme"
                    exit 1
                fi
            else
                echo "Spaceship theme already installed, skipping..."
            fi
            if [ ! -f "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ]; then
                runuser -l "${USERNAME}" -c "ln -sf \"${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme\" \"${ZSH_CUSTOM}/themes/spaceship.zsh-theme\""
                echo "✅ Spaceship theme symlink created"
            fi
            ;;
        "agnoster"|"codespaces")
            echo "Using built-in theme: ${THEME}"
            ;;
        *)
            echo "Unknown theme: ${THEME}, falling back to codespaces"
            THEME="codespaces"
            ;;
    esac
    
    # Install non-built-in plugins
    echo "Installing required plugins..."
    
    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        if runuser -l "${USERNAME}" -c "$(declare -f clone_with_timeout); clone_with_timeout 'https://github.com/zsh-users/zsh-autosuggestions' '${ZSH_CUSTOM}/plugins/zsh-autosuggestions' ''"; then
            echo "✅ zsh-autosuggestions installed successfully"
        else
            echo "❌ Failed to install zsh-autosuggestions"
            exit 1
        fi
    else
        echo "zsh-autosuggestions already installed, skipping..."
    fi
    
    # Install zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        if runuser -l "${USERNAME}" -c "$(declare -f clone_with_timeout); clone_with_timeout 'https://github.com/zsh-users/zsh-syntax-highlighting.git' '${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting' ''"; then
            echo "✅ zsh-syntax-highlighting installed successfully"
        else
            echo "❌ Failed to install zsh-syntax-highlighting"
            exit 1
        fi
    else
        echo "zsh-syntax-highlighting already installed, skipping..."
    fi
    
    # Install zsh-completions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
        echo "Installing zsh-completions..."
        if runuser -l "${USERNAME}" -c "$(declare -f clone_with_timeout); clone_with_timeout 'https://github.com/zsh-users/zsh-completions' '${ZSH_CUSTOM}/plugins/zsh-completions' ''"; then
            echo "✅ zsh-completions installed successfully"
        else
            echo "❌ Failed to install zsh-completions"
            exit 1
        fi
    else
        echo "zsh-completions already installed, skipping..."
    fi
    
    # Fix ownership
    echo "Fixing ownership..."
    # Fix theme ownership
    if [ "${THEME}" = "spaceship" ] && [ -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
        chown -R "${USERNAME}:${USERNAME}" "${ZSH_CUSTOM}/themes/spaceship-prompt"
    fi
    
    # Fix plugin ownership
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
        if [ -d "${ZSH_CUSTOM}/plugins/${plugin}" ]; then
            chown -R "${USERNAME}:${USERNAME}" "${ZSH_CUSTOM}/plugins/${plugin}"
        fi
    done
    
    echo "Theme and plugin installation completed successfully!"
else
    echo "Skipping theme and plugin installation (INSTALLFEATURE=false)"
fi

# Always set environment variables
echo "Setting environment variables..."

# Set theme environment variable
THEME_TO_SET="${INIT_ZSH_THEME:-${THEME}}"
echo "export INIT_ZSH_THEME=\"${THEME_TO_SET}\"" >> /etc/environment
echo "Environment variable INIT_ZSH_THEME set to: ${THEME_TO_SET}"

# Set plugins environment variable
PLUGINS_TO_SET="${INIT_ZSH_PLUGINS:-${HARDCODED_PLUGINS}}"
echo "export INIT_ZSH_PLUGINS=\"${PLUGINS_TO_SET}\"" >> /etc/environment
echo "Environment variable INIT_ZSH_PLUGINS set to: ${PLUGINS_TO_SET}"

# Ensure environment variables are available in current session
export INIT_ZSH_THEME="${THEME_TO_SET}"
export INIT_ZSH_PLUGINS="${PLUGINS_TO_SET}"

if [ "${INSTALL_FEATURE}" = "true" ]; then
    echo "ZSH theme and plugin installation completed successfully!"
    echo "Theme: ${THEME_TO_SET}"
    echo "Plugins: ${PLUGINS_TO_SET}"
    echo "Installed plugins: ${NON_BUILTIN_PLUGINS}"
else
    echo "ZSH environment variables configuration completed successfully!"
    echo "INIT_ZSH_THEME: ${THEME_TO_SET}"
    echo "INIT_ZSH_PLUGINS: ${PLUGINS_TO_SET}"
fi
echo "User: ${USERNAME}" 