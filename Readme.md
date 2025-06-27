# Ghostmind Dev Container Features

A collection of development container features for enhanced development environments.

## 🚀 Available Features

| Feature                    | Description                                    | Registry                                |
| -------------------------- | ---------------------------------------------- | --------------------------------------- |
| [aws](./app/src/aws)       | AWS v2 for managing AWS services               | `ghcr.io/ghostmind-dev/features/aws`    |
| [gcloud](./app/src/gcloud) | Google Cloud CLI with authentication and tools | `ghcr.io/ghostmind-dev/features/gcloud` |
| [zsh](./app/src/zsh)       | ZSH with Oh My Zsh, themes, and useful plugins | `ghcr.io/ghostmind-dev/features/zsh`    |

## 📖 Usage

Add features to your `.devcontainer/devcontainer.json`:

```json
{
  "name": "My Dev Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/ghostmind-dev/features/aws:1": {},
    "ghcr.io/ghostmind-dev/features/gcloud:1": {
      "version": "405.0.0",
      "installBeta": false,
      "installGkeAuthPlugin": true
    },
    "ghcr.io/ghostmind-dev/features/zsh:1": {
      "theme": "spaceship"
    }
  }
}
```

## 🔧 Features

### AWS (`aws`)

**Registry:** `ghcr.io/ghostmind-dev/features/aws`

Installs the AWS CLI v2 for managing AWS services with:

- Multi-architecture support (amd64, arm64)
- Latest AWS v2 installation
- Automatic PATH configuration
- Clean installation process

**Quick Start:**

```json
"ghcr.io/ghostmind-dev/features/awscli:1": {}
```

[📚 Full Documentation](./app/src/awscli/README.md)

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

[📚 Full Documentation](./app/src/gcloud/README.md)

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

[📚 Full Documentation](./app/src/zsh/README.md)

## 🏗️ Development

This repository uses a custom publishing system built with TypeScript and Deno.

### Publishing Features

```bash
# Publish all features
run custom publish

# The script will:
# 1. Discover all features in app/src/
# 2. Publish each to ghcr.io/ghostmind-dev/features/
# 3. Create versioned tags (1, 1.0, 1.0.0, latest)
```

### Testing Features

```bash
# Run tests for all features
run custom test
```

## 📋 Feature Structure

Each feature follows this structure:

```
app/src/feature-name/
├── devcontainer-feature.json  # Feature metadata and options
├── install.sh                 # Installation script
└── README.md                  # Feature documentation
```

## 🤝 Contributing

1. Fork this repository
2. Create a new feature in `app/src/your-feature/`
3. Include:
   - `devcontainer-feature.json` with metadata
   - `install.sh` with installation logic
   - `README.md` with documentation
4. Test your feature
5. Submit a pull request

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

## 🔗 Links

- [Dev Container Specification](https://containers.dev/)
- [Feature Development Guide](https://containers.dev/implementors/features/)
- [GitHub Container Registry](https://ghcr.io)

---

**Maintained by:** [Ghostmind Dev](https://github.com/ghostmind-dev)
