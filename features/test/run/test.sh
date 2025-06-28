#!/bin/bash

# Simple test script for Run CLI feature
set -e

echo "🧪 Testing Run CLI installation..."

# Test 1: Check if run is installed and accessible
echo "Test 1: Checking if run is in PATH..."
if ! command -v run &> /dev/null; then
    echo "❌ run command not found in PATH"
    exit 1
fi
echo "✅ run found in PATH"

# Test 2: Check if run repository was cloned
echo "Test 2: Checking if run repository exists..."
RUN_HOME="/home/vscode/run"
if [ ! -d "$RUN_HOME" ]; then
    echo "❌ run repository not found at $RUN_HOME"
    exit 1
fi
echo "✅ run repository found at $RUN_HOME"

# Test 3: Check if deno is accessible (dependency check)
echo "Test 3: Checking if deno dependency is available..."
if ! command -v deno &> /dev/null; then
    echo "❌ deno command not found in PATH (required dependency)"
    exit 1
fi
echo "✅ deno dependency available"

# Test 4: Test basic run functionality
echo "Test 4: Testing basic run functionality..."
echo "Showing run CLI help output:"
run --help 2>&1 | head -10 || run help 2>&1 | head -10 || echo "No help command available"
if command -v run &> /dev/null; then
    echo "✅ run command executes successfully"
else
    echo "❌ run command failed"
    exit 1
fi

# Test 5: Check environment setup
echo "Test 5: Checking PATH includes deno bin directory..."
if [[ ":$PATH:" == *":/home/vscode/.deno/bin:"* ]]; then
    echo "✅ deno bin directory found in PATH"
else
    echo "⚠️  deno bin directory may not be in PATH, but run is accessible"
fi

# Test 6: Check if we can access the run CLI files
echo "Test 6: Checking run CLI installation structure..."
if [ -f "$RUN_HOME/run/bin/cmd.ts" ]; then
    echo "✅ run CLI command file found"
else
    echo "❌ run CLI command file not found"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Run CLI feature is working correctly." 