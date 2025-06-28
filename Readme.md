# Ghostmind Dev Container Features

A collection of development container features for enhanced development environments.

## 🚀 Available Features

| Feature                               | Description                                         | Registry                                   |
| ------------------------------------- | --------------------------------------------------- | ------------------------------------------ |
| [act](./features/src/act)             | Act - run GitHub Actions locally                    | `ghcr.io/ghostmind-dev/features/act`       |
| [aws](./features/src/aws)             | AWS v2 for managing AWS services                    | `ghcr.io/ghostmind-dev/features/aws`       |
| [deno](./features/src/deno)           | Deno - modern runtime for JavaScript and TypeScript | `ghcr.io/ghostmind-dev/features/deno`      |
| [gcloud](./features/src/gcloud)       | Google Cloud CLI with authentication and tools      | `ghcr.io/ghostmind-dev/features/gcloud`    |
| [init](./features/src/init)           | Initialize development environment with options     | `ghcr.io/ghostmind-dev/features/init`      |
| [kustomize](./features/src/kustomize) | Kustomize for Kubernetes configuration management   | `ghcr.io/ghostmind-dev/features/kustomize` |
| [npm](./features/src/npm)             | NPM global configuration and package management     | `ghcr.io/ghostmind-dev/features/npm`       |
| [skaffold](./features/src/skaffold)   | Skaffold for Kubernetes development workflows       | `ghcr.io/ghostmind-dev/features/skaffold`  |
| [vault](./features/src/vault)         | HashiCorp Vault CLI for secrets management          | `ghcr.io/ghostmind-dev/features/vault`     |
| [zsh](./features/src/zsh)             | ZSH with Oh My Zsh, themes, and useful plugins      | `ghcr.io/ghostmind-dev/features/zsh`       |

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
    "ghcr.io/ghostmind-dev/features/deno:1": {},
    "ghcr.io/ghostmind-dev/features/gcloud:1": {
      "version": "405.0.0",
      "installBeta": false,
      "installGkeAuthPlugin": true
    },
    "ghcr.io/ghostmind-dev/features/init:1": {
      "enableFeature": true
    },
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "installDefaultPackages": true,
      "packages": "typescript,prettier"
    },
    "ghcr.io/ghostmind-dev/features/kustomize:1": {},
    "ghcr.io/ghostmind-dev/features/skaffold:1": {},
    "ghcr.io/ghostmind-dev/features/vault:1": {},
    "ghcr.io/ghostmind-dev/features/zsh:1": {
      "theme": "spaceship"
    }
  }
}
```

## 🔧 Features

### Act (`act`)

**Registry:** `ghcr.io/ghostmind-dev/features/act`

Installs [act](https://github.com/nektos/act) - a tool to run GitHub Actions locally for testing and development with:

- Multi-architecture support (amd64, arm64)
- Configurable version installation
- Automatic PATH configuration
- Clean installation process

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/act:1": {}
```

**With Custom Version:**

```json
"ghcr.io/ghostmind-dev/features/act:1": {
  "version": "0.2.60"
}
```

[📚 Full Documentation](./features/src/act/README.md)

### AWS (`aws`)

**Registry:** `ghcr.io/ghostmind-dev/features/aws`

Installs the AWS CLI v2 for managing AWS services with:

- Multi-architecture support (amd64, arm64)
- Latest AWS v2 installation
- Automatic PATH configuration
- Clean installation process

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/aws:1": {}
```

[📚 Full Documentation](./features/src/aws/README.md)

### Deno (`deno`)

**Registry:** `ghcr.io/ghostmind-dev/features/deno`

Installs Deno, a modern runtime for JavaScript and TypeScript with:

- Secure by default (no file, network, or environment access unless explicitly enabled)
- TypeScript support out of the box
- Built-in utilities like bundler, formatter, test runner, and linter
- V8 JavaScript engine with Rust implementation
- Configurable version installation
- Environment variables setup (DENO_INSTALL, DENO_DIR, PATH)

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/deno:1": {}
```

**With Custom Version:**

```json
"ghcr.io/ghostmind-dev/features/deno:1": {
  "version": "v1.45.5"
}
```

[📚 Full Documentation](./features/src/deno/README.md)

### Google Cloud CLI (`gcloud`)

**Registry:** `ghcr.io/ghostmind-dev/features/gcloud`

Installs the Google Cloud CLI with support for:

- Multiple architectures (amd64, arm64)
- Configurable version installation
- Optional beta components
- GKE authentication plugin
- Automatic PATH configuration

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/gcloud:1": {}
```

**With Options:**

```json
"ghcr.io/ghostmind-dev/features/gcloud:1": {
  "version": "latest",
  "installBeta": true,
  "installGkeAuthPlugin": true
}
```

[📚 Full Documentation](./features/src/gcloud/README.md)

### Init (`init`)

**Registry:** `ghcr.io/ghostmind-dev/features/init`

Initializes development environment with configurable options that are set as environment variables with:

- Boolean option to enable/disable features
- Boolean option to install additional components
- Environment variable `INIT_FEATURE_ENABLED` available system-wide
- Environment variable `INIT_INSTALL_COMPONENT` available system-wide
- Multi-shell support (bash, zsh, system-wide)
- Persistent environment variable configuration

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/init:1": {}
```

**Enable the feature:**

```json
"ghcr.io/ghostmind-dev/features/init:1": {
  "enableFeature": true
}
```

**Enable with component installation:**

```json
"ghcr.io/ghostmind-dev/features/init:1": {
  "enableFeature": true,
  "installComponent": true
}
```

[📚 Full Documentation](./features/src/init/README.md)

### Kustomize (`kustomize`)

**Registry:** `ghcr.io/ghostmind-dev/features/kustomize`

Installs Kustomize for Kubernetes configuration management and customization with:

- Multi-architecture support (amd64, arm64)
- Official installation from GitHub releases
- Automatic PATH configuration
- Clean installation process

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/kustomize:1": {}
```

**With Custom Version:**

```json
"ghcr.io/ghostmind-dev/features/kustomize:1": {
  "version": "latest"
}
```

[📚 Full Documentation](./features/src/kustomize/README.md)

### NPM Global Packages (`npm`)

**Registry:** `ghcr.io/ghostmind-dev/features/npm`

Sets up NPM global configuration and installs commonly used global packages with:

- Custom global directory (`~/.npm-global`)
- Automatic PATH and environment configuration
- Default development packages (zx, npm-run-all, nodemon, @anthropic-ai/claude-code)
- Support for additional custom packages
- Shell profile integration (.bashrc, .zshrc, .profile)

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/npm:1": {}
```

**With Custom Packages:**

```json
"ghcr.io/ghostmind-dev/features/npm:1": {
  "installDefaultPackages": true,
  "packages": "typescript,prettier,eslint"
}
```

**Prerequisites:** Requires Node.js (use `ghcr.io/devcontainers/features/node:1`)

[📚 Full Documentation](./features/src/npm/README.md)

### Skaffold (`skaffold`)

**Registry:** `ghcr.io/ghostmind-dev/features/skaffold`

Installs Skaffold for Kubernetes development workflows with:

- Multi-architecture support (amd64, arm64)
- Configurable version installation
- Automatic PATH configuration
- Clean installation process

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/skaffold:1": {}
```

**With Custom Version:**

```json
"ghcr.io/ghostmind-dev/features/skaffold:1": {
  "version": "2.7.0"
}
```

[📚 Full Documentation](./features/src/skaffold/README.md)

### HashiCorp Vault (`vault`)

**Registry:** `ghcr.io/ghostmind-dev/features/vault`

Installs HashiCorp Vault CLI for secrets management and encryption as a service with:

- Official HashiCorp APT repository
- Multi-architecture support (amd64, arm64)
- Configurable version installation
- Automatic PATH configuration
- Useful aliases and environment setup

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/vault:1": {}
```

**With Specific Version:**

```json
"ghcr.io/ghostmind-dev/features/vault:1": {
  "version": "1.15.0"
}
```

[📚 Full Documentation](./features/src/vault/README.md)

### ZSH with Oh My Zsh (`zsh`)

**Registry:** `ghcr.io/ghostmind-dev/features/zsh`

Installs ZSH with Oh My Zsh and enhances your shell experience with:

- Popular themes (Spaceship, Powerlevel10k, Agnoster, Robbyrussell)
- Useful plugins (autosuggestions, syntax highlighting, completions)
- Automatic shell configuration
- Support for multiple architectures

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/zsh:1": {}
```

**With Custom Theme:**

```json
"ghcr.io/ghostmind-dev/features/zsh:1": {
  "theme": "powerlevel10k",
  "plugins": "git,docker,kubectl,aws"
}
```

[📚 Full Documentation](./features/src/zsh/README.md)

## 🏗️ Development

This repository uses a custom development utility system built with **`run custom`** for automating project tasks.

### Testing Features

```bash
# Test all features
run custom test

# Test specific feature
run custom test npm

# Test specific scenario
run custom test npm test_default

# List available features
run custom test --list-features

# List scenarios for a feature
run custom test npm --list-scenarios

# Run with verbose output
run custom test npm verbose

# Keep containers after test (for debugging)
run custom test npm no-cleanup
```

### Publishing Features

```bash
# Publish all features
run custom publish

# The script will:
# 1. Discover all features in features/src/
# 2. Publish each to ghcr.io/ghostmind-dev/features/
# 3. Create versioned tags (1, 1.0, 1.0.0, latest)
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
