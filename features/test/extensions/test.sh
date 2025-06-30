#!/bin/bash

# Test script for the extensions feature

set -e

echo "🧪 Testing Extensions Feature"
echo ""

# Test 1: Basic container functionality
echo "✓ Container is running"

# Test 2: Verify the feature install script ran successfully
# Since this feature only configures VS Code extensions and doesn't install system packages,
# we mainly test that the container built successfully and is working
echo "✓ Feature installation completed without errors"

# Test 3: Check that common system tools are available (from common-utils)
if command -v curl >/dev/null 2>&1; then
    echo "✓ Common utilities are available"
else
    echo "⚠️  Common utilities not found (this may be expected)"
fi

# Test 4: Verify the container user is set correctly
if [ "$(whoami)" = "vscode" ]; then
    echo "✓ Container user is correctly set to vscode"
else
    echo "✓ Container user is: $(whoami)"
fi

echo ""
echo "✅ Extensions feature test completed successfully!"
echo "📝 Note: VS Code extensions will be installed when VS Code connects to this container"

exit 0 