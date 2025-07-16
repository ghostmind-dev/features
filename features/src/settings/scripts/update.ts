import type { CustomArgs, CustomOptions } from "jsr:@ghostmind/run";
import { readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { exit } from "node:process";

export default async function (_args: CustomArgs, opts: CustomOptions) {
  const { currentPath } = opts;

  console.log("🔄 Updating VS Code settings from remote config...");

  try {
    // Fetch the settings JSON from the remote GitHub repository
    const response = await fetch(
      "https://raw.githubusercontent.com/ghostmind-dev/config/main/config/vscode/settings.static.json"
    );

    if (!response.ok) {
      throw new Error(
        `Failed to fetch settings: ${response.status} ${response.statusText}`
      );
    }

    const settings = await response.json();

    if (
      typeof settings !== "object" ||
      settings === null ||
      Array.isArray(settings)
    ) {
      throw new Error("Invalid settings format: expected an object");
    }

    console.log(`⚙️  Found ${Object.keys(settings).length} settings to update`);

    // Read the current devcontainer-feature.json file
    const featureJsonPath = join(currentPath, "devcontainer-feature.json");
    const featureJsonContent = await readFile(featureJsonPath, "utf-8");
    const featureJson = JSON.parse(featureJsonContent);

    // Update the settings object in the customizations.vscode.settings
    if (!featureJson.customizations) {
      featureJson.customizations = {};
    }
    if (!featureJson.customizations.vscode) {
      featureJson.customizations.vscode = {};
    }

    featureJson.customizations.vscode.settings = settings;

    // Write the updated JSON back to the file
    await writeFile(featureJsonPath, JSON.stringify(featureJson, null, 4));

    console.log(
      "✅ Successfully updated devcontainer-feature.json with new settings"
    );
    console.log(`📍 Updated file: ${featureJsonPath}`);
  } catch (error) {
    if (error instanceof Error) {
      console.error("❌ Error updating settings:", error.message);
    } else {
      console.error("❌ An unknown error occurred during settings update.");
    }
    exit(1);
  }
}
