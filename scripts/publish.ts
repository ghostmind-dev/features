import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx@8.1.3';

export default async function (args: CustomArgs, opts: CustomOptions) {
  $.verbose = true;

  const { env } = opts;
  const registry = 'ghcr.io';
  const namespace = 'ghostmind-dev/features';

  // Get the feature name from arguments (optional)
  const targetFeature = args[0];

  try {
    // Get all feature directories
    const srcPath = './features/src';

    console.log(`🔍 Scanning for features in: ${srcPath}`);

    // Read directory contents directly using Deno
    const allFeatures = [];
    for await (const dirEntry of Deno.readDir(srcPath)) {
      if (dirEntry.isDirectory) {
        const featurePath = `${srcPath}/${dirEntry.name}`;
        const featureConfigPath = `${featurePath}/devcontainer-feature.json`;

        console.log(`   Checking: ${dirEntry.name} -> ${featureConfigPath}`);

        try {
          await Deno.stat(featureConfigPath);
          allFeatures.push(dirEntry.name);
          console.log(`   ✅ Found feature: ${dirEntry.name}`);
        } catch {
          console.log(
            `   ❌ No devcontainer-feature.json in: ${dirEntry.name}`
          );
        }
      }
    }

    if (allFeatures.length === 0) {
      console.log('No devcontainer features found to publish');
      return;
    }

    // Determine which features to publish
    let featuresToPublish = allFeatures;

    if (targetFeature) {
      if (!allFeatures.includes(targetFeature)) {
        console.error(`❌ Feature '${targetFeature}' not found`);
        console.log('Available features:');
        allFeatures.forEach((name) => console.log(`  - ${name}`));
        Deno.exit(1);
      }
      featuresToPublish = [targetFeature];
      console.log(`\n🎯 Publishing specific feature: ${targetFeature}`);
    } else {
      console.log(`\n📦 Publishing all ${featuresToPublish.length} features`);
    }

    console.log(
      `\n📦 Publishing ${featuresToPublish.length} devcontainer feature(s) to ${registry}/${namespace}`
    );

    // Publish each feature
    for (const feature of featuresToPublish) {
      const featurePath = `${srcPath}/${feature}`;
      const featureConfigPath = `${featurePath}/devcontainer-feature.json`;

      console.log(`\n🚀 Publishing feature: ${feature}`);
      console.log(`   Source: ${featurePath}`);

      try {
        // Read feature metadata for version tagging
        const featureConfigText = await Deno.readTextFile(featureConfigPath);
        const featureConfig = JSON.parse(featureConfigText);
        const version = featureConfig.version || '1.0.0';
        const name = featureConfig.name || feature;

        console.log(`   📋 ${name} v${version}`);
        console.log(
          `   Target: ${registry}/${namespace}/${feature}:${version}`
        );

        // Publish with version tag
        await $`devcontainer features publish ${featurePath} --registry ${registry} --namespace ${namespace}`;

        console.log(`✅ Successfully published ${feature}:${version}`);
        console.log(
          `   📖 Usage: "${registry}/${namespace}/${feature}:${version}"`
        );
      } catch (error) {
        console.error(`❌ Failed to publish ${feature}:`, error.message);
        throw error;
      }
    }

    console.log('\n🎉 All features published successfully!');
    console.log(
      `\n🔗 Registry: https://github.com/ghostmind-dev/features/pkgs/container/features`
    );
  } catch (error) {
    console.error('💥 Publishing failed:', error.message);
    process.exit(1);
  }
}
