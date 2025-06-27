#!/bin/bash

set -e

# Import feature options
GCLOUD_VERSION=${VERSION:-"405.0.0"}
INSTALL_BETA=${INSTALLBETA:-"false"}
INSTALL_GKE_AUTH_PLUGIN=${INSTALLGKEAUTHPLUGIN:-"true"}

echo "Installing Google Cloud CLI version ${GCLOUD_VERSION}..."

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
    lsb-release \
    apt-transport-https \
    python3 \
    python3-pip

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCHITECTURE="x86_64"
        ;;
    aarch64|arm64)
        ARCHITECTURE="arm"
        ;;
    i386|i686)
        ARCHITECTURE="x86"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected architecture: $ARCH -> Using Google Cloud CLI architecture: $ARCHITECTURE"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "${TEMP_DIR}"

# Download and extract Google Cloud CLI
echo "Downloading Google Cloud CLI ${GCLOUD_VERSION} for ARM64..."
curl -fsSL -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-${ARCHITECTURE}.tar.gz"

echo "Extracting archive..."
tar -xf "google-cloud-cli-${GCLOUD_VERSION}-linux-${ARCHITECTURE}.tar.gz"

# Install Google Cloud SDK
echo "Installing Google Cloud SDK..."
./google-cloud-sdk/install.sh --quiet --path-update=false --bash-completion=false

# Move to final location
echo "Moving to /usr/local/lib..."
mv google-cloud-sdk /usr/local/lib/

# Add to PATH
echo "Adding to PATH..."
echo 'export PATH="$PATH:/usr/local/lib/google-cloud-sdk/bin"' >> /etc/bash.bashrc

# Add to zsh config if it exists
if [ -f /etc/zsh/zshrc ]; then
    echo 'export PATH="$PATH:/usr/local/lib/google-cloud-sdk/bin"' >> /etc/zsh/zshrc
elif [ -d /etc/zsh ]; then
    echo 'export PATH="$PATH:/usr/local/lib/google-cloud-sdk/bin"' >> /etc/zsh/zshrc
fi

# Install GKE auth plugin if requested
if [ "${INSTALL_GKE_AUTH_PLUGIN}" = "true" ]; then
    echo "Installing GKE gcloud auth plugin..."
    /usr/local/lib/google-cloud-sdk/bin/gcloud components install gke-gcloud-auth-plugin --quiet
fi

# Install beta components if requested
if [ "${INSTALL_BETA}" = "true" ]; then
    echo "Installing beta components..."
    /usr/local/lib/google-cloud-sdk/bin/gcloud components install beta --quiet
fi

# Set environment variable for Google Application Credentials
echo 'export GOOGLE_APPLICATION_CREDENTIALS="/tmp/gsa_key.json"' >> /etc/bash.bashrc

# Add to zsh config if it exists
if [ -f /etc/zsh/zshrc ]; then
    echo 'export GOOGLE_APPLICATION_CREDENTIALS="/tmp/gsa_key.json"' >> /etc/zsh/zshrc
elif [ -d /etc/zsh ]; then
    echo 'export GOOGLE_APPLICATION_CREDENTIALS="/tmp/gsa_key.json"' >> /etc/zsh/zshrc
fi

# Cleanup
cd /
rm -rf "${TEMP_DIR}"

echo "Google Cloud CLI installation completed successfully!" 