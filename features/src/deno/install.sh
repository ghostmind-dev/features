#!/bin/bash

set -e

# Import feature options
DENO_VERSION=${VERSION:-"v2.0.3"}

echo "Installing Deno ${DENO_VERSION}..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    curl \
    ca-certificates \
    unzip

# Set environment variables
DENO_INSTALL=/deno
DENO_DIR=${DENO_INSTALL}/.cache/deno

echo "Creating Deno installation directory..."
mkdir -p ${DENO_INSTALL}

# Download and install Deno
echo "Downloading and installing Deno ${DENO_VERSION}..."
curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=${DENO_INSTALL} sh -s ${DENO_VERSION}

# Set ownership to vscode user
echo "Setting ownership to vscode user..."
chown -R vscode:vscode ${DENO_INSTALL}

# Update PATH for all users
echo "Updating PATH..."
echo "export PATH=\"${DENO_INSTALL}/bin:\$PATH\"" >> /etc/bash.bashrc
echo "export DENO_INSTALL=\"${DENO_INSTALL}\"" >> /etc/bash.bashrc
echo "export DENO_DIR=\"${DENO_DIR}\"" >> /etc/bash.bashrc

# Also add to profile for compatibility
echo "export PATH=\"${DENO_INSTALL}/bin:\$PATH\"" >> /etc/profile
echo "export DENO_INSTALL=\"${DENO_INSTALL}\"" >> /etc/profile
echo "export DENO_DIR=\"${DENO_DIR}\"" >> /etc/profile

# Verify installation
echo "Verifying Deno installation..."
export PATH="${DENO_INSTALL}/bin:$PATH"
${DENO_INSTALL}/bin/deno --version

echo "Deno installation completed successfully!" 