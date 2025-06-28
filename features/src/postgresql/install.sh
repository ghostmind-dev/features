#!/bin/bash

set -e

# Import feature options
POSTGRESQL_VERSION=${VERSION:-"latest"}

echo "Installing PostgreSQL client..."

# Ensure we have required tools
echo "Installing required dependencies..."
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Install PostgreSQL client
echo "Installing postgresql-client..."
if [ "$POSTGRESQL_VERSION" = "latest" ]; then
    apt-get install -y postgresql-client
else
    # For specific versions, we would need to handle version-specific package names
    # For now, default to latest from apt
    echo "Note: Installing latest version from apt. Specific version handling not implemented."
    apt-get install -y postgresql-client
fi

# Verify installation
echo "Verifying PostgreSQL client installation..."
psql --version

echo "PostgreSQL client installation completed successfully!" 