
# Kubernetes Toolkit (kubernetes)

Comprehensive Kubernetes toolkit including kubectl, kind, k9s, and optional tools like skaffold and kustomize

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installKubectl | Install kubectl CLI tool | boolean | true |
| installKind | Install kind (Kubernetes in Docker) | boolean | true |
| kindVersion | Version of kind to install (default: v0.26.0) | string | v0.26.0 |
| installK9s | Install k9s (Kubernetes cluster management tool) | boolean | true |
| installSkaffold | Install Skaffold for Kubernetes development workflows | boolean | false |
| skaffoldVersion | Version of Skaffold to install (default: 2.8.0) | string | 2.8.0 |
| installKustomize | Install Kustomize for Kubernetes configuration management | boolean | false |
| kustomizeVersion | Version of Kustomize to install (default: latest) | string | latest |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ghostmind-dev/features/blob/main/features/src/kubernetes/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
