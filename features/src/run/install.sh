#!/bin/bash

set -e

echo "Installing run CLI..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install required packages
apt-get install -y \
    git \
    ca-certificates

# Ensure deno is available in PATH
export PATH="/deno/bin:$PATH"

# Verify deno is available
if ! command -v deno &> /dev/null; then
    echo "❌ Error: Deno is required but not found in PATH"
    echo "Make sure the deno feature is installed before the run feature"
    exit 1
fi

echo "✅ Deno found, proceeding with run installation..."

# Set target directory
RUN_HOME=/home/vscode/run

echo "Cloning run repository..."
# Clone the run repository
if [ -d "$RUN_HOME" ]; then
    echo "Removing existing run directory..."
    rm -rf "$RUN_HOME"
fi

# Clone as vscode user
su - vscode -c "git clone https://github.com/ghostmind-dev/run.git $RUN_HOME"

echo "Installing run CLI globally..."
# Install run CLI globally as vscode user
su - vscode -c "deno install --allow-all --force --global --name run $RUN_HOME/run/bin/cmd.ts"

# Ensure the deno bin directory is in PATH for all users
DENO_BIN_PATH="/home/vscode/.deno/bin"

# Update PATH in bash.bashrc
if ! grep -q "$DENO_BIN_PATH" /etc/bash.bashrc; then
    echo "export PATH=\"$DENO_BIN_PATH:\$PATH\"" >> /etc/bash.bashrc
fi

# Update PATH in profile
if ! grep -q "$DENO_BIN_PATH" /etc/profile; then
    echo "export PATH=\"$DENO_BIN_PATH:\$PATH\"" >> /etc/profile
fi

# Verify installation
echo "Verifying run CLI installation..."
export PATH="$DENO_BIN_PATH:$PATH"
if command -v run &> /dev/null; then
    echo "✅ run CLI installation completed successfully!"
    su - vscode -c "run --version" || echo "✅ run CLI installed (version command may not be available)"
else
    echo "❌ run CLI installation failed"
    exit 1
fi

echo "🎉 Run CLI feature installation completed successfully!" 