#!/bin/bash

set -e

# Import feature options
VERSION=${VERSION:-"latest"}
INSTALL_PYTHON=${INSTALLPYTHON:-"false"}
GLOBAL_PACKAGES=${GLOBALPACKAGES:-""}

echo "==========================================================================="
echo "Feature       : uv Python Package Manager"
echo "Description   : Installs uv, an extremely fast Python package and project manager"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://docs.astral.sh/uv/"
echo "Options       :"
echo "    VERSION=\"${VERSION}\""
echo "    INSTALLPYTHON=\"${INSTALL_PYTHON}\""
echo "    GLOBALPACKAGES=\"${GLOBAL_PACKAGES}\""
echo "==========================================================================="

echo "Installing uv Python Package Manager..."

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
echo "Installing uv for user: ${USERNAME} (home: ${USER_HOME})"

# Install dependencies
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates

# Create temporary directory for installation
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and install uv
echo "Downloading and installing uv..."
if [ "${VERSION}" = "latest" ]; then
    echo "Installing latest version of uv..."
    runuser -l "${USERNAME}" -c "curl -LsSf https://astral.sh/uv/install.sh | sh"
else
    echo "Installing uv version: ${VERSION}..."
    runuser -l "${USERNAME}" -c "curl -LsSf https://astral.sh/uv/install.sh | UV_VERSION=\"${VERSION}\" sh"
fi

# Add uv to PATH in shell profiles
UV_INSTALL_DIR="${USER_HOME}/.local/bin"

echo "Adding uv to shell profiles..."

# Add to .bashrc if it exists
if [ -f "${USER_HOME}/.bashrc" ]; then
    echo "Updating .bashrc..."
    cat >> "${USER_HOME}/.bashrc" << EOF

# uv Python Package Manager
export PATH="\${HOME}/.local/bin:\${PATH}"
EOF
fi

# Add to .zshrc if it exists
if [ -f "${USER_HOME}/.zshrc" ]; then
    echo "Updating .zshrc..."
    cat >> "${USER_HOME}/.zshrc" << EOF

# uv Python Package Manager
export PATH="\${HOME}/.local/bin:\${PATH}"
EOF
fi

# Add to .profile as fallback
if [ -f "${USER_HOME}/.profile" ]; then
    echo "Updating .profile..."
    cat >> "${USER_HOME}/.profile" << EOF

# uv Python Package Manager
export PATH="\${HOME}/.local/bin:\${PATH}"
EOF
fi

# Set environment variables for current session
export PATH="${UV_INSTALL_DIR}:${PATH}"

# Verify installation
echo "Verifying uv installation..."
if [ -f "${UV_INSTALL_DIR}/uv" ]; then
    UV_VERSION=$(runuser -l "${USERNAME}" -c "export PATH=\"${UV_INSTALL_DIR}:\${PATH}\" && uv --version")
    echo "✅ uv ${UV_VERSION} installed successfully"
else
    echo "❌ uv installation failed"
    exit 1
fi

# Install Python using uv if requested
if [ "${INSTALL_PYTHON}" = "true" ]; then
    echo "Installing Python using uv..."
    runuser -l "${USERNAME}" -c "export PATH=\"${UV_INSTALL_DIR}:\${PATH}\" && uv python install"
    echo "✅ Python installed via uv"
fi

# Install global packages if specified
if [ -n "${GLOBAL_PACKAGES}" ] && [ "${GLOBAL_PACKAGES}" != "" ]; then
    echo "Installing global packages..."
    
    # Convert comma-separated list to array
    IFS=',' read -ra PACKAGE_ARRAY <<< "${GLOBAL_PACKAGES}"
    
    for package in "${PACKAGE_ARRAY[@]}"; do
        # Trim whitespace
        package=$(echo "${package}" | xargs)
        if [ -n "${package}" ]; then
            echo "Installing ${package}..."
            runuser -l "${USERNAME}" -c "export PATH=\"${UV_INSTALL_DIR}:\${PATH}\" && uv tool install \"${package}\""
        fi
    done
    
    echo "✅ Global packages installed successfully"
fi

# Fix ownership
chown -R "${USERNAME}:${USERNAME}" "${USER_HOME}/.local" 2>/dev/null || true

# Clean up
cd /
rm -rf "$TEMP_DIR"

# Display installation summary
echo ""
echo "🎉 uv installation completed successfully!"
echo "   Version: $(runuser -l "${USERNAME}" -c "export PATH=\"${UV_INSTALL_DIR}:\${PATH}\" && uv --version")"
echo "   Install Location: ${UV_INSTALL_DIR}/uv"
echo ""
echo "Available commands:"
echo "   uv --help              Show help"
echo "   uv --version           Show version"
echo "   uv init                Create a new project"
echo "   uv add <package>       Add a dependency"
echo "   uv remove <package>    Remove a dependency"
echo "   uv sync                Install dependencies"
echo "   uv run <script>        Run a script"
echo "   uv python install     Install Python versions"
echo "   uv tool install <pkg>  Install a tool globally"
echo ""
echo "Remember to restart your shell or source your profile to use uv!" 