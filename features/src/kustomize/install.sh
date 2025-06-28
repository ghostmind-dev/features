#!/bin/bash

set -e

# Import feature options
KUSTOMIZE_VERSION=${VERSION:-"latest"}

echo "Installing Kustomize..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    curl \
    ca-certificates

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "${TEMP_DIR}"

echo "Downloading and installing Kustomize..."

# Download and install Kustomize using the official install script
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash

# Move kustomize to /usr/local/bin
echo "Installing Kustomize to /usr/local/bin..."
mv ./kustomize /usr/local/bin

# Make sure it's executable
chmod +x /usr/local/bin/kustomize

# Verify installation
echo "Verifying Kustomize installation..."
/usr/local/bin/kustomize version

# Cleanup
cd /
rm -rf "${TEMP_DIR}"

echo "Kustomize installation completed successfully!" 