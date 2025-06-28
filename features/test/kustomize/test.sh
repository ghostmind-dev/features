#!/bin/bash

# Simple test script for Kustomize feature
set -e

echo "🧪 Testing Kustomize installation..."

# Test 1: Check if kustomize is installed and accessible
echo "Test 1: Checking if kustomize is in PATH..."
if ! command -v kustomize &> /dev/null; then
    echo "❌ kustomize command not found in PATH"
    exit 1
fi
echo "✅ kustomize found in PATH"

# Test 2: Check kustomize version
echo "Test 2: Checking kustomize version..."
KUSTOMIZE_VERSION=$(kustomize version 2>&1)
echo "Installed version: $KUSTOMIZE_VERSION"
if [[ "$KUSTOMIZE_VERSION" == v* ]]; then
    echo "✅ Kustomize is installed and accessible"
else
    echo "❌ Kustomize version output unexpected"
    exit 1
fi

# Test 3: Test basic kustomize functionality
echo "Test 3: Testing basic kustomize functionality..."
kustomize --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ kustomize help command successful"
else
    echo "❌ kustomize help command failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Kustomize feature is working correctly." 