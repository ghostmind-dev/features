
# NPM Global Packages (npm)

Sets up NPM global configuration and installs commonly used global packages

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/npm:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installDefaultPackages | Install default global packages (zx, npm-run-all, nodemon, @anthropic-ai/claude-code) | boolean | true |
| packages | Comma-separated list of additional global packages to install | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ghostmind-dev/features/blob/main/features/src/npm/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
