# ZSH Plugin Manager Feature

This devcontainer feature manages ZSH themes and plugins, assuming ZSH and Oh My Zsh are already installed. It installs non-built-in plugins and themes, and sets environment variables for use by other initialization systems.

## Prerequisites

- ZSH must be already installed
- Oh My Zsh must be already installed
- The Oh My Zsh custom directory (`~/.oh-my-zsh/custom`) must exist

## Usage

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {}
  }
}
```

## Options

| Option           | Type    | Default      | Description                                                                         |
| ---------------- | ------- | ------------ | ----------------------------------------------------------------------------------- |
| `installFeature` | boolean | `true`       | Install themes and plugins (`true`) or only set environment variables (`false`)     |
| `theme`          | string  | `codespaces` | Theme to use (`spaceship`, `agnoster`, `codespaces`)                                |
| `initZshTheme`   | string  | `""`         | Override theme for environment variable (takes precedence over `theme`)             |
| `initZshPlugins` | string  | `""`         | Override plugins for environment variable (takes precedence over hardcoded plugins) |

## Behavior

### When `installFeature=true` (default)

- Installs non-built-in themes (e.g., Spaceship)
- Installs non-built-in plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`
- Sets environment variables `INIT_ZSH_THEME` and `INIT_ZSH_PLUGINS`

### When `installFeature=false`

- Only sets environment variables `INIT_ZSH_THEME` and `INIT_ZSH_PLUGINS`
- Does not install any themes or plugins

## Environment Variables

The feature always sets these environment variables:

- `INIT_ZSH_THEME`: Theme name (from `initZshTheme` or `theme` option)
- `INIT_ZSH_PLUGINS`: Plugin list (from `initZshPlugins` or hardcoded list: `git zsh-autosuggestions zsh-syntax-highlighting zsh-completions`)

These variables can be used by other initialization systems to configure ZSH without direct `.zshrc` modification.

## Examples

### Full installation with Spaceship theme

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {
      "installFeature": true,
      "theme": "spaceship"
    }
  }
}
```

### Environment variables only

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {
      "installFeature": false,
      "theme": "agnoster"
    }
  }
}
```

### Custom environment variable values

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {
      "installFeature": true,
      "initZshTheme": "spaceship",
      "initZshPlugins": "git docker kubectl aws zsh-autosuggestions"
    }
  }
}
```

## Supported Themes

- **spaceship**: Minimalist, powerful and extremely customizable Zsh prompt (requires installation)
- **agnoster**: ZSH theme optimized for Git and Unicode-compatible fonts (built-in)
- **codespaces**: Default Oh My Zsh theme (built-in)

## Installed Plugins

When `installFeature=true`, these plugins are installed:

- **zsh-autosuggestions**: Fish-like autosuggestions for zsh
- **zsh-syntax-highlighting**: Syntax highlighting for the shell zsh
- **zsh-completions**: Additional completion definitions for zsh

The `git` plugin is always included but doesn't require installation (built-in).

## Notes

- This feature assumes ZSH and Oh My Zsh are already installed
- The feature will fail if Oh My Zsh custom directory doesn't exist
- Environment variables are set in `/etc/environment` for system-wide availability
- All installed files are owned by the appropriate user (`vscode`, `_REMOTE_USER`, or `USERNAME`)
- The feature does not modify `.zshrc` files directly

## OS Support

This feature supports Debian/Ubuntu-based containers with existing ZSH and Oh My Zsh installations.
