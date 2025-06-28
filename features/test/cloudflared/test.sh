#!/bin/bash

set -e

echo "Testing Cloudflared installation..."

# Check if cloudflared is installed and available
echo "Checking if cloudflared is installed..."
if ! command -v cloudflared &> /dev/null; then
    echo "❌ cloudflared command not found"
    exit 1
fi

# Check cloudflared version
echo "Checking cloudflared version..."
cloudflared --version

# Test cloudflared help command
echo "Testing cloudflared help command..."
cloudflared --help > /dev/null

echo "✅ Cloudflared installation test passed!" 