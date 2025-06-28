#!/bin/bash

set -e

# Import feature options
ENABLE_FEATURE=${ENABLEFEATURE:-"false"}
INSTALL_COMPONENT=${INSTALLCOMPONENT:-"false"}

echo "==========================================================================="
echo "Feature       : Init"
echo "Description   : Initialize development environment with configurable options"
echo "Id            : $(basename "$(dirname "$0")" 2>/dev/null || echo "Unknown")"
echo "Version       : 1.0.0"
echo "Documentation : https://github.com/ghostmind-dev/features/tree/main/features/src/init"
echo "Options       :"
echo "    ENABLEFEATURE=\"${ENABLE_FEATURE}\""
echo "    INSTALLCOMPONENT=\"${INSTALL_COMPONENT}\""
echo "==========================================================================="

echo "Installing Init feature..."

# Set the environment variable for the container
ENV_VAR_NAME="INIT_FEATURE_ENABLED"
ENV_VAR_VALUE="${ENABLE_FEATURE}"

echo "Setting environment variable ${ENV_VAR_NAME}=${ENV_VAR_VALUE}..."

# Add environment variable to bash profile
echo "export ${ENV_VAR_NAME}=\"${ENV_VAR_VALUE}\"" >> /etc/bash.bashrc

# Add environment variable to profile for compatibility
echo "export ${ENV_VAR_NAME}=\"${ENV_VAR_VALUE}\"" >> /etc/profile

# Add to ZSH profile if it exists
if [ -f /etc/zsh/zshrc ]; then
    echo "export ${ENV_VAR_NAME}=\"${ENV_VAR_VALUE}\"" >> /etc/zsh/zshrc
fi

# Also add to /etc/environment for system-wide availability
echo "${ENV_VAR_NAME}=${ENV_VAR_VALUE}" >> /etc/environment

echo "✅ Environment variable ${ENV_VAR_NAME} set to ${ENV_VAR_VALUE}"
echo "✅ Available in bash, zsh, and system-wide"

# Handle installComponent option
COMPONENT_ENV_VAR_NAME="INIT_INSTALL_COMPONENT"
COMPONENT_ENV_VAR_VALUE="${INSTALL_COMPONENT}"

echo "Setting environment variable ${COMPONENT_ENV_VAR_NAME}=${COMPONENT_ENV_VAR_VALUE}..."

# Add component environment variable to bash profile
echo "export ${COMPONENT_ENV_VAR_NAME}=\"${COMPONENT_ENV_VAR_VALUE}\"" >> /etc/bash.bashrc

# Add component environment variable to profile for compatibility
echo "export ${COMPONENT_ENV_VAR_NAME}=\"${COMPONENT_ENV_VAR_VALUE}\"" >> /etc/profile

# Add to ZSH profile if it exists
if [ -f /etc/zsh/zshrc ]; then
    echo "export ${COMPONENT_ENV_VAR_NAME}=\"${COMPONENT_ENV_VAR_VALUE}\"" >> /etc/zsh/zshrc
fi

# Also add to /etc/environment for system-wide availability
echo "${COMPONENT_ENV_VAR_NAME}=${COMPONENT_ENV_VAR_VALUE}" >> /etc/environment

echo "✅ Environment variable ${COMPONENT_ENV_VAR_NAME} set to ${COMPONENT_ENV_VAR_VALUE}"

# Conditional component installation logic
if [ "${INSTALL_COMPONENT}" = "true" ]; then
    echo "🔧 Installing additional components..."
    echo "📦 Init feature components are being installed!"
    echo "✅ Component installation completed"
else
    echo "⏭️  Skipping component installation (installComponent=false)"
fi

echo "Init feature installation completed successfully!" 