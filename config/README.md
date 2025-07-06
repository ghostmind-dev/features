# DevContainer Schema for Ghostmind Features

This directory contains a JSON schema that extends the official DevContainer specification to provide auto-completion support for all ghostmind-dev features.

## Overview

The schema extends the base DevContainer schema from Microsoft and adds specific definitions for all ghostmind-dev features, providing:

- **Auto-completion** for feature IDs
- **Option suggestions** for each feature
- **Type validation** for all feature options
- **Documentation** inline with descriptions and default values

## How to Use

### Method 1: VS Code Settings (Recommended)

Add the schema to your VS Code settings to enable auto-completion for all `devcontainer.json` files:

1. Open VS Code Settings (JSON)
2. Add the following configuration:

```json
{
  "json.schemas": [
    {
      "fileMatch": [
        "**/devcontainer.json",
        "**/.devcontainer/devcontainer.json"
      ],
      "url": "https://raw.githubusercontent.com/ghostmind-dev/features/main/config/schema.json"
    }
  ]
}
```

### Method 2: Schema Reference in DevContainer Files

Add a schema reference directly to your `devcontainer.json` files:

```json
{
  "$schema": "https://raw.githubusercontent.com/ghostmind-dev/features/main/config/schema.json",
  "name": "My Dev Container",
  "image": "ghcr.io/ghostmind-dev/dvc:dev",
  "features": {
    "ghcr.io/ghostmind-dev/features/init": {
      "resetLive": false,
      "baseZshrc": true,
      "denoConfig": true
    }
  }
}
```

### Method 3: Local Schema File

You can also reference the schema locally if you have this repository checked out:

```json
{
  "$schema": "./config/schema.json",
  "name": "My Dev Container",
  "features": {
    "ghcr.io/ghostmind-dev/features/aws": {
      "version": "latest"
    }
  }
}
```

## Features Covered

The schema provides auto-completion for all ghostmind-dev features:

| Feature       | Description                | Options                                          |
| ------------- | -------------------------- | ------------------------------------------------ |
| `act`         | Run GitHub Actions locally | `version`                                        |
| `aws`         | AWS CLI v2                 | `version`                                        |
| `bun`         | Bun JavaScript runtime     | `version`, `installGlobalPackages`, `packages`   |
| `chromium`    | Chromium browser           | None                                             |
| `cloudflared` | Cloudflare tunnels         | `version`                                        |
| `deno`        | Deno runtime               | `version`                                        |
| `extensions`  | VS Code extensions pack    | None                                             |
| `gcloud`      | Google Cloud CLI           | `version`, `installBeta`, `installGkeAuthPlugin` |
| `init`        | Environment initialization | Multiple boolean and string options              |
| `kubernetes`  | Kubernetes toolkit         | Multiple install flags and version options       |
| `npm`         | NPM global packages        | `packages`                                       |
| `postgresql`  | PostgreSQL client          | `version`                                        |
| `run`         | Run CLI utility            | None                                             |
| `settings`    | VS Code settings           | `enableFeature`                                  |
| `themes`      | VS Code themes pack        | None                                             |
| `uv`          | UV Python package manager  | `version`, `installPython`, `globalPackages`     |
| `vault`       | HashiCorp Vault CLI        | `version`                                        |
| `zsh`         | ZSH with Oh My Zsh         | `installFeature`, `theme`                        |

## Example Usage

```json
{
  "$schema": "https://raw.githubusercontent.com/ghostmind-dev/features/main/config/schema.json",
  "name": "Full Stack Development",
  "image": "ghcr.io/ghostmind-dev/dvc:dev",
  "features": {
    "ghcr.io/ghostmind-dev/features/init": {
      "resetLive": false,
      "baseZshrc": true,
      "denoConfig": true,
      "loginGcp": true,
      "loginGhcr": true,
      "pythonVersion": "3.11.0"
    },
    "ghcr.io/ghostmind-dev/features/aws": {
      "version": "latest"
    },
    "ghcr.io/ghostmind-dev/features/kubernetes": {
      "installKubectl": true,
      "installKind": true,
      "kindVersion": "v0.26.0",
      "installK9s": true,
      "installSkaffold": false
    },
    "ghcr.io/ghostmind-dev/features/extensions": {},
    "ghcr.io/ghostmind-dev/features/themes": {},
    "ghcr.io/ghostmind-dev/features/settings": {
      "enableFeature": true
    }
  }
}
```

## Schema Features

### Base Schema Inheritance

The schema extends the official DevContainer schema, so you get all the standard DevContainer properties with validation plus the additional feature-specific auto-completion.

### Feature Definitions

Each feature has a detailed schema definition with:

- **Type validation** - Ensures correct data types
- **Default values** - Shows recommended defaults
- **Descriptions** - Explains what each option does
- **Enum constraints** - Where applicable (e.g., ZSH themes)

### Version Support

The schema supports both versioned and non-versioned feature references:

- `ghcr.io/ghostmind-dev/features/aws` (latest)
- `ghcr.io/ghostmind-dev/features/aws:1` (specific version)

## Updating the Schema

When new features are added or existing features are updated, the schema should be updated accordingly. The schema is automatically available via the GitHub URL, so users will get the latest definitions without needing to update their local configurations.

## Validation

The schema provides comprehensive validation for:

- Feature ID format
- Option types (boolean, string, etc.)
- Enum values (where applicable)
- Required vs optional properties
- Additional properties (disabled to prevent typos)

This helps catch configuration errors early and ensures your DevContainer configurations are valid.
