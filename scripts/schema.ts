import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx';

interface FeatureOption {
  type: string;
  default?: any;
  description?: string;
  enum?: string[];
}

interface FeatureConfig {
  id: string;
  name: string;
  description: string;
  options: Record<string, FeatureOption>;
}

export default async function (args: CustomArgs, opts: CustomOptions) {
  console.log('🔄 Generating DevContainer schema from feature definitions...');

  const featuresDir = 'features/src';
  const schemaPath = 'config/schema.json';

  // Get all feature directories
  const featureDirs = await $`ls ${featuresDir}`.then((result: any) =>
    result.stdout
      .trim()
      .split('\n')
      .filter((dir: string) => dir.trim())
  );

  console.log(
    `📁 Found ${featureDirs.length} features: ${featureDirs.join(', ')}`
  );

  const features: FeatureConfig[] = [];

  // Process each feature
  for (const featureDir of featureDirs) {
    const featureJsonPath = `${featuresDir}/${featureDir}/devcontainer-feature.json`;

    try {
      const featureJson = await Deno.readTextFile(featureJsonPath);
      const featureConfig: FeatureConfig = JSON.parse(featureJson);
      features.push(featureConfig);
      console.log(`✅ Processed feature: ${featureConfig.id}`);
    } catch (error) {
      console.warn(
        `⚠️  Could not process feature ${featureDir}:`,
        (error as Error).message
      );
    }
  }

  // Generate schema
  const schema = generateSchema(features);

  // Write schema to file
  await Deno.writeTextFile(schemaPath, JSON.stringify(schema, null, 2));

  console.log(`🎉 Schema generated successfully at ${schemaPath}`);
  console.log(
    `📊 Schema includes ${features.length} features with auto-completion support`
  );
}

function generateSchema(features: FeatureConfig[]) {
  const featureProperties: Record<string, any> = {};
  const definitions: Record<string, any> = {};

  // Process each feature
  for (const feature of features) {
    const featureId = feature.id;
    const definitionName = `${featureId}Feature`;

    // Add feature properties (both versioned and non-versioned)
    featureProperties[`ghcr.io/ghostmind-dev/features/${featureId}`] = {
      $ref: `#/definitions/${definitionName}`,
    };
    featureProperties[`ghcr.io/ghostmind-dev/features/${featureId}:1`] = {
      $ref: `#/definitions/${definitionName}`,
    };

    // Create feature definition
    const definition: any = {
      type: 'object',
      description: feature.description,
      additionalProperties: false,
    };

    // Add options if they exist
    if (feature.options && Object.keys(feature.options).length > 0) {
      definition.properties = {};

      for (const [optionName, option] of Object.entries(feature.options)) {
        const propDef: any = {
          type: option.type,
          description: option.description,
        };

        if (option.default !== undefined) {
          propDef.default = option.default;
        }

        if (option.enum) {
          propDef.enum = option.enum;
        }

        definition.properties[optionName] = propDef;
      }
    }

    definitions[definitionName] = definition;
  }

  return {
    $schema: 'http://json-schema.org/draft-07/schema#',
    title: 'Dev Container Configuration with Ghostmind Features',
    description:
      'Enhanced DevContainer configuration with auto-completion support for ghostmind-dev features',
    allOf: [
      {
        $ref: 'https://raw.githubusercontent.com/devcontainers/spec/main/schemas/devContainer.base.schema.json',
      },
      {
        type: 'object',
        properties: {
          features: {
            type: 'object',
            description: 'Features to add to the dev container',
            additionalProperties: true,
            properties: featureProperties,
          },
        },
      },
    ],
    definitions: definitions,
  };
}
