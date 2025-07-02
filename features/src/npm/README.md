# NPM Global Packages Feature

This feature sets up NPM global configuration with a custom prefix and installs commonly used global packages for development workflows.

## ✨ What it does

- Creates a `.npm-global` directory in the user's home directory
- Configures NPM to use this directory as the global prefix (avoiding permission issues)
- Updates shell profiles (.bashrc, .zshrc, .profile) with proper environment variables
- Optionally installs a curated set of default global packages
- Allows installation of additional custom packages
- Ensures proper PATH configuration for global packages

## 📦 Default Global Packages

When `installDefaultPackages` is enabled (default: `true`), the following packages are installed:

- **`zx@8.1.1`** - A tool for writing better scripts with JavaScript/TypeScript
- **`npm-run-all@4.1.5`** - CLI tool to run multiple npm-scripts in parallel or sequential
- **`nodemon@3.1.1`** - Simple monitor script for use during development of Node.js apps
- **`@anthropic-ai/claude-code`** - Claude AI code assistant for development

## 📖 Usage

### Basic usage with defaults

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/npm:1": {}
  }
}
```

### Skip default packages and install only custom ones

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "installDefaultPackages": false,
      "packages": "typescript prettier eslint"
    }
  }
}
```

### Install both default and additional packages

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/ghostmind-dev/features/npm:1": {
      "installDefaultPackages": true,
      "packages": "create-react-app @angular/cli vue-cli"
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
      "installDefaultPackages": true,
      "packages": "typescript @types/node ts-node prettier eslint"
    }
  }
}
```

## ⚙️ Options

| Option                   | Type    | Default | Description                                                                           |
| ------------------------ | ------- | ------- | ------------------------------------------------------------------------------------- |
| `installDefaultPackages` | boolean | `true`  | Install default global packages (zx, npm-run-all, nodemon, @anthropic-ai/claude-code) |
| `packages`               | string  | `""`    | Space-separated list of additional global packages to install                         |

## 🔧 Environment Variables

The feature adds the following environment variables to your shell profiles:

```bash
export NPM_CONFIG_PREFIX=${HOME}/.npm-global
export PATH=${NPM_CONFIG_PREFIX}/bin:${PATH}
```

## ⚠️ Prerequisites

- **Node.js** must be installed first (use `ghcr.io/devcontainers/features/node:1`)
- **NPM** must be available (typically included with Node.js)

The feature declares this dependency in its configuration and will automatically ensure Node.js is installed first.

## 📁 File Structure

After installation, your home directory will contain:

```
~/.npm-global/          # NPM global directory
├── bin/                # Global package binaries
├── lib/                # Installed packages
└── ...

~/.bashrc               # Updated with NPM environment variables
~/.zshrc                # Updated with NPM environment variables
~/.profile              # Updated with NPM environment variables
~/.npmrc                # NPM configuration file
```

## 🧪 Testing

This feature includes comprehensive tests that verify:

- NPM global directory creation
- Proper NPM prefix configuration
- Environment variable setup in shell profiles
- PATH configuration
- Package installation functionality
- Integration with Node.js feature

Run tests with:

```bash
# Test all scenarios
run custom test npm

# Test with verbose output
run custom test npm verbose

# Test specific scenario
run custom test npm test_default
```

## 🔧 Troubleshooting

### Global packages not found after installation

1. **Restart your shell** or source your profile:

   ```bash
   source ~/.bashrc
   # or
   source ~/.zshrc
   ```

2. **Check PATH configuration**:

   ```bash
   echo $PATH
   # Should include: /home/username/.npm-global/bin
   ```

3. **Verify NPM configuration**:

   ```bash
   npm config get prefix
   # Should return: /home/username/.npm-global
   ```

4. **List installed global packages**:
   ```bash
   npm list --global --depth=0
   ```

### Permission errors

This feature specifically avoids permission issues by:

- Using a custom global directory (`~/.npm-global`) instead of system directories
- Installing packages as the container user, not root
- Properly configuring ownership of all created files

### Node.js not found

If you see "Node.js is not installed" error:

- Ensure the `node` feature is installed **before** the `npm` feature
- The feature automatically handles this dependency, but manual configurations should respect the order

## 🔗 Related Features

- [`ghcr.io/devcontainers/features/node:1`](https://github.com/devcontainers/features/tree/main/src/node) - Required prerequisite
- [`ghcr.io/devcontainers/features/common-utils:2`](https://github.com/devcontainers/features/tree/main/src/common-utils) - Recommended for basic development tools

## 📝 Version Information

- **Current version**: 1.0.0
- **Registry**: `ghcr.io/ghostmind-dev/features/npm`
- **Source**: [GitHub Repository](https://github.com/ghostmind-dev/features)

---

_For more information about DevContainer features, see the [official documentation](https://containers.dev/implementors/features/)._
