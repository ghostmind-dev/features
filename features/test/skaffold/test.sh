#!/bin/bash

# Simple test script for Skaffold feature
set -e

echo "🧪 Testing Skaffold installation..."

# Test 1: Check if skaffold is installed and accessible
echo "Test 1: Checking if skaffold is in PATH..."
if ! command -v skaffold &> /dev/null; then
    echo "❌ skaffold command not found in PATH"
    exit 1
fi
echo "✅ skaffold found in PATH"

# Test 2: Check skaffold version
echo "Test 2: Checking skaffold version..."
SKAFFOLD_VERSION=$(skaffold version 2>&1)
echo "Installed version: $SKAFFOLD_VERSION"
if [[ "$SKAFFOLD_VERSION" == *"v2."* ]]; then
    echo "✅ Skaffold v2.x is installed"
else
    echo "❌ Skaffold v2.x not detected"
    exit 1
fi

# Test 3: Test basic skaffold functionality
echo "Test 3: Testing basic skaffold functionality..."
skaffold help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ skaffold help command successful"
else
    echo "❌ skaffold help command failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Skaffold feature is working correctly." 