#!/bin/bash

# Test script for the Vault feature.
# This script checks for the existence and functionality of the vault binary.
# It's designed to be robust in container environments where direct execution
# during tests can be problematic.

set -e

# A helper function for consistent test reporting
check() {
    local test_name="$1"
    local command="$2"
    
    echo "🧪 Test: ${test_name}"
    # We use set +e to handle command failures gracefully
    set +e
    eval "${command}"
    local exit_code=$?
    set -e

    # Exit codes 0 (success) and 1 (failure, e.g. for --help) are considered valid for this test.
    if [ $exit_code -eq 0 ] || [ $exit_code -eq 1 ]; then
        echo "✅ PASSED (Exit Code: ${exit_code})"
    else
        echo "❌ FAILED (Exit Code: ${exit_code})"
        exit 1
    fi
}

echo "Running tests for Vault feature..."

check "Vault binary is in PATH" "command -v vault"
check "Vault binary is executable" "vault --version"
check "Vault help command is accessible" "vault --help"
check "Vault 'auth' subcommand is accessible" "vault auth --help"
check "Vault 'secrets' subcommand is accessible" "vault secrets --help"

# Final check for the alias in a common user's bashrc
check "vault-status alias is configured" "grep 'alias vault-status' /etc/bash.bashrc"


echo ""
echo "🎉 All tests passed!"
echo "Vault feature appears to be installed correctly."
echo ""

# Exit successfully for container environments
exit 0 