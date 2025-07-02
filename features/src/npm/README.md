# NPM Global Packages Feature

This feature installs specified global NPM packages using NPM's default global installation location.

## ✨ What it does

- Installs user-specified global NPM packages
- Uses NPM's standard global installation behavior
- Supports comma-separated package list for easy configuration
- Verifies Node.js and NPM availability before installation

## 📖 Usage

### Install specific packages

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "packages": "zx,nodemon,typescript"
    }
  }
}
```

### Install development tools

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "packages": "typescript,prettier,eslint,@types/node"
    }
  }
}
```

### Install framework CLIs

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "packages": "create-react-app,@angular/cli,@vue/cli"
    }
  }
}
```

### Real-world development setup

```json
{
  "name": "Node.js Development Environment",
  "image": "mcr.microsoft.com/devcontainers/base:debian-11",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {},
    "ghcr.io/devcontainers/features/node:1": {
      "version": "lts"
    },
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "packages": "typescript,@types/node,ts-node,prettier,eslint,nodemon"
    }
  }
}
```

## ⚙️ Options

| Option     | Type   | Default | Description                                        |
| ---------- | ------ | ------- | -------------------------------------------------- |
| `packages` | string | `""`    | Comma-separated list of global packages to install |

## ⚠️ Prerequisites

- **Node.js** must be installed first (use `ghcr.io/devcontainers/features/node:1`)
- **NPM** must be available (typically included with Node.js)

The feature declares this dependency in its configuration and will automatically ensure Node.js is installed first.

## 🧪 Testing

This feature includes comprehensive tests that verify:

- NPM availability and functionality
- Package installation functionality
- Integration with Node.js feature

Run tests with:

```bash
# Test all scenarios
run custom test npm

# Test with verbose output
run custom test npm verbose

# Test specific scenario
run custom test npm test_packages
```

## 🔧 Troubleshooting

### Global packages not found after installation

1. **Check if packages are installed**:

   ```bash
   npm list --global --depth=0
   ```

2. **Verify package binaries are available**:
   ```bash
   which <package-name>
   ```

### Node.js not found

If you see "Node.js is not installed" error:

- Ensure the `node` feature is installed **before** the `npm` feature
- The feature automatically handles this dependency, but manual configurations should respect the order

### Package installation fails

- Verify the package names are correct
- Check for typos in the comma-separated package list
- Ensure network connectivity for downloading packages

## 🔗 Related Features

- [`ghcr.io/devcontainers/features/node:1`](https://github.com/devcontainers/features/tree/main/src/node) - Required prerequisite
- [`ghcr.io/devcontainers/features/common-utils:2`](https://github.com/devcontainers/features/tree/main/src/common-utils) - Recommended for basic development tools

## 📝 Version Information

- **Current version**: 1.0.0
- **Registry**: `ghcr.io/ghostmind-dev/features/npm`

---

_For more information about DevContainer features, see the [official documentation](https://containers.dev/implementors/features/)._
