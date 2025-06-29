#!/bin/bash

set -e

# Import feature options
INSTALL_FEATURE=${INSTALLFEATURE:-"true"}
THEME=${THEME:-"codespaces"}
INIT_ZSH_THEME=${INITZSHTHEME:-""}
INIT_ZSH_PLUGINS=${INITZSHPLUGINS:-""}

# Hardcoded plugins that we always use
HARDCODED_PLUGINS="git zsh-autosuggestions zsh-syntax-highlighting zsh-completions"

echo "==========================================================================="
echo "Feature       : ZSH with Oh My Zsh"
echo "Description   : Installs ZSH with Oh My Zsh, themes, and hardcoded plugins"
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

if [ "${INSTALL_FEATURE}" = "true" ]; then
    echo "Installing ZSH with Oh My Zsh..."
    
    # Ensure we have required tools
    echo "Installing required dependencies..."
    export DEBIAN_FRONTEND=noninteractive

    # Update package list
    apt-get update

    # Install required packages
    apt-get install -y \
        zsh \
        curl \
        git \
        wget \
        ca-certificates
else
    echo "Skipping ZSH installation (INSTALLFEATURE=false). Setting environment variables only..."
fi

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

if [ "${INSTALL_FEATURE}" = "true" ]; then
    # Install Oh My Zsh using the official installer
    echo "Installing Oh My Zsh..."
    if [ ! -d "${USER_HOME}/.oh-my-zsh" ]; then
        runuser -l "${USERNAME}" -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
    else
        echo "Oh My Zsh already installed, skipping installation..."
    fi
fi

# Set ZSH custom directory
ZSH_CUSTOM="${USER_HOME}/.oh-my-zsh/custom"

if [ "${INSTALL_FEATURE}" = "true" ]; then
    # Install theme based on selection
    case "${THEME}" in
        "spaceship")
            echo "Installing Spaceship theme..."
            if [ ! -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
                runuser -l "${USERNAME}" -c "git clone https://github.com/spaceship-prompt/spaceship-prompt.git \"${ZSH_CUSTOM}/themes/spaceship-prompt\" --depth=1"
            else
                echo "Spaceship theme already installed, skipping..."
            fi
            if [ ! -f "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ]; then
                runuser -l "${USERNAME}" -c "ln -sf \"${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme\" \"${ZSH_CUSTOM}/themes/spaceship.zsh-theme\""
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

    # Install hardcoded plugins
    echo "Installing hardcoded plugins..."
    
    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        runuser -l "${USERNAME}" -c "git clone https://github.com/zsh-users/zsh-autosuggestions \"${ZSH_CUSTOM}/plugins/zsh-autosuggestions\""
    fi
    
    # Install zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        runuser -l "${USERNAME}" -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \"${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting\""
    fi
    
    # Install zsh-completions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
        echo "Installing zsh-completions..."
        runuser -l "${USERNAME}" -c "git clone https://github.com/zsh-users/zsh-completions \"${ZSH_CUSTOM}/plugins/zsh-completions\""
    fi
else
    echo "Skipping theme and plugin installation (INSTALLFEATURE=false)"
    
    # For powerlevel10k, we still need to set the correct theme path even when not installing
    if [ "${THEME}" = "powerlevel10k" ]; then
        THEME="powerlevel10k/powerlevel10k"
    fi
fi

# Handle configuration based on install mode
if [ "${INSTALL_FEATURE}" = "false" ]; then
    echo "Setting environment variables only..."
    
    # Set theme environment variable
    THEME_TO_SET="${INIT_ZSH_THEME:-${THEME}}"
    echo "export INIT_ZSH_THEME=\"${THEME_TO_SET}\"" >> /etc/environment
    echo "INIT_ZSH_THEME=\"${THEME_TO_SET}\"" >> /etc/environment
    echo "Environment variable INIT_ZSH_THEME set to: ${THEME_TO_SET}"
    
    # Set plugins environment variable
    PLUGINS_TO_SET="${INIT_ZSH_PLUGINS:-${HARDCODED_PLUGINS}}"
    echo "export INIT_ZSH_PLUGINS=\"${PLUGINS_TO_SET}\"" >> /etc/environment
    echo "INIT_ZSH_PLUGINS=\"${PLUGINS_TO_SET}\"" >> /etc/environment
    echo "Environment variable INIT_ZSH_PLUGINS set to: ${PLUGINS_TO_SET}"
    
    # Ensure environment variables are available in current session
    export INIT_ZSH_THEME="${THEME_TO_SET}"
    export INIT_ZSH_PLUGINS="${PLUGINS_TO_SET}"
    
    echo "Skipping .zshrc modification (using environment variables only)"
else
    echo "Configuring .zshrc file..."
    
    # Configure .zshrc (traditional file-based configuration)
    ZSHRC="${USER_HOME}/.zshrc"

    # Ensure .zshrc exists
    if [ ! -f "${ZSHRC}" ]; then
        runuser -l "${USERNAME}" -c "cp /etc/skel/.zshrc \"${ZSHRC}\" 2>/dev/null || echo '# ZSH configuration' > \"${ZSHRC}\""
    fi

    # Set theme (handle both existing and new configurations)
    if grep -q "ZSH_THEME=" "${ZSHRC}"; then
        # Use a different delimiter to avoid issues with slashes in theme names
        sed -i "s|ZSH_THEME=.*|ZSH_THEME=\"${THEME}\"|" "${ZSHRC}"
    else
        echo "ZSH_THEME=\"${THEME}\"" >> "${ZSHRC}"
    fi

    # Set hardcoded plugins
    if grep -q "plugins=" "${ZSHRC}"; then
        sed -i "s/plugins=.*/plugins=(${HARDCODED_PLUGINS})/" "${ZSHRC}"
    else
        echo "plugins=(${HARDCODED_PLUGINS})" >> "${ZSHRC}"
    fi

    # Add custom configurations for Spaceship theme
    if [ "${THEME}" = "spaceship" ]; then
        cat >> "${ZSHRC}" << 'EOF'

# Spaceship theme configuration
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL="❯ "
SPACESHIP_CHAR_SUFFIX=""
EOF
    fi
fi

if [ "${INSTALL_FEATURE}" = "true" ]; then
    # Set ZSH as default shell if installing
    echo "Setting ZSH as default shell for ${USERNAME}..."
    chsh -s "$(which zsh)" "${USERNAME}"
fi

# Fix ownership (this always runs when we have installations)
if [ "${INSTALL_FEATURE}" = "true" ]; then
    if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
        chown -R "${USERNAME}:${USERNAME}" "${USER_HOME}/.oh-my-zsh"
    fi
    if [ -f "${USER_HOME}/.zshrc" ]; then
        chown "${USERNAME}:${USERNAME}" "${USER_HOME}/.zshrc"
    fi
fi

if [ "${INSTALL_FEATURE}" = "true" ]; then
    echo "ZSH with Oh My Zsh installation completed successfully!"
    echo "Theme: ${THEME}"
    echo "Plugins: ${HARDCODED_PLUGINS}"
else
    echo "ZSH environment variables configuration completed successfully!"
    echo "INIT_ZSH_THEME: ${THEME_TO_SET}"
    echo "INIT_ZSH_PLUGINS: ${PLUGINS_TO_SET}"
fi
echo "User: ${USERNAME}" 