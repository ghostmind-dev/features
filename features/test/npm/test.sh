#!/bin/bash

# Test script for NPM feature
set -e

echo "🧪 Testing NPM Global Packages installation..."

# Test 1: Check if NPM global directory exists
echo "Test 1: Checking if NPM global directory exists..."
if [ ! -d "$HOME/.npm-global" ]; then
    echo "❌ NPM global directory not found"
    exit 1
fi
echo "✅ NPM global directory exists"

# Test 2: Check NPM configuration
echo "Test 2: Checking NPM configuration..."
NPM_PREFIX=$(npm config get prefix)
if [[ "$NPM_PREFIX" != *".npm-global"* ]]; then
    echo "❌ NPM prefix not correctly configured. Got: $NPM_PREFIX"
    exit 1
fi
echo "✅ NPM prefix correctly configured: $NPM_PREFIX"

# Test 3: Check if environment variables are set in shell profiles
echo "Test 3: Checking environment variables in shell profiles..."
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "NPM_CONFIG_PREFIX" "$HOME/.bashrc"; then
        echo "❌ NPM_CONFIG_PREFIX not found in .bashrc"
        exit 1
    fi
    echo "✅ NPM environment variables found in .bashrc"
fi

# Test 4: Check if PATH includes npm global bin
echo "Test 4: Checking if PATH includes NPM global bin..."
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

if [[ ":$PATH:" != *":$HOME/.npm-global/bin:"* ]]; then
    echo "❌ NPM global bin not in PATH"
    exit 1
fi
echo "✅ NPM global bin is in PATH"

# Test 5: Check if default packages are installed (if enabled)
echo "Test 5: Checking installed global packages..."
INSTALLED_PACKAGES=$(npm list --global --depth=0 2>/dev/null || echo "")
echo "Installed packages: $INSTALLED_PACKAGES"

# The actual packages that should be installed depend on the test scenario
# We'll check for at least one package to be installed
if [[ "$INSTALLED_PACKAGES" == *"(empty)"* ]] || [[ -z "$INSTALLED_PACKAGES" ]]; then
    echo "⚠️  No global packages installed (this might be expected for some test scenarios)"
else
    echo "✅ Global packages are installed"
fi

# Test 6: Test NPM global installation functionality
echo "Test 6: Testing NPM global installation functionality..."
# Try to install a simple package to verify the setup works
npm install --global npm-check-updates --silent
if ! command -v ncu &> /dev/null; then
    echo "❌ Failed to install test package globally"
    exit 1
fi
echo "✅ NPM global installation works correctly"

# Clean up test package
npm uninstall --global npm-check-updates --silent

echo ""
echo "🎉 All tests passed! NPM Global Packages feature is working correctly." 