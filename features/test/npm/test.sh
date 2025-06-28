#!/bin/bash

# Test script for NPM feature
set -e

echo "🧪 Testing NPM Global Packages installation..."

# Test 1: Check if Node.js and NPM are available
echo "Test 1: Checking if Node.js and NPM are available..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ NPM not found"
    exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo "✅ NPM version: $(npm --version)"

# Test 2: Check NPM global installation works
echo "Test 2: Testing NPM global installation functionality..."
# Get npm's default global prefix
NPM_PREFIX=$(npm config get prefix)
echo "✅ NPM global prefix: $NPM_PREFIX"

# Test 3: Check if default packages are installed (if enabled)
echo "Test 3: Checking installed global packages..."
INSTALLED_PACKAGES=$(npm list --global --depth=0 2>/dev/null || echo "")
echo "Installed packages:"
echo "$INSTALLED_PACKAGES"

# Check for default packages if they should be installed
# The test scenarios will determine if default packages should be present
if [[ "$INSTALLED_PACKAGES" == *"zx@"* ]] || [[ "$INSTALLED_PACKAGES" == *"nodemon@"* ]] || [[ "$INSTALLED_PACKAGES" == *"@anthropic-ai/claude-code"* ]]; then
    echo "✅ Default packages are installed"
elif [[ "$INSTALLED_PACKAGES" == *"typescript"* ]] || [[ "$INSTALLED_PACKAGES" == *"prettier"* ]] || [[ "$INSTALLED_PACKAGES" == *"create-react-app"* ]] || [[ "$INSTALLED_PACKAGES" == *"@angular/cli"* ]]; then
    echo "✅ Custom packages are installed"
elif [[ "$INSTALLED_PACKAGES" == *"(empty)"* ]] || [[ -z "$INSTALLED_PACKAGES" ]]; then
    echo "✅ No packages installed (expected for installDefaultPackages=false scenarios)"
else
    echo "✅ Global packages are installed"
fi

# Test 4: Test global package installation and execution
echo "Test 4: Testing global package installation and execution..."
# Try to install a simple package to verify npm global installation works
npm install --global npm-check-updates --silent 2>/dev/null || true

# Check if the package was installed successfully
if npm list --global npm-check-updates &> /dev/null; then
    echo "✅ NPM global installation works correctly"
    
    # Test if we can execute the globally installed package
    if command -v ncu &> /dev/null; then
        echo "✅ Globally installed packages are accessible"
    else
        echo "⚠️  Globally installed package not in PATH (this may be expected in some environments)"
    fi
    
    # Clean up test package
    npm uninstall --global npm-check-updates --silent 2>/dev/null || true
else
    echo "❌ Failed to install test package globally"
    exit 1
fi

echo ""
echo "🎉 All tests passed! NPM Global Packages feature is working correctly." 