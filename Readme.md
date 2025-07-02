# Ghostmind Dev Container Features

A collection of development container features for enhanced development environments.

## 🚀 Available Features

| Feature                                             | Description                                            | Registry                                     |
| --------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------- |
| [act](./features/src/act/README.md)                 | Act - run GitHub Actions locally                       | `ghcr.io/ghostmind-dev/features/act`         |
| [aws](./features/src/aws/README.md)                 | AWS v2 for managing AWS services                       | `ghcr.io/ghostmind-dev/features/aws`         |
| [bun](./features/src/bun/README.md)                 | Bun - fast all-in-one JavaScript runtime and toolkit   | `ghcr.io/ghostmind-dev/features/bun`         |
| [chromium](./features/src/chromium/README.md)       | Chromium browser for web development and testing       | `ghcr.io/ghostmind-dev/features/chromium`    |
| [cloudflared](./features/src/cloudflared/README.md) | Cloudflare Tunnel for secure localhost tunneling       | `ghcr.io/ghostmind-dev/features/cloudflared` |
| [config](./features/src/config/README.md)           | Configure VS Code settings for development environment | `ghcr.io/ghostmind-dev/features/config`      |
| [deno](./features/src/deno/README.md)               | Deno - modern runtime for JavaScript and TypeScript    | `ghcr.io/ghostmind-dev/features/deno`        |
| [gcloud](./features/src/gcloud/README.md)           | Google Cloud CLI with authentication and tools         | `ghcr.io/ghostmind-dev/features/gcloud`      |
| [init](./features/src/init/README.md)               | Initialize development environment with options        | `ghcr.io/ghostmind-dev/features/init`        |
| [kubernetes](./features/src/kubernetes/README.md)   | Kubernetes toolkit with kubectl, kind, k9s, and more   | `ghcr.io/ghostmind-dev/features/kubernetes`  |
| [npm](./features/src/npm/README.md)                 | NPM global configuration and package management        | `ghcr.io/ghostmind-dev/features/npm`         |
| [postgresql](./features/src/postgresql/README.md)   | PostgreSQL client tools for database management        | `ghcr.io/ghostmind-dev/features/postgresql`  |
| [run](./features/src/run/README.md)                 | Run CLI for development automation and scripting       | `ghcr.io/ghostmind-dev/features/run`         |
| [uv](./features/src/uv/README.md)                   | UV - extremely fast Python package manager             | `ghcr.io/ghostmind-dev/features/uv`          |
| [vault](./features/src/vault/README.md)             | HashiCorp Vault CLI for secrets management             | `ghcr.io/ghostmind-dev/features/vault`       |
| [zsh](./features/src/zsh/README.md)                 | ZSH with Oh My Zsh, themes, and useful plugins         | `ghcr.io/ghostmind-dev/features/zsh`         |
| [extensions](./features/src/extensions/README.md)   | VS Code Extensions Pack for development productivity   | `ghcr.io/ghostmind-dev/features/extensions`  |

## 📖 Usage

Add features to your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Dev Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/act:1": {},
    "ghcr.io/ghostmind-dev/features/aws:1": {},
    "ghcr.io/ghostmind-dev/features/bun:1": {
      "installGlobalPackages": true
    },
    "ghcr.io/ghostmind-dev/features/chromium:1": {},
    "ghcr.io/ghostmind-dev/features/cloudflared:1": {},
    "ghcr.io/ghostmind-dev/features/config:1": {
      "enableFeature": true
    },
    "ghcr.io/ghostmind-dev/features/deno:1": {},
    "ghcr.io/ghostmind-dev/features/gcloud:1": {
      "version": "405.0.0",
      "installBeta": false,
      "installGkeAuthPlugin": true
    },
    "ghcr.io/ghostmind-dev/features/init:1": {
      "enableFeature": true
    },
    "ghcr.io/ghostmind-dev/features/kubernetes:1": {
      "installSkaffold": true,
      "installKustomize": true
    },
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "installDefaultPackages": true,
      "packages": "typescript,prettier"
    },
    "ghcr.io/ghostmind-dev/features/postgresql:1": {},
    "ghcr.io/ghostmind-dev/features/run:1": {},
    "ghcr.io/ghostmind-dev/features/uv:1": {
      "installPython": true,
      "globalPackages": "ruff,black"
    },
    "ghcr.io/ghostmind-dev/features/vault:1": {},
    "ghcr.io/ghostmind-dev/features/zsh:1": {
      "theme": "spaceship"
    },
    "ghcr.io/ghostmind-dev/features/extensions:1": {}
  }
}
```

Click on any feature name in the table above to view detailed documentation and configuration options.

## 🏗️ Development

This repository uses the **`run custom`** development utility system for automating project tasks. All scripts are TypeScript modules executed with rich context and standardized patterns.

### 🔧 Development Scripts

All scripts use the format: `run custom <script-name> [arguments...] [--flags]`

#### Testing Features _(DevContainer)_

Test DevContainer features locally using the comprehensive testing system:

```bash
# List all available features for testing
run custom test

# Test all scenarios for a specific feature
run custom test npm

# Test a specific scenario
run custom test npm test_default

# List available scenarios for a feature
run custom test npm list-scenarios

# Test with verbose output and debugging
run custom test npm verbose no-cleanup

# Available options (as arguments, not flags):
# - verbose: Show detailed output during testing
# - no-cleanup: Keep containers after test for debugging
# - no-common-utils: Skip installing common utilities
```

**Example Testing Session:**

```bash
# Start by seeing what features are testable
run custom test

# List scenarios for the npm feature
run custom test npm list-scenarios

# Test the npm feature with verbose output
run custom test npm verbose

# Test specific scenario with debugging enabled
run custom test npm test_default verbose no-cleanup
```

#### Publishing Features _(DevContainer)_

Publish all features to the GitHub Container Registry:

```bash
# Publish all features to ghcr.io/ghostmind-dev/features/
run custom publish

# The script automatically:
# 1. Discovers all features in features/src/
# 2. Publishes each to ghcr.io/ghostmind-dev/features/
# 3. Creates versioned tags (1, 1.0, 1.0.0, latest)
```

#### Live Development Environment _(Host System)_

**⚠️ Important: This script must be run on the host system, outside of any DevContainer.**

Create a temporary DevContainer environment for testing local feature development:

```bash
# Create live environment for a feature
run custom live <feature-name>

# Create and auto-open in VS Code
run custom live <feature-name> --open
```

**How it works:**

1. Creates a temporary directory with your feature's DevContainer configuration
2. Copies local feature files (`devcontainer-feature.json`, `install.sh`)
3. Starts a DevContainer with your local changes
4. Provides connection instructions for VS Code/Cursor

**Example:**

```bash
# Test the 'npm' feature locally on host system
run custom live npm

# Output provides container connection details:
# 📦 Container Name: amazing_feature_container
# 💻 Connect with: code --remote=containers+amazing_feature_container
```

**Requirements:**

- Must be run on host system (not inside a DevContainer)
- Requires DevContainer CLI (`devcontainer up`)
- Feature must have `.devcontainer/devcontainer.json` in source directory

### 🛠️ Run Custom System

The `run custom` tool provides:

- **TypeScript Execution**: All scripts are TypeScript with full type safety
- **Rich Context**: Access to environment variables, project metadata, and utilities
- **Argument Parsing**: Easy access to positional arguments and flags
- **ZX Integration**: Built-in shell command execution with `$` from npm:zx
- **Standardized Patterns**: Consistent script structure across the project

**Script Structure:**

```typescript
import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx';

export default async function (args: CustomArgs, opts: CustomOptions) {
  // args[0] = first argument, args[1] = second argument, etc.
  // opts.has('flag-name') = check for boolean flags
  // opts.extract('key') = extract key-value flags
  // opts.env = environment variables
  // opts.currentPath = current working directory
}
```

## 📋 Feature Structure

Each feature follows this structure:

```
features/src/feature-name/
├── devcontainer-feature.json  # Feature metadata and options
├── install.sh                 # Installation script
└── README.md                  # Feature documentation

features/test/feature-name/
├── scenarios.json             # Test scenarios
└── test.sh                   # Test script
```

## 🤝 Contributing

1. Fork this repository
2. Create a new feature in `features/src/your-feature/`
3. Include:
   - `devcontainer-feature.json` with metadata
   - `install.sh` with installation logic
   - `README.md` with documentation
   - Test scenarios in `features/test/your-feature/`
4. Test your feature with `run custom test your-feature`
5. Submit a pull request

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

## 🔗 Links

- [Dev Container Specification](https://containers.dev/)
- [Feature Development Guide](https://containers.dev/implementors/features/)
- [GitHub Container Registry](https://ghcr.io)

---

**Maintained by:** [Ghostmind Dev](https://github.com/ghostmind-dev)
