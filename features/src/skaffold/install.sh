#!/bin/bash

set -e

# Import feature options
SKAFFOLD_VERSION=${VERSION:-"2.8.0"}

echo "Installing Skaffold v${SKAFFOLD_VERSION}..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    curl \
    ca-certificates

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        TARGETARCH="amd64"
        ;;
    aarch64|arm64)
        TARGETARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH -> Using Skaffold architecture: $TARGETARCH"

# Download and install Skaffold
echo "Downloading Skaffold v${SKAFFOLD_VERSION} for ${TARGETARCH}..."
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/v${SKAFFOLD_VERSION}/skaffold-linux-${TARGETARCH}

echo "Installing Skaffold..."
chmod +x skaffold
mv skaffold /usr/local/bin

# Verify installation
echo "Verifying Skaffold installation..."
/usr/local/bin/skaffold version

echo "Skaffold installation completed successfully!" 