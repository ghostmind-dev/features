#!/bin/bash

# Simple test script for AWS feature
set -e

echo "🧪 Testing AWS installation..."

# Test 1: Check if aws is installed and accessible
echo "Test 1: Checking if aws is in PATH..."
if ! command -v aws &> /dev/null; then
    echo "❌ aws command not found in PATH"
    exit 1
fi
echo "✅ aws found in PATH"

# Test 2: Check aws version
echo "Test 2: Checking aws version..."
AWS_VERSION=$(aws --version 2>&1)
echo "Installed version: $AWS_VERSION"
if [[ "$AWS_VERSION" == *"aws-cli/2"* ]]; then
    echo "✅ AWS v2 is installed"
else
    echo "❌ AWS v2 not detected"
    exit 1
fi

# Test 3: Test basic aws functionality
echo "Test 3: Testing basic aws functionality..."
aws help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ aws help command successful"
else
    echo "❌ aws help command failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! AWS feature is working correctly." 