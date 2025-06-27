#!/bin/bash

set -e

# Import feature options
THEME=${THEME:-"spaceship"}
PLUGINS=${PLUGINS:-"git,ssh-agent,zsh-autosuggestions,zsh-completions"}
INSTALL_AUTOSUGGESTIONS=${INSTALLAUTOSUGGESTIONS:-"true"}
INSTALL_SYNTAX_HIGHLIGHTING=${INSTALLSYNTAXHIGHLIGHTING:-"true"}
INSTALL_COMPLETIONS=${INSTALLCOMPLETIONS:-"true"}
SET_AS_DEFAULT_SHELL=${SETASDEFAULTSHELL:-"true"}

echo "==========================================================================="
echo "Feature       : ZSH with Oh My Zsh"
echo "Description   : Installs ZSH with Oh My Zsh, themes, and useful plugins"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://github.com/ohmyzsh/ohmyzsh"
echo "Options       :"
echo "    THEME=\"${THEME}\""
echo "    PLUGINS=\"${PLUGINS}\""
echo "    INSTALLAUTOSUGGESTIONS=\"${INSTALL_AUTOSUGGESTIONS}\""
echo "    INSTALLSYNTAXHIGHLIGHTING=\"${INSTALL_SYNTAX_HIGHLIGHTING}\""
echo "    INSTALLCOMPLETIONS=\"${INSTALL_COMPLETIONS}\""
echo "    SETASDEFAULTSHELL=\"${SET_AS_DEFAULT_SHELL}\""
echo "==========================================================================="

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

# Install Oh My Zsh using the official installer
echo "Installing Oh My Zsh..."
if [ ! -d "${USER_HOME}/.oh-my-zsh" ]; then
    runuser -l "${USERNAME}" -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
else
    echo "Oh My Zsh already installed, skipping installation..."
fi

# Set ZSH custom directory
ZSH_CUSTOM="${USER_HOME}/.oh-my-zsh/custom"

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
    "powerlevel10k")
        echo "Installing Powerlevel10k theme..."
        if [ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
            runuser -l "${USERNAME}" -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \"${ZSH_CUSTOM}/themes/powerlevel10k\""
        else
            echo "Powerlevel10k theme already installed, skipping..."
        fi
        THEME="powerlevel10k/powerlevel10k"
        ;;
    "agnoster"|"robbyrussell")
        echo "Using built-in theme: ${THEME}"
        ;;
    *)
        echo "Unknown theme: ${THEME}, falling back to robbyrussell"
        THEME="robbyrussell"
        ;;
esac

# Install additional plugins
if [ "${INSTALL_AUTOSUGGESTIONS}" = "true" ]; then
    echo "Installing zsh-autosuggestions..."
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        runuser -l "${USERNAME}" -c "git clone https://github.com/zsh-users/zsh-autosuggestions \"${ZSH_CUSTOM}/plugins/zsh-autosuggestions\""
    else
        echo "zsh-autosuggestions already installed, skipping..."
    fi
fi

if [ "${INSTALL_SYNTAX_HIGHLIGHTING}" = "true" ]; then
    echo "Installing zsh-syntax-highlighting..."
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
        runuser -l "${USERNAME}" -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \"${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting\""
    else
        echo "zsh-syntax-highlighting already installed, skipping..."
    fi
fi

if [ "${INSTALL_COMPLETIONS}" = "true" ]; then
    echo "Installing zsh-completions..."
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
        runuser -l "${USERNAME}" -c "git clone https://github.com/zsh-users/zsh-completions \"${ZSH_CUSTOM}/plugins/zsh-completions\""
    else
        echo "zsh-completions already installed, skipping..."
    fi
fi

# Configure .zshrc
echo "Configuring .zshrc..."
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

# Set plugins
PLUGIN_LIST=$(echo "${PLUGINS}" | tr ',' ' ')
if [ "${INSTALL_SYNTAX_HIGHLIGHTING}" = "true" ]; then
    PLUGIN_LIST="${PLUGIN_LIST} zsh-syntax-highlighting"
fi

if grep -q "plugins=" "${ZSHRC}"; then
    sed -i "s/plugins=.*/plugins=(${PLUGIN_LIST})/" "${ZSHRC}"
else
    echo "plugins=(${PLUGIN_LIST})" >> "${ZSHRC}"
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

# Set ZSH as default shell if requested
if [ "${SET_AS_DEFAULT_SHELL}" = "true" ]; then
    echo "Setting ZSH as default shell for ${USERNAME}..."
    chsh -s "$(which zsh)" "${USERNAME}"
fi

# Fix ownership
if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
    chown -R "${USERNAME}:${USERNAME}" "${USER_HOME}/.oh-my-zsh"
fi
if [ -f "${USER_HOME}/.zshrc" ]; then
    chown "${USERNAME}:${USERNAME}" "${USER_HOME}/.zshrc"
fi

echo "ZSH with Oh My Zsh installation completed successfully!"
echo "Theme: ${THEME}"
echo "Plugins: ${PLUGINS}"
echo "User: ${USERNAME}" 