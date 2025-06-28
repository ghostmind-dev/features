#!/bin/bash

set -e

# Import feature options
INSTALL_KUBECTL=${INSTALLKUBECTL:-"true"}
INSTALL_KIND=${INSTALLKIND:-"true"}
KIND_VERSION=${KINDVERSION:-"v0.26.0"}
INSTALL_K9S=${INSTALLK9S:-"true"}
INSTALL_SKAFFOLD=${INSTALLSKAFFOLD:-"false"}
SKAFFOLD_VERSION=${SKAFFOLDVERSION:-"2.8.0"}
INSTALL_KUSTOMIZE=${INSTALLKUSTOMIZE:-"false"}
KUSTOMIZE_VERSION=${KUSTOMIZEVERSION:-"latest"}

echo "Installing Kubernetes Toolkit..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    curl \
    ca-certificates \
    apt-transport-https \
    gnupg2 \
    lsb-release \
    git

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

echo "Detected architecture: $ARCH -> Using architecture: $TARGETARCH"

# Install kubectl if requested
if [ "$INSTALL_KUBECTL" = "true" ]; then
    echo "Installing kubectl..."
    
    # Create the keyring directory if it doesn't exist
    mkdir -p /etc/apt/keyrings
    
    # Add the Kubernetes apt repository
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
    
    # Update package list and install kubectl
    apt-get update
    apt-get install -y kubectl
    
    echo "✅ kubectl installed successfully"
    kubectl version --client
fi

# Install kind if requested
if [ "$INSTALL_KIND" = "true" ]; then
    echo "Installing kind ${KIND_VERSION}..."
    
    # Remove the 'v' prefix if present for the download URL
    CLEAN_VERSION=${KIND_VERSION#v}
    
    # Download and install kind
    curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v${CLEAN_VERSION}/kind-linux-${TARGETARCH}"
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
    
    echo "✅ kind installed successfully"
    kind version
fi

# Install k9s if requested
if [ "$INSTALL_K9S" = "true" ]; then
    echo "Installing k9s..."
    
    # Install Go if not already installed (required for k9s installation)
    if ! command -v go &> /dev/null; then
        echo "Installing Go (required for k9s)..."
        GO_VERSION="1.21.5"
        curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz"
        tar -C /usr/local -xzf "go${GO_VERSION}.linux-${TARGETARCH}.tar.gz"
        export PATH=$PATH:/usr/local/go/bin
        rm "go${GO_VERSION}.linux-${TARGETARCH}.tar.gz"
    fi
    
    # Set Go environment
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=/usr/local/go-workspace
    export GOBIN=/usr/local/bin
    
    # Install k9s
    go install github.com/derailed/k9s@latest
    
    echo "✅ k9s installed successfully"
    k9s version
fi

# Install Skaffold if requested
if [ "$INSTALL_SKAFFOLD" = "true" ]; then
    echo "Installing Skaffold v${SKAFFOLD_VERSION}..."
    
    # Download and install Skaffold
    curl -Lo skaffold "https://storage.googleapis.com/skaffold/releases/v${SKAFFOLD_VERSION}/skaffold-linux-${TARGETARCH}"
    chmod +x skaffold
    mv skaffold /usr/local/bin
    
    echo "✅ Skaffold installed successfully"
    skaffold version
fi

# Install Kustomize if requested
if [ "$INSTALL_KUSTOMIZE" = "true" ]; then
    echo "Installing Kustomize..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "${TEMP_DIR}"
    
    # Download and install Kustomize using the official install script
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    
    # Move kustomize to /usr/local/bin
    mv ./kustomize /usr/local/bin
    chmod +x /usr/local/bin/kustomize
    
    # Cleanup
    cd /
    rm -rf "${TEMP_DIR}"
    
    echo "✅ Kustomize installed successfully"
    kustomize version
fi

echo ""
echo "🎉 Kubernetes Toolkit installation completed successfully!"
echo ""
echo "Installed tools:"

if [ "$INSTALL_KUBECTL" = "true" ]; then
    echo "  ✅ kubectl - Kubernetes CLI"
fi

if [ "$INSTALL_KIND" = "true" ]; then
    echo "  ✅ kind - Kubernetes in Docker"
fi

if [ "$INSTALL_K9S" = "true" ]; then
    echo "  ✅ k9s - Kubernetes cluster management"
fi

if [ "$INSTALL_SKAFFOLD" = "true" ]; then
    echo "  ✅ skaffold - Kubernetes development workflows"
fi

if [ "$INSTALL_KUSTOMIZE" = "true" ]; then
    echo "  ✅ kustomize - Kubernetes configuration management"
fi

echo "" 