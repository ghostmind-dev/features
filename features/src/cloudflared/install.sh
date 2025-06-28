#!/bin/bash

set -e

# Import feature options
CLOUDFLARED_VERSION=${VERSION:-"latest"}

echo "Installing Cloudflared..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release

echo "Setting up Cloudflare repository..."

# Create keyrings directory with proper permissions
mkdir -p --mode=0755 /usr/share/keyrings

# Add Cloudflare GPG key
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add Cloudflare repository
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflared.list

# Update package list with new repository
echo "Updating package list..."
apt-get update

# Install cloudflared
echo "Installing cloudflared..."
apt-get install -y cloudflared

# Verify installation
echo "Verifying Cloudflared installation..."
cloudflared --version

echo "Cloudflared installation completed successfully!"
echo "Note: To use cloudflared, you'll need to authenticate with 'cloudflared tunnel login'" 