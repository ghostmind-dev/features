# Run CLI (run)

Installs the run command line utility for development automation.

## Description

The run CLI is a powerful development utility system that executes TypeScript scripts using a standardized pattern. It provides rich context, argument parsing, and type safety for development automation tasks.

## Usage

```json
{
  "features": {
    "ghcr.io/ghostmind-dev/features/run:1": {}
  }
}
```

## Dependencies

This feature requires:

- **Deno**: The run CLI is built on Deno and requires it to be installed first
- **Git**: For cloning the run repository
- **Common utilities**: Basic system tools

## What it installs

- Clones the run repository from https://github.com/ghostmind-dev/run
- Installs the run CLI globally using `deno install`
- Adds the deno bin directory to PATH for all users

## Example Usage

After installation, you can use the run CLI to execute TypeScript scripts:

```bash
# Execute a custom script
run custom script_name [arguments...] [--flags]

# Example with a test script
run custom test
run custom test aws
run custom test aws debian11_default --list-scenarios
```

## Script Structure

All custom scripts follow this pattern:

```typescript
import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx';

export default async function (args: CustomArgs, opts: CustomOptions) {
  // Script logic here
  // args[0] = first argument, args[1] = second argument, etc.
  // opts.has('flag-name') = check for boolean flags
  // opts.extract('key') = extract key-value flags
  // opts.env = environment variables
  // opts.currentPath = current working directory
}
```

## Key Features

- **Rich Context**: Scripts receive environment variables, current path, and utility functions
- **Argument Parsing**: Easy access to positional arguments and flags
- **ZX Integration**: Built-in shell command execution with `$` from npm:zx
- **Type Safety**: Full TypeScript support with proper type definitions
- **Development Utility**: Primary tool for development automation

## Repository

https://github.com/ghostmind-dev/run
