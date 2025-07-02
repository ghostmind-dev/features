import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx@8.1.3';

export default async function (_args: CustomArgs, opts: CustomOptions) {
  try {
    // Read the devcontainer-feature.json file
    const featureConfigPath = `${opts.currentPath}/devcontainer-feature.json`;
    const featureConfigText = await Deno.readTextFile(featureConfigPath);
    const featureConfig = JSON.parse(featureConfigText);

    // Extract the extensions list
    const extensions = featureConfig.customizations?.vscode?.extensions || [];

    if (extensions.length === 0) {
      console.log('No extensions found in devcontainer-feature.json');
      return;
    }

    console.log(`Found ${extensions.length} extensions. Fetching details...\n`);

    // Prepare table data
    const tableData: Array<{ name: string; description: string; url: string }> =
      [];

    // Process each extension
    for (const extensionId of extensions) {
      try {
        console.log(`Fetching info for: ${extensionId}`);

        // Use vsce to get extension info
        const result = await $`vsce show ${extensionId} --json`.quiet();
        const extensionInfo = JSON.parse(result.stdout);

        // Extract relevant information
        const name =
          extensionInfo.displayName || extensionInfo.name || extensionId;
        const description =
          extensionInfo.shortDescription ||
          extensionInfo.description ||
          'No description available';
        const url = `https://marketplace.visualstudio.com/items?itemName=${extensionId}`;

        tableData.push({
          name: name,
          description:
            description.length > 100
              ? description.substring(0, 97) + '...'
              : description,
          url: url,
        });
      } catch (error) {
        const errorMessage =
          error instanceof Error ? error.message : String(error);
        console.log(
          `⚠️  Could not fetch info for ${extensionId}: ${errorMessage}`
        );

        // Add fallback entry
        tableData.push({
          name: extensionId,
          description: 'Extension info not available',
          url: `https://marketplace.visualstudio.com/items?itemName=${extensionId}`,
        });
      }
    }

    // Generate the table
    console.log('\n📋 Extension Information Table:\n');
    console.log('| Name | Description | URL |');
    console.log('|------|-------------|-----|');

    for (const extension of tableData) {
      // Escape pipe characters in the data
      const name = extension.name.replace(/\|/g, '\\|');
      const description = extension.description.replace(/\|/g, '\\|');
      const url = extension.url.replace(/\|/g, '\\|');

      console.log(`| ${name} | ${description} | ${url} |`);
    }

    console.log(`\n✅ Processed ${tableData.length} extensions successfully!`);
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error('❌ Error:', errorMessage);
    Deno.exit(1);
  }
}
