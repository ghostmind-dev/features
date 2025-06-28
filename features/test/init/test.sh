#!/bin/bash

# Test script for init feature
set -e

echo "🧪 Testing init feature installation..."

# Test 1: Check if environment variable is set
echo "Test 1: Checking if INIT_FEATURE_ENABLED environment variable is set..."
if [ -z "${INIT_FEATURE_ENABLED}" ]; then
    echo "❌ INIT_FEATURE_ENABLED environment variable is not set"
    exit 1
fi
echo "✅ INIT_FEATURE_ENABLED is set to: ${INIT_FEATURE_ENABLED}"

# Test 2: Verify environment variable is in /etc/environment
echo "Test 2: Checking if environment variable is in /etc/environment..."
if ! grep -q "INIT_FEATURE_ENABLED" /etc/environment; then
    echo "❌ INIT_FEATURE_ENABLED not found in /etc/environment"
    exit 1
fi
echo "✅ INIT_FEATURE_ENABLED found in /etc/environment"

# Test 3: Verify environment variable is in bash profile
echo "Test 3: Checking if environment variable is in /etc/bash.bashrc..."
if ! grep -q "INIT_FEATURE_ENABLED" /etc/bash.bashrc; then
    echo "❌ INIT_FEATURE_ENABLED not found in /etc/bash.bashrc"
    exit 1
fi
echo "✅ INIT_FEATURE_ENABLED found in /etc/bash.bashrc"

# Test 4: Verify environment variable is in profile
echo "Test 4: Checking if environment variable is in /etc/profile..."
if ! grep -q "INIT_FEATURE_ENABLED" /etc/profile; then
    echo "❌ INIT_FEATURE_ENABLED not found in /etc/profile"
    exit 1
fi
echo "✅ INIT_FEATURE_ENABLED found in /etc/profile"

# Test 5: Verify the value is correct based on the scenario
echo "Test 5: Verifying environment variable value..."
if [ "${INIT_FEATURE_ENABLED}" = "true" ]; then
    echo "✅ INIT_FEATURE_ENABLED is correctly set to true"
elif [ "${INIT_FEATURE_ENABLED}" = "false" ]; then
    echo "✅ INIT_FEATURE_ENABLED is correctly set to false"
else
    echo "❌ INIT_FEATURE_ENABLED has unexpected value: ${INIT_FEATURE_ENABLED}"
    exit 1
fi

# Test 6: Check if install component environment variable is set
echo "Test 6: Checking if INIT_INSTALL_COMPONENT environment variable is set..."
if [ -z "${INIT_INSTALL_COMPONENT}" ]; then
    echo "❌ INIT_INSTALL_COMPONENT environment variable is not set"
    exit 1
fi
echo "✅ INIT_INSTALL_COMPONENT is set to: ${INIT_INSTALL_COMPONENT}"

# Test 7: Verify install component environment variable is in /etc/environment
echo "Test 7: Checking if INIT_INSTALL_COMPONENT is in /etc/environment..."
if ! grep -q "INIT_INSTALL_COMPONENT" /etc/environment; then
    echo "❌ INIT_INSTALL_COMPONENT not found in /etc/environment"
    exit 1
fi
echo "✅ INIT_INSTALL_COMPONENT found in /etc/environment"

# Test 8: Verify install component environment variable is in bash profile
echo "Test 8: Checking if INIT_INSTALL_COMPONENT is in /etc/bash.bashrc..."
if ! grep -q "INIT_INSTALL_COMPONENT" /etc/bash.bashrc; then
    echo "❌ INIT_INSTALL_COMPONENT not found in /etc/bash.bashrc"
    exit 1
fi
echo "✅ INIT_INSTALL_COMPONENT found in /etc/bash.bashrc"

# Test 9: Verify install component environment variable is in profile
echo "Test 9: Checking if INIT_INSTALL_COMPONENT is in /etc/profile..."
if ! grep -q "INIT_INSTALL_COMPONENT" /etc/profile; then
    echo "❌ INIT_INSTALL_COMPONENT not found in /etc/profile"
    exit 1
fi
echo "✅ INIT_INSTALL_COMPONENT found in /etc/profile"

# Test 10: Verify the install component value is correct
echo "Test 10: Verifying INIT_INSTALL_COMPONENT value..."
if [ "${INIT_INSTALL_COMPONENT}" = "true" ]; then
    echo "✅ INIT_INSTALL_COMPONENT is correctly set to true"
elif [ "${INIT_INSTALL_COMPONENT}" = "false" ]; then
    echo "✅ INIT_INSTALL_COMPONENT is correctly set to false"
else
    echo "❌ INIT_INSTALL_COMPONENT has unexpected value: ${INIT_INSTALL_COMPONENT}"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Init feature is working correctly."
echo "Environment variable INIT_FEATURE_ENABLED = ${INIT_FEATURE_ENABLED}"
echo "Environment variable INIT_INSTALL_COMPONENT = ${INIT_INSTALL_COMPONENT}" 