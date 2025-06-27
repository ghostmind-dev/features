# Quick Tutorial: Building a Real Custom Script

> **Based on Real Experience:** This tutorial documents the actual process of building a devcontainer feature testing script, including the challenges we encountered and how we solved them.

## The Challenge: Building a Feature Test Script

We needed to create a script that would:

1. Test devcontainer features in isolated environments
2. Handle different scenarios and configurations
3. Support various flags like `--verbose`, `--no-cleanup`, etc.
4. Work with the new folder structure (`app/src/` and `app/test/`)

## Step 1: Initial Script Structure

We started with a basic script structure:

```typescript
import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx';

export default async function (args: CustomArgs, opts: CustomOptions) {
  const { has, extract, env } = opts;

  // Get the feature name from arguments
  const featureName = args[0];

  if (!featureName) {
    console.error('❌ Error: Feature name required');
    console.log('Usage: run test <feature-name> [scenario] [options]');
    // ... help text
    Deno.exit(1);
  }

  // Extract flags and options
  const scenario = args[1];
  const verbose = has('verbose');
  const noCleanup = has('no-cleanup');
  const listScenarios = has('list-scenarios');
}
```

## Step 2: First Major Issue - Path Problems

**Problem:** Our initial script was looking for features in `src/` but they were actually in `app/src/`.

**Error we got:**

```
❌ Feature 'gcloud' not found in src/ directory
```

**Solution:** Update all paths to reflect the new structure:

```typescript
// ❌ OLD - Wrong paths
const featurePath = `${currentPath}/src/${featureName}`;
const scenariosPath = `${currentPath}/test/${featureName}/scenarios.json`;
const testScript = `test/${featureName}/test.sh`;

// ✅ NEW - Correct paths
const featurePath = `${currentPath}/app/src/${featureName}`;
const scenariosPath = `${currentPath}/app/test/${featureName}/scenarios.json`;
const testScript = `app/test/${featureName}/test.sh`;
```

## Step 3: Second Major Issue - Flag Handling

**Problem:** The `run custom` command was intercepting our flags before they reached our script.

**What we tried:**

```bash
run custom test gcloud --verbose  # ❌ Error: unknown option '--verbose'
```

**What actually works:**

```bash
run custom test gcloud verbose    # ✅ Works!
```

**Solution:** Handle flags as both actual flags AND as arguments:

```typescript
// Handle both scenario name and flags in arguments
let scenario = args[1];
let verbose = has('verbose');
let noCleanup = has('no-cleanup');

// Also check if flags are passed as arguments (fallback)
const remainingArgs = args.slice(1);
remainingArgs.forEach(arg => {
  if (arg === 'verbose') verbose = true;
  if (arg === 'no-cleanup') noCleanup = true;
  if (arg === 'list-scenarios') listScenarios = true;
});

// If the second argument is a flag, then no scenario was specified
if (scenario && (scenario === 'verbose' || scenario === 'no-cleanup' || /* ... */)) {
  scenario = undefined;
}
```

## Step 4: Third Major Issue - Devcontainer Path Problems

**Problem:** Devcontainer CLI doesn't accept absolute paths for local features.

**Error we got:**

```
An Absolute path to a local feature is not allowed.
Error: ERR: Feature '/Users/.../app/src/gcloud' could not be processed.
```

**Solution:** Use relative paths in the devcontainer configuration:

```typescript
// ❌ OLD - Absolute path
features[`${currentPath}/app/src/${featureName}`] =
  scenarios[scenarioName].features[featureName] || {};

// ✅ NEW - Relative path
features[`./src/${featureName}`] =
  scenarios[scenarioName].features[featureName] || {};
```

## Step 5: Fourth Major Issue - Test Script Failures

**Problem:** The test script was failing because it expected certain environment variables and had brittle version checking.

**Errors we got:**

```
❌ GOOGLE_APPLICATION_CREDENTIALS is not set
❌ gcloud version command failed
```

**Solution 1:** Add required environment variables to the devcontainer:

```typescript
containerEnv: {
  // ... other env vars
  GOOGLE_APPLICATION_CREDENTIALS: '/tmp/fake-credentials.json',
}
```

**Solution 2:** Make the test script more robust:

```bash
# ❌ OLD - Brittle version check
GCLOUD_VERSION=$(gcloud version --format="value(Google Cloud SDK)" 2>/dev/null)

# ✅ NEW - Robust version check with fallbacks
GCLOUD_VERSION=$(gcloud version 2>/dev/null | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
if [ -z "$GCLOUD_VERSION" ]; then
    GCLOUD_VERSION=$(gcloud --version 2>/dev/null | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
fi
```

## Step 6: Adding Better Error Reporting

**Problem:** When tests failed, we couldn't see what was happening.

**Solution:** Add verbose output handling:

```typescript
const testResult = await $`${testArgs}`;

if (verbose) {
  console.log('Test output:', testResult.stdout);
  if (testResult.stderr) {
    console.log('Test stderr:', testResult.stderr);
  }
}
```

## Final Working Usage Examples

After all the fixes, here's how the script works:

```bash
# Test all scenarios for a feature
run custom test gcloud

# Test a specific scenario
run custom test gcloud test

# Test with verbose output
run custom test gcloud verbose
run custom test gcloud test verbose

# Test with no cleanup (preserves containers for debugging)
run custom test gcloud no-cleanup
run custom test gcloud test no-cleanup

# Combine flags
run custom test gcloud test verbose no-cleanup

# List available scenarios
run custom test gcloud list-scenarios
```

## Key Lessons Learned

### 1. **Flag Handling is Tricky**

The `run custom` command intercepts `--flags`, so you need to handle flags passed as regular arguments too.

### 2. **Path Management is Critical**

Always verify your paths are correct for the actual project structure. Use relative paths for devcontainer features.

### 3. **Error Messages are Your Friend**

The actual error messages (like "Absolute path not allowed") were the key to solving problems.

### 4. **Test Scripts Need to be Robust**

Don't assume commands will work exactly as expected. Add fallbacks and better error handling.

### 5. **Verbose Mode is Essential for Debugging**

Always include a verbose mode to see what's actually happening when things go wrong.

## The Complete Working Script Structure

```typescript
import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx';

export default async function (args: CustomArgs, opts: CustomOptions) {
  // 1. Extract and validate arguments
  const featureName = args[0];
  if (!featureName) {
    // Show help and exit
  }

  // 2. Handle flags flexibly (both --flag and flag)
  let verbose = has('verbose');
  const remainingArgs = args.slice(1);
  remainingArgs.forEach((arg) => {
    if (arg === 'verbose') verbose = true;
    // ... other flags
  });

  // 3. Use correct paths for the project structure
  const featurePath = `${currentPath}/app/src/${featureName}`;
  const scenariosPath = `${currentPath}/app/test/${featureName}/scenarios.json`;

  // 4. Build devcontainer config with relative paths
  features[`./src/${featureName}`] =
    scenarios[scenarioName].features[featureName] || {};

  // 5. Add proper error handling and verbose output
  try {
    const testResult = await $`${testArgs}`;
    if (verbose) {
      console.log('Test output:', testResult.stdout);
    }
  } catch (error) {
    console.error('Test failed:', error.message);
    if (verbose) {
      console.error('Full error:', error);
    }
  }
}
```

This tutorial shows the real-world process of building a custom script, including all the gotchas and how to solve them!
