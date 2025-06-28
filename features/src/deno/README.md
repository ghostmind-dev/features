# Deno Feature

This feature installs [Deno](https://deno.land/), a modern runtime for JavaScript and TypeScript.

## Description

Deno is a simple, modern and secure runtime for JavaScript and TypeScript that uses V8 and is built in Rust. This feature installs Deno and sets up the necessary environment variables.

## Usage

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/deno:1": {}
  }
}
```

## Options

| Option    | Type   | Default  | Description                |
| --------- | ------ | -------- | -------------------------- |
| `version` | string | `v2.0.3` | Version of Deno to install |

## Example with custom version

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/deno:1": {
      "version": "v1.45.5"
    }
  }
}
```

## Environment Variables

This feature sets the following environment variables:

- `DENO_INSTALL`: Path to Deno installation directory (`/deno`)
- `DENO_DIR`: Path to Deno cache directory (`/deno/.cache/deno`)
- `PATH`: Updated to include `/deno/bin`

## What's Installed

- Deno runtime and CLI
- Environment variables for Deno configuration
- PATH updates to make Deno globally accessible

## License

This feature is licensed under the MIT License. See the [Deno license](https://github.com/denoland/deno/blob/main/LICENSE.md) for the Deno runtime.
