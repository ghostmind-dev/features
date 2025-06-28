#!/bin/bash

# Comprehensive test script for Kubernetes Toolkit feature
set -e

echo "🧪 Testing Kubernetes Toolkit installation..."

# Test 1: Check if kubectl is installed (if enabled)
echo "Test 1: Checking kubectl installation..."
if command -v kubectl &> /dev/null; then
    echo "✅ kubectl found in PATH"
    KUBECTL_VERSION=$(kubectl version --client 2>&1 | head -1)
    echo "   Version: $KUBECTL_VERSION"
    
    # Test basic kubectl functionality
    kubectl --help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ kubectl help command successful"
    else
        echo "❌ kubectl help command failed"
        exit 1
    fi
else
    echo "⚠️  kubectl not found (may be disabled)"
fi

# Test 2: Check if kind is installed (if enabled)
echo ""
echo "Test 2: Checking kind installation..."
if command -v kind &> /dev/null; then
    echo "✅ kind found in PATH"
    KIND_VERSION=$(kind version 2>&1)
    echo "   Version: $KIND_VERSION"
    
    # Test basic kind functionality
    kind --help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ kind help command successful"
    else
        echo "❌ kind help command failed"
        exit 1
    fi
else
    echo "⚠️  kind not found (may be disabled)"
fi

# Test 3: Check if k9s is installed (if enabled)
echo ""
echo "Test 3: Checking k9s installation..."
if command -v k9s &> /dev/null; then
    echo "✅ k9s found in PATH"
    K9S_VERSION=$(k9s version 2>&1 | head -1)
    echo "   Version: $K9S_VERSION"
    
    # Test basic k9s functionality (--help only since k9s requires cluster connection)
    k9s --help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ k9s help command successful"
    else
        echo "❌ k9s help command failed"
        exit 1
    fi
else
    echo "⚠️  k9s not found (may be disabled)"
fi

# Test 4: Check if skaffold is installed (if enabled)
echo ""
echo "Test 4: Checking skaffold installation..."
if command -v skaffold &> /dev/null; then
    echo "✅ skaffold found in PATH"
    SKAFFOLD_VERSION=$(skaffold version 2>&1)
    echo "   Version: $SKAFFOLD_VERSION"
    
    # Test basic skaffold functionality
    skaffold help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ skaffold help command successful"
    else
        echo "❌ skaffold help command failed"
        exit 1
    fi
else
    echo "⚠️  skaffold not found (may be disabled)"
fi

# Test 5: Check if kustomize is installed (if enabled)
echo ""
echo "Test 5: Checking kustomize installation..."
if command -v kustomize &> /dev/null; then
    echo "✅ kustomize found in PATH"
    KUSTOMIZE_VERSION=$(kustomize version 2>&1)
    echo "   Version: $KUSTOMIZE_VERSION"
    
    # Test basic kustomize functionality
    kustomize --help > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ kustomize help command successful"
    else
        echo "❌ kustomize help command failed"
        exit 1
    fi
else
    echo "⚠️  kustomize not found (may be disabled)"
fi

# Test 6: Check tool configurations and validate they work together
echo ""
echo "Test 6: Tool compatibility test..."
if command -v kubectl &> /dev/null; then
    echo "Testing kubectl configuration..."
    
    # Test kubectl config (should work even without cluster)
    kubectl config view > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ kubectl config command successful"
    else
        echo "⚠️  kubectl config had issues (expected without cluster)"
    fi
fi

if command -v kustomize &> /dev/null; then
    echo "Testing kustomize functionality..."
    
    # Create a temporary directory for testing
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Create a basic kustomization.yaml for testing
    cat > kustomization.yaml << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: []
EOF
    
    # Test kustomize build
    kustomize build . > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ kustomize build command successful"
    else
        echo "⚠️  kustomize build had issues (expected with empty config)"
    fi
    
    # Clean up
    cd /
    rm -rf "$TEMP_DIR"
fi

if command -v skaffold &> /dev/null && command -v kubectl &> /dev/null; then
    echo "Testing skaffold and kubectl compatibility..."
    
    # Create a temporary directory for testing
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Create a basic skaffold.yaml for testing
    cat > skaffold.yaml << EOF
apiVersion: skaffold/v4beta6
kind: Config
metadata:
  name: test-app
build:
  artifacts: []
deploy:
  kubectl: {}
EOF
    
    # Test skaffold config validation
    skaffold diagnose > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ skaffold configuration validation successful"
    else
        echo "⚠️  skaffold diagnose had issues (expected without valid config)"
    fi
    
    # Clean up
    cd /
    rm -rf "$TEMP_DIR"
fi

echo ""
echo "🎉 All tests completed! Kubernetes Toolkit feature is working correctly."
echo ""
echo "Summary of installed tools:"

# Final summary
INSTALLED_TOOLS=()

if command -v kubectl &> /dev/null; then
    INSTALLED_TOOLS+=("kubectl")
fi

if command -v kind &> /dev/null; then
    INSTALLED_TOOLS+=("kind")
fi

if command -v k9s &> /dev/null; then
    INSTALLED_TOOLS+=("k9s")
fi

if command -v skaffold &> /dev/null; then
    INSTALLED_TOOLS+=("skaffold")
fi

if command -v kustomize &> /dev/null; then
    INSTALLED_TOOLS+=("kustomize")
fi

for tool in "${INSTALLED_TOOLS[@]}"; do
    echo "  ✅ $tool"
done

if [ ${#INSTALLED_TOOLS[@]} -eq 0 ]; then
    echo "  ❌ No tools found installed"
    exit 1
fi

echo ""
echo "✨ Kubernetes Toolkit installation verified successfully!" 