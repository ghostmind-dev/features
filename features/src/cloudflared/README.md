# Cloudflared

Installs [Cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/) (cloudflare tunnel daemon) for creating secure tunnels to your localhost.

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/cloudflared:1": {}
}
```

## Options

| Options Id | Description                       | Type   | Default Value |
| ---------- | --------------------------------- | ------ | ------------- |
| version    | Version of Cloudflared to install | string | latest        |

## Usage

After installation, you can use cloudflared to create secure tunnels:

```bash
# Login to Cloudflare (opens browser for authentication)
cloudflared tunnel login

# Create a new tunnel
cloudflared tunnel create my-tunnel

# Route traffic to your tunnel
cloudflared tunnel route dns my-tunnel my-app.example.com

# Run the tunnel
cloudflared tunnel run my-tunnel
```

For more advanced usage and configuration options, see the [official documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/).

## Supported platforms

- linux/amd64
- linux/arm64

_Note: Version `latest` installs from the official Cloudflare repository._
