# Kubernetes Toolkit

This feature provides a comprehensive Kubernetes toolkit for development containers, including essential tools for Kubernetes development, testing, and cluster management.

## Features

This toolkit includes the following tools:

### Core Tools (installed by default)

- **kubectl** - The Kubernetes command-line tool for interacting with clusters
- **kind** - Kubernetes in Docker, for running local Kubernetes clusters
- **k9s** - A terminal-based UI for managing Kubernetes clusters

### Optional Tools

- **Skaffold** - Facilitates continuous development for Kubernetes applications
- **Kustomize** - Kubernetes configuration management tool for customizing YAML manifests

## Usage

### Basic Installation

To install the core Kubernetes tools with default settings:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {}
  }
}
```

### Custom Configuration

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {
      "installKubectl": true,
      "installKind": true,
      "kindVersion": "v0.26.0",
      "installK9s": true,
      "installSkaffold": true,
      "skaffoldVersion": "2.8.0",
      "installKustomize": true,
      "kustomizeVersion": "latest"
    }
  }
}
```

## Options

| Option             | Type    | Default     | Description                                    |
| ------------------ | ------- | ----------- | ---------------------------------------------- |
| `installKubectl`   | boolean | `true`      | Install kubectl CLI tool                       |
| `installKind`      | boolean | `true`      | Install kind (Kubernetes in Docker)            |
| `kindVersion`      | string  | `"v0.26.0"` | Version of kind to install                     |
| `installK9s`       | boolean | `true`      | Install k9s cluster management tool            |
| `installSkaffold`  | boolean | `false`     | Install Skaffold for development workflows     |
| `skaffoldVersion`  | string  | `"2.8.0"`   | Version of Skaffold to install                 |
| `installKustomize` | boolean | `false`     | Install Kustomize for configuration management |
| `kustomizeVersion` | string  | `"latest"`  | Version of Kustomize to install                |

## Examples

### Development Environment with All Tools

Perfect for Kubernetes application development:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {
      "installSkaffold": true,
      "installKustomize": true
    }
  }
}
```

### Cluster Management Only

For cluster administration and monitoring:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {
      "installSkaffold": false,
      "installKustomize": false
    }
  }
}
```

### Testing Environment

For CI/CD and testing with local clusters:

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {
      "kindVersion": "v0.26.0",
      "installSkaffold": false,
      "installKustomize": false
    }
  }
}
```

## Verification

After installation, you can verify the tools are working:

```bash
# Check kubectl
kubectl version --client

# Check kind
kind version

# Check k9s
k9s version

# Check skaffold (if installed)
skaffold version

# Check kustomize (if installed)
kustomize version
```

## Architecture Support

This feature supports both AMD64 (x86_64) and ARM64 (aarch64) architectures.

## Dependencies

- This feature installs after `ghcr.io/devcontainers/features/common-utils:2`
- Go toolchain is automatically installed when k9s is enabled (if not already present)

## OS Support

- Debian/Ubuntu based containers
- Alpine Linux (with some limitations)

## Notes

- **kubectl** is installed from the official Kubernetes apt repository
- **kind** is downloaded as a binary from the official GitHub releases
- **k9s** is compiled from source using Go
- **Skaffold** is downloaded as a binary from Google Cloud Storage
- **Kustomize** is installed using the official installation script

This feature consolidates multiple Kubernetes tools into a single, configurable installation, making it easier to set up comprehensive Kubernetes development environments.
