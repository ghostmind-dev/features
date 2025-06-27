#!/bin/bash

set -e

# Import feature options
VAULT_VERSION=${VERSION:-"latest"}
# Try multiple installation directories to avoid permission issues
INSTALL_DIRS=("/usr/local/bin" "/home/vscode/.local/bin" "$HOME/.local/bin" "/tmp/vault-bin")

echo "Installing HashiCorp Vault..."

# Function to test if vault command works
test_vault_execution() {
    local vault_path="$1"
    if [ -f "$vault_path" ] && [ -x "$vault_path" ]; then
        if "$vault_path" --version >/dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

# Check if vault is already installed and working
echo "Checking for existing Vault installation..."
if command -v vault >/dev/null 2>&1; then
    EXISTING_VAULT=$(command -v vault)
    echo "Found existing Vault at: $EXISTING_VAULT"
    
    if test_vault_execution "$EXISTING_VAULT"; then
        echo "✅ Existing Vault installation is working!"
        vault --version
        echo "HashiCorp Vault is already installed and functional."
        exit 0
    else
        echo "⚠️  Existing Vault installation has execution restrictions."
        echo "Attempting to copy to user-accessible location..."
        
        # Try to copy to user's local bin
        USER_BIN="$HOME/.local/bin"
        mkdir -p "$USER_BIN"
        
        if cp "$EXISTING_VAULT" "$USER_BIN/vault" 2>/dev/null; then
            chmod +x "$USER_BIN/vault"
            
            if test_vault_execution "$USER_BIN/vault"; then
                echo "✅ Successfully copied Vault to $USER_BIN/vault"
                "$USER_BIN/vault" --version
                
                # Add to PATH if not already there
                if ! echo "$PATH" | grep -q "$USER_BIN"; then
                    echo "Adding $USER_BIN to PATH..."
                    echo "export PATH=\"$USER_BIN:\$PATH\"" >> ~/.bashrc
                    echo "export PATH=\"$USER_BIN:\$PATH\"" >> ~/.zshrc
                    export PATH="$USER_BIN:$PATH"
                fi
                
                echo "✅ Vault installation completed successfully!"
                echo "You may need to restart your shell or run: source ~/.bashrc"
                exit 0
            fi
        fi
        
        # If copying to user bin fails, try project directory
        PROJECT_DIR="/workspaces/features"
        if [ -d "$PROJECT_DIR" ]; then
            echo "Trying to copy to project directory..."
            if cp "$EXISTING_VAULT" "$PROJECT_DIR/vault" 2>/dev/null; then
                chmod +x "$PROJECT_DIR/vault"
                
                if test_vault_execution "$PROJECT_DIR/vault"; then
                    echo "✅ Successfully copied Vault to $PROJECT_DIR/vault"
                    "$PROJECT_DIR/vault" --version
                    echo ""
                    echo "✅ Vault installation completed successfully!"
                    echo "You can run vault with: ./vault --version"
                    exit 0
                fi
            fi
        fi
        
        echo "❌ Failed to create working copy of existing Vault installation."
        echo "Proceeding with fresh installation..."
    fi
else
    echo "No existing Vault installation found."
fi

# Check if running as root for package installation
if [ "$EUID" -ne 0 ]; then
    echo "⚠️  Not running as root. Skipping package installation."
    echo "If you need to install system packages, run this script as root or use sudo."
else
    # Ensure we have required tools
    echo "Installing required dependencies..."
    export DEBIAN_FRONTEND=noninteractive

    # Update package list
    apt-get update

    # Install required packages
    apt-get install -y \
        curl \
        unzip \
        ca-certificates
fi

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        VAULT_ARCH="amd64"
        ;;
    aarch64|arm64)
        VAULT_ARCH="arm64"
        ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH -> Using Vault architecture: $VAULT_ARCH"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "${TEMP_DIR}"

# Determine version to install
if [ "$VAULT_VERSION" = "latest" ]; then
    echo "Detecting latest Vault version..."
    DOWNLOAD_VERSION=$(curl -s https://api.releases.hashicorp.com/v1/releases/vault/latest | grep -o '"version":"[^"]*' | cut -d'"' -f4)
    if [ -z "$DOWNLOAD_VERSION" ]; then
        echo "❌ Failed to detect latest version of Vault"
        exit 1
    fi
    echo "Latest version detected: $DOWNLOAD_VERSION"
else
    DOWNLOAD_VERSION=$VAULT_VERSION
    echo "Specific version requested: $DOWNLOAD_VERSION"
fi

# Download Vault binary
echo "Downloading Vault ${DOWNLOAD_VERSION} for ${VAULT_ARCH}..."
curl -fsSL "https://releases.hashicorp.com/vault/${DOWNLOAD_VERSION}/vault_${DOWNLOAD_VERSION}_linux_${VAULT_ARCH}.zip" -o vault.zip

# Extract and install
echo "Extracting archive..."
unzip vault.zip

# Function to test if a directory allows execution
test_execution() {
    local test_dir="$1"
    local test_file="${test_dir}/vault-test-$$"
    
    if [ ! -d "$test_dir" ]; then
        mkdir -p "$test_dir" 2>/dev/null || return 1
    fi
    
    # Copy vault binary to test location
    cp vault "$test_file" 2>/dev/null || return 1
    chmod +x "$test_file" 2>/dev/null || return 1
    
    # Test execution
    if "$test_file" --version >/dev/null 2>&1; then
        rm -f "$test_file"
        return 0
    else
        rm -f "$test_file" 2>/dev/null
        return 1
    fi
}

# Try to find a working installation directory
INSTALL_DIR=""
for dir in "${INSTALL_DIRS[@]}"; do
    echo "Testing installation directory: $dir"
    if test_execution "$dir"; then
        INSTALL_DIR="$dir"
        echo "✅ Found working installation directory: $INSTALL_DIR"
        break
    else
        echo "❌ Directory $dir has execution restrictions or permission issues"
    fi
done

if [ -z "$INSTALL_DIR" ]; then
    echo "❌ Could not find a suitable installation directory with execution permissions"
    echo "This is likely due to container security restrictions."
    echo ""
    echo "🔧 Manual workaround options:"
    echo "1. Copy the vault binary to your project directory:"
    echo "   cp vault /workspaces/features/vault"
    echo "   chmod +x /workspaces/features/vault"
    echo "   ./vault --version"
    echo ""
    echo "2. Run Vault from current directory:"
    echo "   chmod +x vault"
    echo "   ./vault --version"
    
    # Copy to current working directory as fallback
    cp vault /workspaces/features/vault
    chmod +x /workspaces/features/vault
    
    echo ""
    echo "✅ Vault binary copied to /workspaces/features/vault"
    echo "You can now run: ./vault --version"
    
    cd /
    rm -rf "${TEMP_DIR}"
    exit 0
fi

echo "Installing Vault to ${INSTALL_DIR}..."
cp vault "${INSTALL_DIR}/vault"
chmod +x "${INSTALL_DIR}/vault"

# Verify installation
echo "Verifying Vault installation..."
if "${INSTALL_DIR}/vault" --version; then
    echo "✅ Vault installation verified successfully!"
else
    echo "❌ Vault installation verification failed"
    exit 1
fi

# Add to PATH if needed
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "Adding $INSTALL_DIR to PATH..."
    if [ "$EUID" -eq 0 ]; then
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> /etc/bash.bashrc
    fi
    if [ -d "/home/vscode" ]; then
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> /home/vscode/.bashrc
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> /home/vscode/.zshrc
    fi
    if [ -d "/home/node" ]; then
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> /home/node/.bashrc
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> /home/node/.zshrc
    fi
    # Also add to current user's shell configs
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.bashrc
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> ~/.zshrc
fi

# Cleanup
cd /
rm -rf "${TEMP_DIR}"

# Set up basic environment (optional but good practice)
echo "Setting up Vault environment..."
if [ "$EUID" -eq 0 ]; then
    echo 'alias vault-status="vault status"' >> /etc/bash.bashrc
fi
if [ -d "/home/vscode" ]; then
    echo 'alias vault-status="vault status"' >> /home/vscode/.bashrc
    echo 'alias vault-status="vault status"' >> /home/vscode/.zshrc
fi
if [ -d "/home/node" ]; then
    echo 'alias vault-status="vault status"' >> /home/node/.bashrc
    echo 'alias vault-status="vault status"' >> /home/node/.zshrc
fi
# Also add to current user
echo 'alias vault-status="vault status"' >> ~/.bashrc
echo 'alias vault-status="vault status"' >> ~/.zshrc

echo "HashiCorp Vault installation completed successfully!"
echo ""
echo "📚 Getting Started:"
echo "  • Run 'vault --version' to check installation"
echo "  • Run 'vault --help' for available commands"
echo "  • If 'vault' command is not found, restart your shell or run: source ~/.bashrc"
echo ""
echo "⚡ Quick Commands:"
echo "  • vault status    - Check Vault server status"
echo "  • vault auth      - Manage authentication methods"
echo "  • vault secrets   - Manage secrets engines" 