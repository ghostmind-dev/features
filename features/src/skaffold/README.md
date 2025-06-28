# Skaffold Feature

This feature installs [Skaffold](https://skaffold.dev/) - a command line tool that facilitates continuous development for Kubernetes applications.

## Usage

```json
"ghcr.io/ghostmind-dev/features/skaffold:1": {}
```

## Options

| Option  | Type   | Default | Description                    |
| ------- | ------ | ------- | ------------------------------ |
| version | string | 2.8.0   | Version of Skaffold to install |

## Example with Custom Version

```json
"ghcr.io/ghostmind-dev/features/skaffold:1": {
  "version": "2.7.0"
}
```

## What's Installed

- **Skaffold CLI**: The main Skaffold command-line tool
- **Multi-architecture support**: Works on both amd64 and arm64 architectures

## Verification

After installation, you can verify Skaffold is working:

```bash
skaffold version
```

## About Skaffold

Skaffold handles the workflow for building, pushing and deploying your application, allowing you to focus on what matters most: writing code.

Key features:

- Fast local Kubernetes development
- Easy CI/CD integration
- File watching and hot reloading
- Support for multiple deployment strategies
- Works with any build tool or deploy tool

## Documentation

For more information about using Skaffold, visit the [official documentation](https://skaffold.dev/docs/).
