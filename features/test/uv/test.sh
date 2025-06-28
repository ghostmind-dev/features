#!/bin/bash

# Test script for uv Python Package Manager feature
set -e

echo "🧪 Testing uv Python Package Manager installation..."

# Test 1: Check if uv binary exists and is executable
echo "Test 1: Checking if uv binary exists and is executable..."
if [ ! -f "$HOME/.local/bin/uv" ] || [ ! -x "$HOME/.local/bin/uv" ]; then
    echo "❌ uv binary not found or not executable"
    exit 1
fi
echo "✅ uv binary exists and is executable"

# Test 2: Check if environment variables are set in shell profiles
echo "Test 2: Checking environment variables in shell profiles..."
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q ".local/bin" "$HOME/.bashrc"; then
        echo "❌ .local/bin not found in .bashrc PATH"
        exit 1
    fi
    echo "✅ uv path found in .bashrc"
fi

# Test 3: Check if PATH includes uv binary directory
echo "Test 3: Checking if PATH includes uv binary directory..."
export PATH="$HOME/.local/bin:$PATH"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "❌ uv binary directory not in PATH"
    exit 1
fi
echo "✅ uv binary directory is in PATH"

# Test 4: Test uv version command
echo "Test 4: Testing uv version command..."
UV_VERSION=$(uv --version 2>/dev/null || echo "")
if [ -z "$UV_VERSION" ]; then
    echo "❌ Could not get uv version"
    exit 1
fi
echo "✅ uv version: $UV_VERSION"

# Test 5: Test uv help command
echo "Test 5: Testing uv help command..."
if ! uv --help &>/dev/null; then
    echo "❌ 'uv --help' failed"
    exit 1
fi
echo "✅ 'uv --help' works"

# Test 6: Test uv basic project functionality
echo "Test 6: Testing uv basic project functionality..."

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Test uv init
if ! uv init test-project --no-readme &>/dev/null; then
    echo "❌ 'uv init' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ 'uv init' works"

cd test-project

# Test adding a dependency
echo "Test 7: Testing package management..."
if ! uv add requests &>/dev/null; then
    echo "❌ 'uv add requests' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check if pyproject.toml was updated
if [ ! -f "pyproject.toml" ]; then
    echo "❌ pyproject.toml not found"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! grep -q "requests" pyproject.toml; then
    echo "❌ requests not found in pyproject.toml"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Package management works"

# Test 8: Test uv sync (install dependencies)
echo "Test 8: Testing dependency installation..."
if ! uv sync &>/dev/null; then
    echo "❌ 'uv sync' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check if virtual environment was created
if [ ! -d ".venv" ]; then
    echo "❌ Virtual environment not created"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Dependency installation and virtual environment creation works"

# Test 9: Test running Python code
echo "Test 9: Testing Python code execution..."
echo 'import requests; print("Hello from uv!")' > test_script.py

if ! uv run test_script.py 2>/dev/null | grep -q "Hello from uv!"; then
    echo "❌ Python script execution failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Python script execution works"

# Test 10: Test uv remove
echo "Test 10: Testing package removal..."
if ! uv remove requests &>/dev/null; then
    echo "❌ 'uv remove requests' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi

if grep -q "requests" pyproject.toml; then
    echo "❌ requests still found in pyproject.toml after removal"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Package removal works"

# Test 11: Test uv python functionality
echo "Test 11: Testing Python version management..."
if ! uv python list &>/dev/null; then
    echo "❌ 'uv python list' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Python version management works"

# Test 12: Test uv tool functionality (basic command)
echo "Test 12: Testing tool management..."
if ! uv tool list &>/dev/null; then
    echo "❌ 'uv tool list' failed"
    cd /
    rm -rf "$TEST_DIR"
    exit 1
fi
echo "✅ Tool management works"

# Clean up test directory
cd /
rm -rf "$TEST_DIR"

echo ""
echo "🎉 All tests passed! uv Python Package Manager feature is working correctly." 