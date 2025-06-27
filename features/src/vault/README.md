# HashiCorp Vault Feature

This feature installs the HashiCorp Vault CLI using a direct binary download from HashiCorp. It provides a reliable way to get Vault into your DevContainer for secrets management.

## Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/vault:1": {}
}
```

## Options

| Option    | Type   | Default  | Description                                              |
| --------- | ------ | -------- | -------------------------------------------------------- |
| `version` | string | `latest` | Version of Vault to install (e.g., "1.15.0" or "latest") |

## How it Works

The installation script (`install.sh`) will:

1.  Detect the container's architecture (amd64 or arm64).
2.  Download the specified version of the Vault CLI directly from HashiCorp's release server.
3.  Unzip the archive and place the `vault` executable in `/usr/local/bin`.
4.  Verify the installation by running `vault --version`.

This method avoids using `apt` repositories, which can sometimes cause permission issues in containerized environments.

## Examples

### Basic Installation

```json
"features": {
    "ghcr.io/ghostmind-dev/features/vault:1": {}
}
```

### Specific Version

```json
"features": {
    "ghcr.io/ghostmind-dev/features/vault:1": {
        "version": "1.15.0"
    }
}
```

## What's Installed

- **HashiCorp Vault CLI**: Complete command-line interface for Vault operations
- **GPG Key & Repository**: Official HashiCorp APT repository for secure installation
- **Environment Setup**: Basic aliases and PATH configuration

## Quick Start

After installation, you can use Vault commands:

```bash
# Check Vault version
vault version

# Get help
vault --help

# Check server status (if server is running)
vault status

# List available auth methods
vault auth list

# List secrets engines
vault secrets list
```

## Common Use Cases

### Development with Vault

```bash
# Start Vault in dev mode (for development only)
vault server -dev

# In another terminal, set environment
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='your-dev-token'

# Test connection
vault status
```

### Working with Secrets

```bash
# Enable kv secrets engine
vault secrets enable -path=secret kv-v2

# Store a secret
vault kv put secret/myapp username=admin password=secret

# Retrieve a secret
vault kv get secret/myapp
```

### Authentication

```bash
# Enable userpass auth method
vault auth enable userpass

# Create a user
vault write auth/userpass/users/myuser password=mypassword

# Login as user
vault auth -method=userpass username=myuser
```

## Architecture Support

This feature supports:

- ✅ **AMD64** (x86_64)
- ✅ **ARM64** (aarch64)

## Environment Variables

The feature sets up the following:

- Adds Vault to system PATH
- Creates useful aliases like `vault-status`

## Security Notes

- 🔐 **Production Use**: Never use dev mode in production
- 🔑 **Token Management**: Secure your Vault tokens appropriately
- 🌐 **Network**: Configure proper network access controls
- 📜 **Policies**: Implement least-privilege access policies

## Documentation

- [Official Vault Documentation](https://developer.hashicorp.com/vault/docs)
- [Vault CLI Reference](https://developer.hashicorp.com/vault/docs/commands)
- [Vault Tutorials](https://developer.hashicorp.com/vault/tutorials)
- [Best Practices](https://developer.hashicorp.com/vault/docs/best-practices)

## Related Features

Consider combining with:

- `ghcr.io/ghostmind-dev/features/aws` - For AWS integration
- `ghcr.io/ghostmind-dev/features/gcloud` - For GCP integration
