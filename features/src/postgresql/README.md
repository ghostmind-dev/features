# PostgreSQL Client (postgresql)

Installs the PostgreSQL client tools for connecting to and managing PostgreSQL databases.

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/postgresql:1": {}
}
```

## Options

| Options Id | Description                      | Type   | Default Value |
| ---------- | -------------------------------- | ------ | ------------- |
| version    | Version of PostgreSQL to install | string | latest        |

## Supported platforms

`linux/amd64` and `linux/arm64` platforms are supported.

## What's Included

- `psql` - PostgreSQL interactive terminal
- `pg_dump` - PostgreSQL database backup utility
- `pg_restore` - PostgreSQL database restore utility
- Other PostgreSQL client utilities

## References

- [PostgreSQL documentation](https://www.postgresql.org/docs/current/app-psql.html)
