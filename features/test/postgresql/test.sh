#!/bin/bash

# Simple test script for PostgreSQL client feature
set -e

echo "🧪 Testing PostgreSQL client installation..."

# Test 1: Check if psql is installed and accessible
echo "Test 1: Checking if psql is in PATH..."
if ! command -v psql &> /dev/null; then
    echo "❌ psql command not found in PATH"
    exit 1
fi
echo "✅ psql found in PATH"

# Test 2: Check psql version
echo "Test 2: Checking psql version..."
PSQL_VERSION=$(psql --version)
echo "Installed version: $PSQL_VERSION"
if [[ "$PSQL_VERSION" == *"psql"* ]]; then
    echo "✅ PostgreSQL client is installed"
else
    echo "❌ PostgreSQL client not detected"
    exit 1
fi

# Test 3: Check if pg_dump is available
echo "Test 3: Checking if pg_dump is available..."
if ! command -v pg_dump &> /dev/null; then
    echo "❌ pg_dump command not found in PATH"
    exit 1
fi
echo "✅ pg_dump found in PATH"

# Test 4: Check if pg_restore is available
echo "Test 4: Checking if pg_restore is available..."
if ! command -v pg_restore &> /dev/null; then
    echo "❌ pg_restore command not found in PATH"
    exit 1
fi
echo "✅ pg_restore found in PATH"

# Test 5: Test basic psql functionality (help command)
echo "Test 5: Testing basic psql functionality..."
psql --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ psql help command successful"
else
    echo "❌ psql help command failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! PostgreSQL client feature is working correctly." 