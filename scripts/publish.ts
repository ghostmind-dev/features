import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx@8.1.3';

export default async function (args: CustomArgs, opts: CustomOptions) {
  $.verbose = true;

  const { env } = opts;
  const registry = 'ghcr.io';
  const namespace = 'ghostmind-dev/features';

  try {
    // Get all feature directories
    const srcPath = './app/src';

    console.log(`🔍 Scanning for features in: ${srcPath}`);

    // Read directory contents directly using Deno
    const features = [];
    for await (const dirEntry of Deno.readDir(srcPath)) {
      if (dirEntry.isDirectory) {
        const featurePath = `${srcPath}/${dirEntry.name}`;
        const featureConfigPath = `${featurePath}/devcontainer-feature.json`;

        console.log(`   Checking: ${dirEntry.name} -> ${featureConfigPath}`);

        try {
          await Deno.stat(featureConfigPath);
          features.push(dirEntry.name);
          console.log(`   ✅ Found feature: ${dirEntry.name}`);
        } catch {
          console.log(
            `   ❌ No devcontainer-feature.json in: ${dirEntry.name}`
          );
        }
      }
    }

    if (features.length === 0) {
      console.log('No devcontainer features found to publish');
      return;
    }

    console.log(
      `\n📦 Publishing ${features.length} devcontainer feature(s) to ${registry}/${namespace}`
    );

    // Publish each feature
    for (const feature of features) {
      const featurePath = `${srcPath}/${feature}`;

      console.log(`\n🚀 Publishing feature: ${feature}`);
      console.log(`   Source: ${featurePath}`);
      console.log(`   Target: ${registry}/${namespace}/${feature}`);

      try {
        // Use devcontainer CLI to publish the feature
        await $`devcontainer features publish ${featurePath} --registry ${registry} --namespace ${namespace}`;
        console.log(`✅ Successfully published ${feature}`);
      } catch (error) {
        console.error(`❌ Failed to publish ${feature}:`, error.message);
        throw error;
      }
    }

    console.log('\n🎉 All features published successfully!');
  } catch (error) {
    console.error('💥 Publishing failed:', error.message);
    process.exit(1);
  }
}
