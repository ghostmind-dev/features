#!/bin/bash

# Simple test script for act feature
set -e

echo "🧪 Testing act installation..."

# Test 1: Check if act is installed and accessible
echo "Test 1: Checking if act is in PATH..."
if ! command -v act &> /dev/null; then
    echo "❌ act command not found in PATH"
    exit 1
fi
echo "✅ act found in PATH"

# Test 2: Check act version
echo "Test 2: Checking act version..."
ACT_VERSION=$(act --version 2>&1)
echo "Installed version: $ACT_VERSION"
if [[ "$ACT_VERSION" == *"act version"* ]]; then
    echo "✅ act version command successful"
else
    echo "❌ act version command failed or unexpected output"
    exit 1
fi

# Test 3: Test basic act functionality
echo "Test 3: Testing basic act help functionality..."
act --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ act help command successful"
else
    echo "❌ act help command failed"
    exit 1
fi

# Test 4: Check if act binary is executable
echo "Test 4: Checking if act binary is executable..."
if [ -x "/usr/local/bin/act" ]; then
    echo "✅ act binary is executable"
else
    echo "❌ act binary is not executable"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Act feature is working correctly." 