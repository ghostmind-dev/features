# Act

**Registry:** `ghcr.io/ghostmind-dev/features/act`

Installs [act](https://github.com/nektos/act) - a tool to run GitHub Actions locally for testing and development.

## Features

- Multi-architecture support (amd64, arm64)
- Configurable version installation
- Automatic PATH configuration
- Clean installation process

## Usage

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/act:1": {}
  }
}
```

## Options

| Option    | Type   | Default | Description               |
| --------- | ------ | ------- | ------------------------- |
| `version` | string | 0.2.61  | Version of act to install |

## Examples

### Default Installation

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/act:1": {}
  }
}
```

### Custom Version

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/act:1": {
      "version": "0.2.60"
    }
  }
}
```

## What is Act?

Act is a tool that allows you to run your GitHub Actions locally. This is useful for:

- Testing GitHub Actions workflows before pushing to GitHub
- Debugging workflow issues locally
- Developing and iterating on workflows faster
- Running workflows in environments without internet access

## Usage After Installation

Once installed, you can use `act` in your repository with GitHub Actions:

```bash
# Run all workflows
act

# Run a specific job
act -j build

# List available workflows
act -l

# Run with a specific event
act push
```

## Prerequisites

- Docker must be installed and running (act uses Docker to run Actions)
- A repository with `.github/workflows/` directory

## Resources

- [Official Documentation](https://github.com/nektos/act)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
