#!/bin/bash

# Test script for init feature
set -e

echo "🧪 Testing init feature installation..."

# Test 1: Check if core environment variables are set
echo "Test 1: Checking if core INIT_* environment variables are set..."
required_vars=("INIT_BASE_ZSHRC" "INIT_DENO_CONFIG" "INIT_CORE_SECRETS" "INIT_LOGIN_GCP" "INIT_QUOTE_AI")

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ ${var} environment variable is not set"
        exit 1
    fi
    echo "✅ ${var} is set to: ${!var}"
done

# Test 2: Verify environment variables are in /etc/environment
echo "Test 2: Checking if INIT_ variables are in /etc/environment..."
for var in "${required_vars[@]}"; do
    if ! grep -q "${var}" /etc/environment; then
        echo "❌ ${var} not found in /etc/environment"
        exit 1
    fi
done
echo "✅ All required INIT_ variables found in /etc/environment"

# Test 3: Verify environment variables are in bash profile
echo "Test 3: Checking if INIT_ variables are in /etc/bash.bashrc..."
for var in "${required_vars[@]}"; do
    if ! grep -q "${var}" /etc/bash.bashrc; then
        echo "❌ ${var} not found in /etc/bash.bashrc"
        exit 1
    fi
done
echo "✅ All required INIT_ variables found in /etc/bash.bashrc"

# Test 4: Verify environment variables are in profile
echo "Test 4: Checking if INIT_ variables are in /etc/profile..."
for var in "${required_vars[@]}"; do
    if ! grep -q "${var}" /etc/profile; then
        echo "❌ ${var} not found in /etc/profile"
        exit 1
    fi
done
echo "✅ All required INIT_ variables found in /etc/profile"

# Test 5: Verify all INIT_ variables exist
echo "Test 5: Checking for all expected INIT_ environment variables..."
all_init_vars=(
    "INIT_RESET_LIVE"
    "INIT_BASE_ZSHRC"
    "INIT_DENO_CONFIG"
    "INIT_DENO_JUPYTER"
    "INIT_CORE_SECRETS"
    "INIT_LOGIN_NPM"
    "INIT_LOGIN_GCP"
    "INIT_LOGIN_GHCR"
    "INIT_LOGIN_NVCR"
    "INIT_LOGIN_VAULT"
    "INIT_LOGIN_CLOUDFLARE"
    "INIT_PYTHON_VERSION"
    "INIT_RESET_DOCS"
    "INIT_RESET_DOCS_NAME"
    "INIT_TMUX_CONFIG"
    "INIT_QUOTE_AI"
)

for var in "${all_init_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ ${var} environment variable is not set"
        exit 1
    fi
done
echo "✅ All 16 INIT_ environment variables are set"

# Test 6: Verify boolean values are valid
echo "Test 6: Verifying boolean environment variable values..."
boolean_vars=(
    "INIT_RESET_LIVE"
    "INIT_BASE_ZSHRC"
    "INIT_DENO_CONFIG"
    "INIT_DENO_JUPYTER"
    "INIT_CORE_SECRETS"
    "INIT_LOGIN_NPM"
    "INIT_LOGIN_GCP"
    "INIT_LOGIN_GHCR"
    "INIT_LOGIN_NVCR"
    "INIT_LOGIN_VAULT"
    "INIT_LOGIN_CLOUDFLARE"
    "INIT_RESET_DOCS"
    "INIT_TMUX_CONFIG"
    "INIT_QUOTE_AI"
)

for var in "${boolean_vars[@]}"; do
    value="${!var}"
    if [ "$value" != "true" ] && [ "$value" != "false" ]; then
        echo "❌ ${var} has invalid boolean value: ${value}"
        exit 1
    fi
done
echo "✅ All boolean environment variables have valid values"

# Test 7: Verify string values are non-empty
echo "Test 7: Verifying string environment variable values..."
if [ -z "$INIT_PYTHON_VERSION" ]; then
    echo "❌ INIT_PYTHON_VERSION is empty"
    exit 1
fi

if [ -z "$INIT_RESET_DOCS_NAME" ]; then
    echo "❌ INIT_RESET_DOCS_NAME is empty"
    exit 1
fi
echo "✅ String environment variables have valid values"
echo "   INIT_PYTHON_VERSION = ${INIT_PYTHON_VERSION}"
echo "   INIT_RESET_DOCS_NAME = ${INIT_RESET_DOCS_NAME}"

# Test 8: Count total INIT_ variables
echo "Test 8: Counting total INIT_ environment variables..."
init_count=$(env | grep -c "^INIT_" || true)
if [ "$init_count" -lt 16 ]; then
    echo "❌ Expected at least 16 INIT_ variables, found: ${init_count}"
    exit 1
fi
echo "✅ Found ${init_count} INIT_ environment variables"

echo ""
echo "🎉 All tests passed! Init feature is working correctly."
echo ""
echo "📋 Environment Variables Summary:"
env | grep "^INIT_" | sort
echo ""
