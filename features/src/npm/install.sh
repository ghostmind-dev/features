#!/bin/bash

set -e

# Import feature options
INSTALL_DEFAULT_PACKAGES=${INSTALLDEFAULTPACKAGES:-"true"}
PACKAGES=${PACKAGES:-""}

echo "==========================================================================="
echo "Feature       : NPM Global Packages"
echo "Description   : Installs commonly used global NPM packages"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://docs.npmjs.com/cli/v10/commands/npm-install"
echo "Options       :"
echo "    INSTALLDEFAULTPACKAGES=\"${INSTALL_DEFAULT_PACKAGES}\""
echo "    PACKAGES=\"${PACKAGES}\""
echo "==========================================================================="

echo "Installing NPM global packages..."

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
echo "Installing NPM packages for user: ${USERNAME} (home: ${USER_HOME})"

# Check if Node.js and NPM are installed
# Try to find node in common installation paths
NODE_PATH=""
NPM_PATH=""

# Check common paths where node might be installed
for path in /usr/local/bin/node /usr/bin/node /opt/nodejs/bin/node ~/.nvm/versions/node/*/bin/node; do
    if [ -f "$path" ] && [ -x "$path" ]; then
        NODE_PATH="$path"
        break
    fi
done

# If not found in common paths, try PATH
if [ -z "$NODE_PATH" ] && command -v node &> /dev/null; then
    NODE_PATH=$(command -v node)
fi

# Check for npm in the same directory as node
if [ -n "$NODE_PATH" ]; then
    NODE_DIR=$(dirname "$NODE_PATH")
    if [ -f "$NODE_DIR/npm" ] && [ -x "$NODE_DIR/npm" ]; then
        NPM_PATH="$NODE_DIR/npm"
    fi
fi

# If npm not found with node, try common paths
if [ -z "$NPM_PATH" ]; then
    for path in /usr/local/bin/npm /usr/bin/npm /opt/nodejs/bin/npm ~/.nvm/versions/node/*/bin/npm; do
        if [ -f "$path" ] && [ -x "$path" ]; then
            NPM_PATH="$path"
            break
        fi
    done
fi

# If still not found, try PATH
if [ -z "$NPM_PATH" ] && command -v npm &> /dev/null; then
    NPM_PATH=$(command -v npm)
fi

# Validate we found both node and npm
if [ -z "$NODE_PATH" ]; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    echo "   Make sure the 'node' feature is installed before this feature."
    exit 1
fi

if [ -z "$NPM_PATH" ]; then
    echo "❌ NPM is not installed. Please install NPM first."
    echo "   NPM should be included with Node.js installation."
    exit 1
fi

# Update PATH to ensure node and npm are available
NODE_DIR=$(dirname "$NODE_PATH")
export PATH="$NODE_DIR:$PATH"

echo "✅ Node.js version: $(node --version)"
echo "✅ NPM version: $(npm --version)"

# Set up NPM global directory
echo "Setting up NPM global directory..."
NPM_GLOBAL_DIR="${USER_HOME}/.npm-global"
mkdir -p "${NPM_GLOBAL_DIR}/lib"

# Get user ID and group ID
USER_ID=$(id -u "${USERNAME}" 2>/dev/null || echo "1000")
GROUP_ID=$(id -g "${USERNAME}" 2>/dev/null || echo "1000")

# Set proper ownership of NPM directories
chown -R "${USER_ID}:${GROUP_ID}" "${NPM_GLOBAL_DIR}"
# Also fix ownership of NPM cache directory if it exists
if [ -d "${USER_HOME}/.npm" ]; then
    chown -R "${USER_ID}:${GROUP_ID}" "${USER_HOME}/.npm"
fi

# Configure NPM global prefix
runuser -l "${USERNAME}" -c "npm config set prefix '${NPM_GLOBAL_DIR}'"

# Update PATH to include global bin directory
export PATH="${NPM_GLOBAL_DIR}/bin:$PATH"
echo "✅ NPM global directory configured: ${NPM_GLOBAL_DIR}"

# Install default packages if requested
if [ "${INSTALL_DEFAULT_PACKAGES}" = "true" ]; then
    echo "Installing default global packages..."
    
    DEFAULT_PACKAGES=(
        "zx@8.1.1"
        "nodemon@3.1.1"
        "@anthropic-ai/claude-code"
    )
    
    for package in "${DEFAULT_PACKAGES[@]}"; do
        echo "Installing ${package}..."
        runuser -l "${USERNAME}" -c "export PATH=\"${NPM_GLOBAL_DIR}/bin:${NODE_DIR}:\${PATH}\" && npm install --global \"${package}\""
    done
    
    echo "✅ Default packages installed successfully"
else
    echo "Skipping default packages installation"
fi

# Install additional packages if specified
if [ -n "${PACKAGES}" ] && [ "${PACKAGES}" != "" ]; then
    echo "Installing additional global packages..."
    
    # Convert comma-separated list to array
    IFS=',' read -ra PACKAGE_ARRAY <<< "${PACKAGES}"
    
    for package in "${PACKAGE_ARRAY[@]}"; do
        # Trim whitespace
        package=$(echo "${package}" | xargs)
        if [ -n "${package}" ]; then
            echo "Installing ${package}..."
            runuser -l "${USERNAME}" -c "export PATH=\"${NPM_GLOBAL_DIR}/bin:${NODE_DIR}:\${PATH}\" && npm install --global \"${package}\""
        fi
    done
    
    echo "✅ Additional packages installed successfully"
fi

# Verify installation
echo "Verifying NPM installation..."
runuser -l "${USERNAME}" -c "export PATH=\"${NPM_GLOBAL_DIR}/bin:${NODE_DIR}:\${PATH}\" && npm list --global --depth=0" || true

echo "NPM global packages installation completed successfully!"
echo "Global packages are installed in NPM's default global location" 