#!/bin/bash

set -e

echo "Installing Chromium..."

# Ensure we have required tools
echo "Installing Chromium and required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install additional dependencies for headless operation
echo "Installing dependencies for headless operation..."
apt-get install -y \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils

# Install Chromium and required libraries
echo "Installing Chromium browser..."
apt-get install -y chromium

echo "Installing libnss3-tools..."
apt-get install -y libnss3-tools

# Create a wrapper script for headless usage
echo "Creating Chromium wrapper for headless usage..."
cat > /usr/local/bin/chromium-headless << 'EOF'
#!/bin/bash
exec chromium \
    --headless \
    --disable-gpu \
    --disable-dev-shm-usage \
    --disable-software-rasterizer \
    --disable-background-timer-throttling \
    --disable-backgrounding-occluded-windows \
    --disable-renderer-backgrounding \
    --disable-features=TranslateUI \
    --disable-ipc-flooding-protection \
    --no-first-run \
    --no-default-browser-check \
    --no-sandbox \
    --disable-setuid-sandbox \
    "$@"
EOF

chmod +x /usr/local/bin/chromium-headless

# Verify installation
echo "Verifying Chromium installation..."
chromium --version

echo "Chromium installation completed successfully!" 