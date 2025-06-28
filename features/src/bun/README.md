# Bun JavaScript Runtime

Installs [Bun](https://bun.sh), the fast all-in-one JavaScript runtime and toolkit that includes a bundler, test runner, and Node.js-compatible package manager.

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/bun:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Bun version to install | string | latest |
| installGlobalPackages | Install commonly used global packages | boolean | false |
| packages | Comma-separated list of additional global packages to install | string | "" |

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Description

This feature installs Bun, a fast JavaScript runtime built from scratch to serve the modern JavaScript ecosystem. Bun includes:

- **JavaScript Runtime**: Drop-in replacement for Node.js
- **Package Manager**: Fast npm-compatible package manager
- **Bundler**: Built-in bundler and transpiler
- **Test Runner**: Built-in test runner
- **Development Server**: Built-in development server

## Installation Details

The feature performs the following actions:

1. **Downloads and installs Bun** using the official installation script
2. **Configures environment variables** in shell profiles (.bashrc, .zshrc, .profile)
3. **Sets up PATH** to include Bun's binary directory
4. **Optionally installs global packages** if requested
5. **Verifies installation** and displays version information

## Environment Variables

After installation, the following environment variables are available:

- `BUN_INSTALL`: Points to the Bun installation directory (`$HOME/.bun`)
- `PATH`: Updated to include `$BUN_INSTALL/bin`

## Default Global Packages

When `installGlobalPackages` is set to `true`, the following packages are installed globally:

- `typescript` - TypeScript compiler
- `prettier` - Code formatter
- `@types/node` - Node.js type definitions

## Usage Examples

### Basic Installation

```json
"features": {
    "ghcr.io/ghostmind-dev/features/bun:1": {}
}
```

### Install Specific Version

```json
"features": {
    "ghcr.io/ghostmind-dev/features/bun:1": {
        "version": "1.0.20"
    }
}
```

### Install with Default Packages

```json
"features": {
    "ghcr.io/ghostmind-dev/features/bun:1": {
        "installGlobalPackages": true
    }
}
```

### Install with Custom Packages

```json
"features": {
    "ghcr.io/ghostmind-dev/features/bun:1": {
        "installGlobalPackages": true,
        "packages": "eslint,vite,react"
    }
}
```

## Common Commands

After installation, you can use these Bun commands:

```bash
# Show version
bun --version

# Create a new project
bun init

# Install dependencies
bun install

# Add a package
bun add <package-name>

# Run a script
bun run <script-name>

# Run a file directly
bun run index.ts

# Start development server
bun dev

# Build for production
bun build

# Run tests
bun test

# Install a package globally
bun add --global <package-name>
```

## Performance Benefits

Bun offers significant performance improvements over Node.js:

- **Fast startup**: Starts 4x faster than Node.js
- **Fast package manager**: Installs packages up to 30x faster than npm
- **Built-in bundling**: No need for separate bundler configuration
- **TypeScript support**: Built-in TypeScript transpilation
- **Hot reloading**: Fast development server with hot reloading

## Dependencies

This feature installs the following system dependencies:

- `curl` - For downloading the Bun installer
- `unzip` - For extracting Bun archives
- `ca-certificates` - For secure HTTPS connections

## Notes

- Bun is installed in the user's home directory (`$HOME/.bun`)
- The installation is user-specific and doesn't require root privileges for usage
- Bun provides Node.js compatibility but may have some differences in edge cases
- For production use, always pin to a specific version rather than using "latest"
- Remember to restart your shell or source your profile after installation

## Troubleshooting

### Command not found

If you get "bun: command not found", try:

```bash
# Reload your shell profile
source ~/.bashrc  # or ~/.zshrc

# Or restart your terminal
```

### Permission issues

If you encounter permission issues:

```bash
# Check ownership of Bun directory
ls -la ~/.bun

# Fix ownership if needed (replace 'username' with your username)
sudo chown -R username:username ~/.bun
```

## Links

- [Bun Official Website](https://bun.sh)
- [Bun Documentation](https://bun.sh/docs)
- [Bun GitHub Repository](https://github.com/oven-sh/bun)
- [Bun Package Manager](https://bun.sh/docs/cli/install) 