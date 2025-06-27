#!/bin/bash

set -e

# Import feature options
AWS_VERSION=${VERSION:-"latest"}

echo "Installing AWS CLI v2..."

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

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCHITECTURE="x86_64"
        ;;
    aarch64|arm64)
        ARCHITECTURE="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH -> Using AWS CLI architecture: $ARCHITECTURE"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "${TEMP_DIR}"

# Download and install AWS CLI v2
echo "Downloading AWS CLI v2 for ${ARCHITECTURE}..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCHITECTURE}.zip" -o "awscliv2.zip"

echo "Extracting archive..."
unzip awscliv2.zip

echo "Installing AWS CLI..."
./aws/install -i /usr/local/aws-cli -b /usr/local/bin

# Verify installation
echo "Verifying AWS CLI installation..."
/usr/local/bin/aws --version

# Cleanup
cd /
rm -rf "${TEMP_DIR}"

echo "AWS CLI installation completed successfully!" 