# uv Python Package Manager (uv)

Installs [uv](https://docs.astral.sh/uv/), an extremely fast Python package and project manager written in Rust.

## Description

uv is a drop-in replacement for pip, pip-tools, pipx, poetry, pyenv, twine, virtualenv, and more. It's designed to be a unified Python packaging tool that's significantly faster than existing solutions.

## Features

- **Extremely Fast**: 10-100x faster than pip and pip-tools
- **Drop-in Replacement**: Compatible with pip and requirements.txt
- **Python Management**: Install and manage Python versions
- **Virtual Environment Management**: Automatic virtual environment handling
- **Project Management**: Create and manage Python projects
- **Tool Installation**: Install Python tools globally
- **Dependency Resolution**: Advanced dependency resolver
- **Cross-platform**: Works on Linux, macOS, and Windows

## Example Usage

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/uv:1": {}
  }
}
```

## Options

| Options Id     | Description                                                | Type    | Default Value |
| -------------- | ---------------------------------------------------------- | ------- | ------------- |
| version        | Select or enter a uv version to install                    | string  | latest        |
| installPython  | Install Python using uv if not already available           | boolean | false         |
| globalPackages | Comma-separated list of global packages to install with uv | string  | ""            |

## Examples

### Basic Installation

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/uv:1": {}
  }
}
```

### Install Specific Version

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/uv:1": {
      "version": "0.1.44"
    }
  }
}
```

### Install with Python and Global Tools

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/uv:1": {
      "installPython": true,
      "globalPackages": "ruff,black,mypy"
    }
  }
}
```

## Common Commands

After installation, you can use uv with these common commands:

### Project Management

```bash
# Create a new project
uv init my-project

# Add dependencies
uv add requests
uv add pytest --dev

# Remove dependencies
uv remove requests

# Install dependencies
uv sync
```

### Python Management

```bash
# Install Python versions
uv python install 3.11
uv python install 3.12

# List installed Python versions
uv python list

# Use specific Python version
uv python pin 3.11
```

### Tool Management

```bash
# Install tools globally
uv tool install ruff
uv tool install black
uv tool install mypy

# List installed tools
uv tool list

# Upgrade tools
uv tool upgrade ruff
```

### Running Scripts

```bash
# Run Python scripts
uv run script.py

# Run with specific Python version
uv run --python 3.11 script.py

# Run in virtual environment
uv run --python 3.11 --with requests script.py
```

## Performance Benefits

uv offers significant performance improvements over traditional Python packaging tools:

- **Package Installation**: 10-100x faster than pip
- **Dependency Resolution**: Faster than pip-tools and Poetry
- **Virtual Environment Creation**: Near-instantaneous
- **Project Initialization**: Much faster than traditional tools

## Migration from pip/Poetry

uv is designed to be a drop-in replacement:

### From pip

```bash
# Instead of:
pip install requests

# Use:
uv add requests
```

### From pip-tools

```bash
# Instead of:
pip-compile requirements.in

# Use:
uv lock
```

### From Poetry

```bash
# Instead of:
poetry add requests

# Use:
uv add requests
```

## Dependencies

This feature installs the following system dependencies:

- curl
- ca-certificates

## Installation Location

uv is installed to `~/.local/bin/uv` and added to the PATH in:

- `~/.bashrc`
- `~/.zshrc`
- `~/.profile`

## Version Support

- Supports all stable versions of uv
- Defaults to the latest stable version
- Can install specific versions using the `version` option

## Related Features

This feature works well with:

- `ghcr.io/devcontainers/features/python:1` - For Python runtime
- `ghcr.io/devcontainers/features/common-utils:2` - For basic utilities

## License

This feature is licensed under the MIT License. uv itself is licensed under the Apache License 2.0 or MIT License.

## Support

For issues with this feature, please report them in the [features repository](https://github.com/ghostmind-dev/features).

For issues with uv itself, please report them in the [uv repository](https://github.com/astral-sh/uv).
