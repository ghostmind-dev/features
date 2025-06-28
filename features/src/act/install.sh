#!/bin/bash

set -e

# Import feature options
ACT_VERSION=${VERSION:-"0.2.61"}

echo "Installing act v${ACT_VERSION}..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    wget \
    tar \
    ca-certificates

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCHITECTURE="x86_64"
        ;;
    aarch64|arm64)
        ARCHITECTURE="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH -> Using act architecture: $ARCHITECTURE"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "${TEMP_DIR}"

# Download and install act
echo "Downloading act v${ACT_VERSION} for ${ARCHITECTURE}..."
wget "https://github.com/nektos/act/releases/download/v${ACT_VERSION}/act_Linux_${ARCHITECTURE}.tar.gz"

echo "Extracting archive..."
tar -xvf "act_Linux_${ARCHITECTURE}.tar.gz"

echo "Installing act..."
mv act /usr/local/bin/act
chmod +x /usr/local/bin/act

# Verify installation
echo "Verifying act installation..."
/usr/local/bin/act --version

# Cleanup
cd /
rm -rf "${TEMP_DIR}"

echo "act installation completed successfully!" 