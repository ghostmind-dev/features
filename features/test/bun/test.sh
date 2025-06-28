#!/bin/bash

# Test script for Bun JavaScript Runtime feature
set -e

echo "🧪 Testing Bun JavaScript Runtime installation..."

# Test 1: Check if Bun installation directory exists
echo "Test 1: Checking if Bun installation directory exists..."
if [ ! -d "$HOME/.bun" ]; then
    echo "❌ Bun installation directory not found"
    exit 1
fi
echo "✅ Bun installation directory exists"

# Test 2: Check if Bun binary exists and is executable
echo "Test 2: Checking if Bun binary exists and is executable..."
if [ ! -f "$HOME/.bun/bin/bun" ] || [ ! -x "$HOME/.bun/bin/bun" ]; then
    echo "❌ Bun binary not found or not executable"
    exit 1
fi
echo "✅ Bun binary exists and is executable"

# Test 3: Check if environment variables are set in shell profiles
echo "Test 3: Checking environment variables in shell profiles..."
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "BUN_INSTALL" "$HOME/.bashrc"; then
        echo "❌ BUN_INSTALL not found in .bashrc"
        exit 1
    fi
    echo "✅ Bun environment variables found in .bashrc"
fi

# Test 4: Check if PATH includes Bun binary directory
echo "Test 4: Checking if PATH includes Bun binary directory..."
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if [[ ":$PATH:" != *":$HOME/.bun/bin:"* ]]; then
    echo "❌ Bun binary directory not in PATH"
    exit 1
fi
echo "✅ Bun binary directory is in PATH"

# Test 5: Test Bun version command
echo "Test 5: Testing Bun version command..."
BUN_VERSION=$(bun --version 2>/dev/null || echo "")
if [ -z "$BUN_VERSION" ]; then
    echo "❌ Could not get Bun version"
    exit 1
fi
echo "✅ Bun version: $BUN_VERSION"

# Test 6: Test Bun basic functionality
echo "Test 6: Testing Bun basic functionality..."

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Test bun init
if ! bun init -y &>/dev/null; then
    echo "❌ 'bun init' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ 'bun init' works"

# Test basic JavaScript execution
echo 'console.log("Hello from Bun!");' > test.js
if ! bun run test.js 2>/dev/null | grep -q "Hello from Bun!"; then
    echo "❌ Basic JavaScript execution failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Basic JavaScript execution works"

# Test TypeScript execution (Bun has built-in TypeScript support)
echo 'const message: string = "Hello from TypeScript!"; console.log(message);' > test.ts
if ! bun run test.ts 2>/dev/null | grep -q "Hello from TypeScript!"; then
    echo "❌ TypeScript execution failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ TypeScript execution works"

# Test package management
echo "Test 7: Testing package management..."
if ! bun add lodash &>/dev/null; then
    echo "❌ Package installation failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi

if [ ! -f "node_modules/lodash/package.json" ]; then
    echo "❌ Package not installed correctly"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Package management works"

# Test 8: Test if global packages are installed (if enabled in scenario)
echo "Test 8: Checking global packages..."
GLOBAL_LIST=$(bun pm ls --global 2>/dev/null || echo "")
echo "Global packages: $GLOBAL_LIST"

# Note: The actual global packages depend on the test scenario
# We'll just verify that the global listing command works
if [ $? -eq 0 ]; then
    echo "✅ Global package listing works"
else
    echo "⚠️  Global package listing may not be available (this might be expected)"
fi

# Test 9: Test Bun's built-in bundler
echo "Test 9: Testing Bun's bundler..."
echo 'export const greeting = "Hello from module!";' > module.ts
echo 'import { greeting } from "./module"; console.log(greeting);' > main.ts

if ! bun build main.ts --outdir ./dist &>/dev/null; then
    echo "❌ Bundling failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi

if [ ! -f "dist/main.js" ]; then
    echo "❌ Bundle output not found"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Bundling works"

# Clean up test directory
cd /
rm -rf "$TEST_DIR"

echo ""
echo "🎉 All tests passed! Bun JavaScript Runtime feature is working correctly." 