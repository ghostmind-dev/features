# ZSH with Oh My Zsh Feature

This devcontainer feature installs ZSH with Oh My Zsh, popular themes, and useful plugins to enhance your shell experience.

## Usage

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {}
  }
}
```

## Options

| Option                      | Type    | Default                                             | Description                                                                         |
| --------------------------- | ------- | --------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `theme`                     | string  | `spaceship`                                         | Oh My Zsh theme to install (`spaceship`, `powerlevel10k`, `agnoster`, `codespaces`) |
| `plugins`                   | string  | `git,ssh-agent,zsh-autosuggestions,zsh-completions` | Comma-separated list of plugins to install                                          |
| `installAutosuggestions`    | boolean | `true`                                              | Install zsh-autosuggestions plugin                                                  |
| `installSyntaxHighlighting` | boolean | `true`                                              | Install zsh-syntax-highlighting plugin                                              |
| `installCompletions`        | boolean | `true`                                              | Install zsh-completions plugin                                                      |
| `setAsDefaultShell`         | boolean | `true`                                              | Set ZSH as the default shell for the user                                           |

## Examples

### Basic installation with Spaceship theme

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {
      "theme": "spaceship"
    }
  }
}
```

### Powerlevel10k theme with custom plugins

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {
      "theme": "powerlevel10k",
      "plugins": "git,docker,kubectl,aws"
    }
  }
}
```

### Minimal installation

```json
{
  "features": {
    "ghcr.io/your-org/features/zsh:1": {
      "theme": "codespaces",
      "installAutosuggestions": false,
      "installSyntaxHighlighting": false,
      "plugins": "git"
    }
  }
}
```

## Included Themes

- **spaceship** (default): A minimalist, powerful and extremely customizable Zsh prompt
- **powerlevel10k**: A fast reimplementation of Powerlevel9k with additional features
- **agnoster**: A ZSH theme optimized for people who use Git and Unicode-compatible fonts
- **codespaces**: The default Oh My Zsh theme

## Included Plugins

The feature automatically installs these popular plugins:

- **git**: Git aliases and functions
- **ssh-agent**: SSH agent management
- **zsh-autosuggestions**: Fish-like autosuggestions for zsh
- **zsh-completions**: Additional completion definitions for zsh
- **zsh-syntax-highlighting**: Syntax highlighting for the shell zsh

## Notes

- The feature will automatically detect the appropriate user (`vscode`, `_REMOTE_USER`, or `USERNAME`)
- ZSH will be set as the default shell unless `setAsDefaultShell` is set to `false`
- All plugins and themes are installed in the user's home directory under `~/.oh-my-zsh/custom/`
- The Spaceship theme includes custom configuration for a clean, single-line prompt

## OS Support

This feature supports Debian/Ubuntu-based containers.
