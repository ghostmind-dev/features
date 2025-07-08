# Container Mounts (mounts)

Enables various mount configurations for development containers including terminal history persistence, project volume access, and editor settings synchronization.

## Example Usage

### Basic Usage (All Mounts Enabled)

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/mounts:1": {}
  },
  "mounts": [
    "source=terminal-history,target=/commandhistory,type=volume",
    "source=/Volumes/Projects,target=/Volumes/Projects,type=bind",
    "source=${env:HOME}${env:USERPROFILE}/.cursor,target=/home/vscode/.cursor,type=bind"
  ]
}
```

### Selective Mount Configuration

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/mounts:1": {
      "terminalHistory": true,
      "projectsMount": false,
      "cursorSettings": true
    }
  },
  "mounts": [
    "source=terminal-history,target=/commandhistory,type=volume",
    "source=${env:HOME}${env:USERPROFILE}/.cursor,target=/home/vscode/.cursor,type=bind"
  ]
}
```

### Custom Paths

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/mounts:1": {
      "projectsSource": "/Users/username/Development",
      "projectsTarget": "/workspace/dev",
      "cursorTarget": "/home/vscode/.vscode"
    }
  },
  "mounts": [
    "source=terminal-history,target=/commandhistory,type=volume",
    "source=/Users/username/Development,target=/workspace/dev,type=bind",
    "source=${env:HOME}${env:USERPROFILE}/.cursor,target=/home/vscode/.vscode,type=bind"
  ]
}
```

## Options

| Option                  | Description                                    | Type    | Default                                   |
| ----------------------- | ---------------------------------------------- | ------- | ----------------------------------------- |
| `terminalHistory`       | Enable terminal history volume mount           | boolean | `true`                                    |
| `terminalHistoryVolume` | Name of the volume for terminal history        | string  | `"terminal-history"`                      |
| `projectsMount`         | Enable bind mount for Projects directory       | boolean | `true`                                    |
| `projectsSource`        | Source path for Projects directory (host)      | string  | `"/Volumes/Projects"`                     |
| `projectsTarget`        | Target path for Projects directory (container) | string  | `"/Volumes/Projects"`                     |
| `cursorSettings`        | Enable bind mount for Cursor editor settings   | boolean | `true`                                    |
| `cursorSource`          | Source path for Cursor settings (host)         | string  | `"${env:HOME}${env:USERPROFILE}/.cursor"` |
| `cursorTarget`          | Target path for Cursor settings (container)    | string  | `"/home/vscode/.cursor"`                  |

## Mount Types

### Terminal History Volume

- **Purpose**: Persists terminal history across container rebuilds
- **Type**: Named volume
- **Default**: `terminal-history` volume → `/commandhistory`

### Projects Directory Bind Mount

- **Purpose**: Provides access to project files outside the current workspace
- **Type**: Bind mount
- **Default**: `/Volumes/Projects` → `/Volumes/Projects`

### Cursor Settings Bind Mount

- **Purpose**: Synchronizes Cursor editor settings and extensions
- **Type**: Bind mount
- **Default**: `${env:HOME}${env:USERPROFILE}/.cursor` → `/home/vscode/.cursor`

## Important Notes

⚠️ **This feature only configures the mount options** - you must manually add the corresponding mount entries to your `devcontainer.json` file's `mounts` array.

The feature will display the exact mount strings you need to add during container setup.

## Supported Platforms

`linux/amd64` and `linux/arm64` platforms are supported.

## References

- [Dev Containers Specification - Mounts](https://containers.dev/implementors/json_reference/#mounts)
- [Docker Volume Documentation](https://docs.docker.com/storage/volumes/)
- [Docker Bind Mount Documentation](https://docs.docker.com/storage/bind-mounts/)
