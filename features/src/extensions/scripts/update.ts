import type { CustomArgs, CustomOptions } from "jsr:@ghostmind/run";
import { $ } from "npm:zx@8.1.3";
import { readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";

export default async function (_args: CustomArgs, opts: CustomOptions) {
  $.verbose = true;

  const { currentPath } = opts;

  console.log("🔄 Updating VS Code extensions from remote config...");

  try {
    // Fetch the extensions JSON from the remote GitHub repository
    const response = await fetch(
      "https://raw.githubusercontent.com/ghostmind-dev/config/main/config/vscode/extensions.json"
    );

    if (!response.ok) {
      throw new Error(
        `Failed to fetch extensions: ${response.status} ${response.statusText}`
      );
    }

    const extensions = await response.json();

    if (!Array.isArray(extensions)) {
      throw new Error("Invalid extensions format: expected an array");
    }

    console.log(`📦 Found ${extensions.length} extensions to update`);

    // Read the current devcontainer-feature.json file
    const featureJsonPath = join(currentPath, "devcontainer-feature.json");
    const featureJsonContent = await readFile(featureJsonPath, "utf-8");
    const featureJson = JSON.parse(featureJsonContent);

    // Update the extensions array in the customizations.vscode.extensions
    if (!featureJson.customizations) {
      featureJson.customizations = {};
    }
    if (!featureJson.customizations.vscode) {
      featureJson.customizations.vscode = {};
    }

    featureJson.customizations.vscode.extensions = extensions;

    // Write the updated JSON back to the file
    await writeFile(featureJsonPath, JSON.stringify(featureJson, null, 4));

    console.log(
      "✅ Successfully updated devcontainer-feature.json with new extensions"
    );
    console.log(`📍 Updated file: ${featureJsonPath}`);

    // Show a summary of changes
    console.log("\n📋 Extension Summary:");
    extensions.forEach((ext, index) => {
      console.log(`  ${index + 1}. ${ext}`);
    });
  } catch (error) {
    console.error("❌ Error updating extensions:", error.message);
    process.exit(1);
  }
}
