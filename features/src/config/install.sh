#!/bin/bash

set -e

# Import feature options
ENABLE_FEATURE=${ENABLEFEATURE:-"true"}

echo "==========================================================================="
echo "Feature       : Config"
echo "Description   : Configure VS Code settings for development environment"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://github.com/ghostmind-dev/features/tree/main/features/src/config"
echo "Options       :"
echo "    ENABLEFEATURE=\"${ENABLE_FEATURE}\""
echo "==========================================================================="

if [ "${ENABLE_FEATURE}" = "false" ]; then
    echo "⏭️  Config feature is disabled, skipping VS Code settings configuration"
    exit 0
fi

echo "Installing Config feature..."

echo "✅ VS Code settings are being set up through dev container configuration"

echo "Config feature installation completed successfully!" 