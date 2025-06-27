# Google Cloud CLI (gcloud)

Installs the Google Cloud CLI (gcloud) and related components for use in development containers.

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/gcloud:1": {}
}
```

## Options

| Options Id           | Description                            | Type    | Default Value |
| -------------------- | -------------------------------------- | ------- | ------------- |
| version              | Version of Google Cloud CLI to install | string  | 405.0.0       |
| installBeta          | Install beta components                | boolean | false         |
| installGkeAuthPlugin | Install GKE gcloud auth plugin         | boolean | true          |

## Example with Options

```json
"features": {
    "ghcr.io/ghostmind-dev/features/gcloud:1": {
        "version": "latest",
        "installBeta": true,
        "installGkeAuthPlugin": true
    }
}
```

## Supported Platforms

- `linux/amd64`
- `linux/arm64`

## Available Commands

After installation, the following commands will be available:

- `gcloud` - Google Cloud CLI
- `gsutil` - Google Cloud Storage utility (if installed)
- `bq` - BigQuery command-line tool (if installed)

## Authentication

To authenticate with Google Cloud, you can use:

```bash
gcloud auth login
```

Or for service account authentication:

```bash
gcloud auth activate-service-account --key-file=/path/to/service-account.json
```

## Environment Variables

The feature sets the following environment variable:

- `GOOGLE_APPLICATION_CREDENTIALS=/tmp/gsa_key.json` - Default path for service account credentials

## Dependencies

This feature installs after:

- `ghcr.io/devcontainers/features/common-utils`

## Documentation

- [Google Cloud CLI Documentation](https://cloud.google.com/sdk/docs/install)
- [gcloud Command Reference](https://cloud.google.com/sdk/gcloud/reference)

---

_Note: This feature is maintained by [ghostmind-dev](https://github.com/ghostmind-dev)_
