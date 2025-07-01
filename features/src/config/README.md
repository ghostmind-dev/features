# Config Feature

Configure VS Code settings for enhanced development environment with predefined configurations through DevContainer customizations.

## Usage

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/config:1": {
      "enableFeature": true
    }
  }
}
```

## Options

| Option          | Type    | Default | Description                                       |
| --------------- | ------- | ------- | ------------------------------------------------- |
| `enableFeature` | boolean | `true`  | Enable the config feature to set VS Code settings |

## What It Does

This feature automatically configures VS Code settings through DevContainer customizations for an optimal development experience:

### Editor Settings

- Disables auto-save for better control (`files.autoSave: "off"`)
- Enables format on save (`editor.formatOnSave: true`)
- Sets ZSH as default terminal profile (`terminal.integrated.defaultProfile.linux: "zsh"`)
- Configures Prettier with single quotes (`prettier.singleQuote: true`)

### File Management

- Hides common unnecessary files (`.git`, `node_modules`, `.terraform`, etc.)
- Sets up file type associations for JSON/JSONC
- Configures comprehensive file exclusions for cleaner workspace

### Development Tools

- Enables Deno with linting and caching
- Configures JSON schema validation for `meta.json` files
- Sets up shell formatting for dotenv and gitignore files
- Disables formatting for Dockerfile files

### UI Enhancements

- Material Icon Theme folder and file associations
- Custom color schemes for environment files (`.env.base`, `.env.dev`, etc.)
- Git decoration settings with custom colors
- Explorer decoration options

## Examples

### Enable the feature (default)

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/config:1": {}
  }
}
```

This will configure VS Code settings through DevContainer customizations.

### Disable the feature

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/config:1": {
      "enableFeature": false
    }
  }
}
```

This will skip the VS Code settings configuration.

## How It Works

The feature uses DevContainer's `customizations.vscode.settings` to apply VS Code settings automatically when the container is created. This approach:

- Applies settings at the workspace level
- Integrates seamlessly with VS Code's DevContainer support
- Requires no manual file management
- Works consistently across different development environments

## Settings Applied

The feature configures over 30 VS Code settings including:

- File associations and exclusions
- Deno language server configuration
- JSON schema validation
- Material Icon Theme customizations
- Terminal and editor preferences
- Git and explorer decorations

## Compatibility

This feature works with:

- VS Code and VS Code DevContainers
- Material Icon Theme extension
- Deno extension
- Prettier extension
- Docker extension
- Shell formatting extensions

## Installation

Settings are applied automatically when the DevContainer is built and will take effect immediately when VS Code connects to the container.
