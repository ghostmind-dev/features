#!/bin/bash

set -e

# Import feature options
VERSION=${VERSION:-"latest"}
INSTALL_GLOBAL_PACKAGES=${INSTALLGLOBALPACKAGES:-"false"}
PACKAGES=${PACKAGES:-""}

echo "==========================================================================="
echo "Feature       : Bun JavaScript Runtime"
echo "Description   : Installs Bun, the fast all-in-one JavaScript runtime and toolkit"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://bun.sh/docs"
echo "Options       :"
echo "    VERSION=\"${VERSION}\""
echo "    INSTALLGLOBALPACKAGES=\"${INSTALL_GLOBAL_PACKAGES}\""
echo "    PACKAGES=\"${PACKAGES}\""
echo "==========================================================================="

echo "Installing Bun JavaScript Runtime..."

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
echo "Installing Bun for user: ${USERNAME} (home: ${USER_HOME})"

# Install dependencies
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl unzip ca-certificates

# Create temporary directory for installation
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and install Bun
echo "Downloading and installing Bun..."
if [ "${VERSION}" = "latest" ]; then
    echo "Installing latest version of Bun..."
    runuser -l "${USERNAME}" -c "curl -fsSL https://bun.sh/install | bash"
else
    echo "Installing Bun version: ${VERSION}..."
    runuser -l "${USERNAME}" -c "curl -fsSL https://bun.sh/install | bash -s \"bun-v${VERSION}\""
fi

# Add Bun to PATH in shell profiles
BUN_INSTALL_DIR="${USER_HOME}/.bun"
BUN_BIN_DIR="${BUN_INSTALL_DIR}/bin"

echo "Adding Bun to shell profiles..."

# Add to .bashrc if it exists
if [ -f "${USER_HOME}/.bashrc" ]; then
    echo "Updating .bashrc..."
    cat >> "${USER_HOME}/.bashrc" << EOF

# Bun JavaScript Runtime
export BUN_INSTALL="\${HOME}/.bun"
export PATH="\${BUN_INSTALL}/bin:\${PATH}"
EOF
fi

# Add to .zshrc if it exists
if [ -f "${USER_HOME}/.zshrc" ]; then
    echo "Updating .zshrc..."
    cat >> "${USER_HOME}/.zshrc" << EOF

# Bun JavaScript Runtime
export BUN_INSTALL="\${HOME}/.bun"
export PATH="\${BUN_INSTALL}/bin:\${PATH}"
EOF
fi

# Add to .profile as fallback
if [ -f "${USER_HOME}/.profile" ]; then
    echo "Updating .profile..."
    cat >> "${USER_HOME}/.profile" << EOF

# Bun JavaScript Runtime
export BUN_INSTALL="\${HOME}/.bun"
export PATH="\${BUN_INSTALL}/bin:\${PATH}"
EOF
fi

# Set environment variables for current session
export BUN_INSTALL="${BUN_INSTALL_DIR}"
export PATH="${BUN_BIN_DIR}:${PATH}"

# Verify installation
echo "Verifying Bun installation..."
if [ -f "${BUN_BIN_DIR}/bun" ]; then
    BUN_VERSION=$(runuser -l "${USERNAME}" -c "export PATH=\"${BUN_BIN_DIR}:\${PATH}\" && bun --version")
    echo "✅ Bun ${BUN_VERSION} installed successfully"
else
    echo "❌ Bun installation failed"
    exit 1
fi

# Install global packages if requested
if [ "${INSTALL_GLOBAL_PACKAGES}" = "true" ]; then
    echo "Installing default global packages..."
    
    DEFAULT_PACKAGES=(
        "typescript"
        "prettier"
        "@types/node"
    )
    
    for package in "${DEFAULT_PACKAGES[@]}"; do
        echo "Installing ${package}..."
        runuser -l "${USERNAME}" -c "export PATH=\"${BUN_BIN_DIR}:\${PATH}\" && bun add --global \"${package}\""
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
            runuser -l "${USERNAME}" -c "export PATH=\"${BUN_BIN_DIR}:\${PATH}\" && bun add --global \"${package}\""
        fi
    done
    
    echo "✅ Additional packages installed successfully"
fi

# Fix ownership
chown -R "${USERNAME}:${USERNAME}" "${BUN_INSTALL_DIR}"

# Clean up
cd /
rm -rf "$TEMP_DIR"

# Display installation summary
echo ""
echo "🎉 Bun installation completed successfully!"
echo "   Version: $(runuser -l "${USERNAME}" -c "export PATH=\"${BUN_BIN_DIR}:\${PATH}\" && bun --version")"
echo "   Install Location: ${BUN_INSTALL_DIR}"
echo "   Binary Location: ${BUN_BIN_DIR}/bun"
echo ""
echo "Available commands:"
echo "   bun --help        Show help"
echo "   bun --version     Show version"
echo "   bun init          Create a new project"
echo "   bun install       Install dependencies"
echo "   bun add <pkg>     Add a package"
echo "   bun run <script>  Run a script"
echo "   bun dev           Run in development mode"
echo "   bun build         Build for production"
echo ""
echo "Remember to restart your shell or source your profile to use Bun!" 