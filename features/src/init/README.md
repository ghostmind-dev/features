# Init Feature

Initialize development environment with configurable options that are set as environment variables.

## Usage

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/init:1": {
      "enableFeature": true
    }
  }
}
```

## Options

| Option          | Type    | Default | Description             |
| --------------- | ------- | ------- | ----------------------- |
| `enableFeature` | boolean | `false` | Enable the init feature |

## Environment Variables

This feature sets the following environment variable:

- `INIT_FEATURE_ENABLED`: Set to `"true"` or `"false"` based on the `enableFeature` option

## Examples

### Enable the feature

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/init:1": {
      "enableFeature": true
    }
  }
}
```

This will set `INIT_FEATURE_ENABLED=true` in the container environment.

### Use default (disabled)

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/init:1": {}
  }
}
```

This will set `INIT_FEATURE_ENABLED=false` in the container environment.

## Accessing the Environment Variable

Once the container is built, you can access the environment variable:

### In Shell

```bash
echo $INIT_FEATURE_ENABLED
```

### In ZSH

```zsh
echo $INIT_FEATURE_ENABLED
```

### In Scripts

```bash
if [ "$INIT_FEATURE_ENABLED" = "true" ]; then
    echo "Init feature is enabled"
else
    echo "Init feature is disabled"
fi
```

## Installation

The environment variable is made available in:

- Bash sessions (`/etc/bash.bashrc`)
- ZSH sessions (`/etc/zsh/zshrc`)
- System-wide (`/etc/environment`)
- Profile sessions (`/etc/profile`)

This ensures the variable is accessible regardless of the shell or session type.
