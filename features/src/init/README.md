
# Init (init)

Initialize development environment with configurable options

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/init:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| resetLive | Reset live environment settings (default: false) | boolean | false |
| baseZshrc | Configure base ZSH configuration (default: true) | boolean | true |
| denoConfig | Setup Deno configuration (default: true) | boolean | true |
| denoJupyter | Enable Deno Jupyter integration (default: false) | boolean | false |
| coreSecrets | Setup core secrets management (default: true) | boolean | true |
| loginNpm | Configure NPM login (default: false) | boolean | false |
| loginGcp | Configure Google Cloud Platform login (default: true) | boolean | true |
| loginGhcr | Configure GitHub Container Registry login (default: true) | boolean | true |
| loginNvcr | Configure NVIDIA Container Registry login (default: true) | boolean | true |
| loginVault | Configure HashiCorp Vault login (default: true) | boolean | true |
| loginCloudflare | Configure Cloudflare login (default: true) | boolean | true |
| pythonVersion | Python version to configure (default: 3.9.7) | string | 3.9.7 |
| tmuxConfig | Setup TMUX configuration (default: false) | boolean | false |
| quoteAi | Enable AI quote feature (default: true) | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ghostmind-dev/features/blob/main/features/src/init/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
