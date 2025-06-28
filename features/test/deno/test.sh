#!/bin/bash

# Simple test script for Deno feature
set -e

echo "🧪 Testing Deno installation..."

# Test 1: Check if deno is installed and accessible
echo "Test 1: Checking if deno is in PATH..."
if ! command -v deno &> /dev/null; then
    echo "❌ deno command not found in PATH"
    exit 1
fi
echo "✅ deno found in PATH"

# Test 2: Check deno version
echo "Test 2: Checking deno version..."
DENO_VERSION=$(deno --version)
echo "Installed version: $DENO_VERSION"
if [[ "$DENO_VERSION" == *"deno"* ]]; then
    echo "✅ Deno is installed and accessible"
else
    echo "❌ Deno version check failed"
    exit 1
fi

# Test 3: Test basic deno functionality
echo "Test 3: Testing basic deno functionality..."
deno eval "console.log('Hello from Deno!')" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ deno eval command successful"
else
    echo "❌ deno eval command failed"
    exit 1
fi

# Test 4: Check environment variables
echo "Test 4: Checking environment variables..."
if [ -z "$DENO_INSTALL" ]; then
    echo "❌ DENO_INSTALL environment variable not set"
    exit 1
fi
echo "✅ DENO_INSTALL is set to: $DENO_INSTALL"

if [ -z "$DENO_DIR" ]; then
    echo "❌ DENO_DIR environment variable not set"
    exit 1
fi
echo "✅ DENO_DIR is set to: $DENO_DIR"

echo ""
echo "🎉 All tests passed! Deno feature is working correctly." 