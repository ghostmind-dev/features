import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx@8.1.3';

export default async function (args: CustomArgs, opts: CustomOptions) {
  $.verbose = true;

  const featureName = args[0];

  if (!featureName) {
    console.error('Error: Feature name required');
    console.log('Usage: run custom symlink <feature-name>');
    console.log('Example: run custom symlink zsh');

    // List available features
    console.log('\nAvailable features:');
    const features = await $`ls features/src`;
    features.stdout
      .split('\n')
      .filter((f) => f.trim())
      .forEach((feature) => {
        console.log(`  - ${feature.trim()}`);
      });

    Deno.exit(1);
  }

  const { currentPath } = opts;

  // Check if feature exists
  const featureSrcPath = `${currentPath}/features/src/${featureName}`;
  const featureTestPath = `${currentPath}/features/test/${featureName}`;
  const devcontainerPath = `${featureTestPath}/.devcontainer`;

  try {
    await $`test -d ${featureSrcPath}`;
  } catch {
    console.error(
      `Error: Feature '${featureName}' does not exist in features/src/`
    );
    Deno.exit(1);
  }

  try {
    await $`test -d ${devcontainerPath}`;
  } catch {
    console.error(
      `Error: .devcontainer directory does not exist at ${devcontainerPath}`
    );
    console.log(
      'Make sure the feature has a test directory with .devcontainer'
    );
    Deno.exit(1);
  }

  const symlinkPath = `${devcontainerPath}/feature`;

  // Check if symlink already exists and remove it
  try {
    const stat = await Deno.lstat(symlinkPath);
    if (stat.isSymlink) {
      console.log(`🔗 Removing existing symlink: ${symlinkPath}`);
      await Deno.remove(symlinkPath);
      console.log('✅ Existing symlink removed');
    } else if (stat.isDirectory) {
      console.error(
        `❌ Error: '${symlinkPath}' exists but is a directory, not a symlink`
      );
      console.log('Please remove it manually or choose a different name');
      Deno.exit(1);
    } else if (stat.isFile) {
      console.error(
        `❌ Error: '${symlinkPath}' exists but is a file, not a symlink`
      );
      console.log('Please remove it manually or choose a different name');
      Deno.exit(1);
    }
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      // Symlink doesn't exist, which is fine
      console.log(`📁 No existing symlink found at ${symlinkPath}`);
    } else {
      console.error(`Error checking symlink: ${(error as Error).message}`);
      Deno.exit(1);
    }
  }

  // Create the symlink pointing directly to the specific feature source directory
  // From .devcontainer we need to go: ../../../src/featureName
  const targetPath = `../../../src/${featureName}`;
  try {
    await Deno.symlink(targetPath, symlinkPath);
    console.log(`✅ Created symlink for feature '${featureName}'`);
    console.log(`   ${symlinkPath} -> ${targetPath}`);
    console.log(
      `\nNow you can reference the feature in your devcontainer.json like:`
    );
    console.log(`   "./feature": {}`);
  } catch (error) {
    console.error(`❌ Failed to create symlink: ${(error as Error).message}`);
    Deno.exit(1);
  }
}
