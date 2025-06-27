import type { CustomArgs, CustomOptions } from 'jsr:@ghostmind/run';
import { $ } from 'npm:zx';

export default async function (args: CustomArgs, opts: CustomOptions) {
  const { has, extract, env } = opts;

  // Get the feature name from arguments (optional)
  const featureName = args[0];

  // Handle flags
  let scenario = args[1];
  let verbose = has('verbose');
  let noCleanup = has('no-cleanup');
  let listScenarios = has('list-scenarios');
  let listFeatures = has('list-features');
  let noCommonUtils = has('no-common-utils');

  // Also check if flags are passed as arguments (fallback)
  const remainingArgs = args.slice(1);
  remainingArgs.forEach((arg) => {
    if (arg === 'verbose') verbose = true;
    if (arg === 'no-cleanup') noCleanup = true;
    if (arg === 'list-scenarios') listScenarios = true;
    if (arg === 'list-features') listFeatures = true;
    if (arg === 'no-common-utils') noCommonUtils = true;
  });

  // If the second argument is a flag, then no scenario was specified
  if (
    scenario &&
    (scenario === 'verbose' ||
      scenario === 'no-cleanup' ||
      scenario === 'list-scenarios' ||
      scenario === 'list-features' ||
      scenario === 'no-common-utils')
  ) {
    scenario = undefined;
  }

  const { currentPath } = opts;

  // Discover available features
  const availableFeatures: string[] = [];
  try {
    for await (const entry of Deno.readDir(`${currentPath}/app/src`)) {
      if (entry.isDirectory) {
        // Check if the feature has a corresponding test directory
        try {
          await Deno.stat(`${currentPath}/app/test/${entry.name}`);
          availableFeatures.push(entry.name);
        } catch {
          // Feature exists but no test directory - skip
          if (verbose) {
            console.log(
              `⚠️  Feature '${entry.name}' has no test directory, skipping`
            );
          }
        }
      }
    }
  } catch {
    console.error('❌ Error: Could not read features directory (app/src)');
    Deno.exit(1);
  }

  if (availableFeatures.length === 0) {
    console.error('❌ No testable features found');
    console.log('Features must have both:');
    console.log('  - app/src/<feature-name>/ directory');
    console.log('  - app/test/<feature-name>/ directory');
    Deno.exit(1);
  }

  // List available features if requested or no feature specified
  if (listFeatures || !featureName) {
    console.log('📋 Available features for testing:');
    availableFeatures.forEach((name, index) => {
      console.log(`  ${index + 1}. ${name}`);
    });

    if (!featureName) {
      console.log('');
      console.log('Usage: run test <feature-name> [scenario] [options]');
      console.log('');
      console.log('Examples:');
      console.log(
        `  run test ${availableFeatures[0]}                    # Test all scenarios for ${availableFeatures[0]}`
      );
      console.log(
        `  run test ${availableFeatures[0]} debian11_default  # Test specific scenario`
      );
      console.log(
        `  run test ${availableFeatures[0]} --list-scenarios  # List available scenarios`
      );
      console.log('');
      console.log('Options:');
      console.log('  --list-features     List all available features');
      console.log(
        '  --list-scenarios    List all available scenarios for the feature'
      );
      console.log('  --verbose          Show detailed output');
      console.log('  --no-cleanup       Keep containers after test');
      console.log('  --no-common-utils  Skip installing common utilities');
      Deno.exit(0);
    }

    if (listFeatures) {
      return;
    }
  }

  // Verify feature exists and is testable
  if (!availableFeatures.includes(featureName)) {
    console.error(`❌ Feature '${featureName}' not found or not testable`);
    console.log('Available features:');
    availableFeatures.forEach((name) => console.log(`  - ${name}`));
    console.log('');
    console.log(
      '💡 Features must have both app/src/<name>/ and app/test/<name>/ directories'
    );
    Deno.exit(1);
  }

  // Check if scenarios.json exists
  const scenariosPath = `${currentPath}/app/test/${featureName}/scenarios.json`;
  let scenarios: Record<string, any> = {};

  try {
    const scenariosContent = await Deno.readTextFile(scenariosPath);
    scenarios = JSON.parse(scenariosContent);
  } catch {
    console.error(`❌ No scenarios.json found for feature '${featureName}'`);
    console.log(`Expected: ${scenariosPath}`);
    Deno.exit(1);
  }

  // List scenarios if requested
  if (listScenarios) {
    console.log(`📋 Available scenarios for '${featureName}':`);
    Object.keys(scenarios).forEach((scenarioName, index) => {
      const config = scenarios[scenarioName];
      console.log(`  ${index + 1}. ${scenarioName}`);
      console.log(`     Image: ${config.image}`);
      console.log(
        `     Features: ${JSON.stringify(config.features, null, 2).replace(
          /\n/g,
          '\n     '
        )}`
      );
      console.log('');
    });
    return;
  }

  // Determine which scenarios to test
  const scenariosToTest = scenario ? [scenario] : Object.keys(scenarios);

  if (scenario && !scenarios[scenario]) {
    console.error(
      `❌ Scenario '${scenario}' not found for feature '${featureName}'`
    );
    console.log('Available scenarios:');
    Object.keys(scenarios).forEach((name) => console.log(`  - ${name}`));
    Deno.exit(1);
  }

  console.log(`🧪 Testing feature '${featureName}'`);
  console.log(`📊 Scenarios to test: ${scenariosToTest.join(', ')}`);
  if (!noCommonUtils) {
    console.log('🔧 Common utilities will be installed automatically');
  }
  console.log('');

  let totalTests = 0;
  let passedTests = 0;
  let failedTests = 0;

  // Test each scenario
  for (const scenarioName of scenariosToTest) {
    totalTests++;
    console.log(`🔍 Testing scenario: ${scenarioName}`);
    console.log(`📦 Image: ${scenarios[scenarioName].image}`);

    try {
      // Create temporary devcontainer.json for this test
      const tempDir = await Deno.makeTempDir({
        prefix: `devcontainer-test-${featureName}-`,
      });

      // Build features configuration with common-utils first (if not disabled)
      const features: Record<string, any> = {};

      if (!noCommonUtils) {
        // Add common-utils as the first feature to ensure basic tools are available
        features['ghcr.io/devcontainers/features/common-utils:2'] = {
          installZsh: true,
          installOhMyZsh: true,
          upgradePackages: true,
          username: 'automatic',
          uid: 'automatic',
          gid: 'automatic',
        };
      }

      // Add the feature being tested (use relative path for local features)
      features[`./src/${featureName}`] =
        scenarios[scenarioName].features[featureName] || {};

      const devcontainerConfig = {
        name: `test-${featureName}-${scenarioName}`,
        image: scenarios[scenarioName].image,
        features: features,
        // Ensure we can run tests
        remoteUser: 'vscode',
        containerEnv: {
          // Pass feature options as environment variables for the test script
          ...Object.keys(
            scenarios[scenarioName].features[featureName] || {}
          ).reduce((env, key) => {
            const value = scenarios[scenarioName].features[featureName][key];
            env[key.toUpperCase()] =
              typeof value === 'boolean' ? value.toString() : value;
            return env;
          }, {} as Record<string, string>),
          // Set required environment variables for testing
          GOOGLE_APPLICATION_CREDENTIALS: '/tmp/fake-credentials.json',
        },
      };

      // Create .devcontainer directory and config file
      const devcontainerDir = `${tempDir}/.devcontainer`;
      await Deno.mkdir(devcontainerDir, { recursive: true });

      // Copy the feature source files to .devcontainer directory
      const tempSrcDir = `${devcontainerDir}/src`;
      await Deno.mkdir(tempSrcDir, { recursive: true });

      // Copy the entire feature directory
      const featureSourceDir = `app/src/${featureName}`;
      const tempFeatureDir = `${tempSrcDir}/${featureName}`;
      await Deno.mkdir(tempFeatureDir, { recursive: true });

      // Copy all files from the feature directory
      for await (const entry of Deno.readDir(featureSourceDir)) {
        if (entry.isFile) {
          await Deno.copyFile(
            `${featureSourceDir}/${entry.name}`,
            `${tempFeatureDir}/${entry.name}`
          );
        }
      }

      const configPath = `${devcontainerDir}/devcontainer.json`;
      await Deno.writeTextFile(
        configPath,
        JSON.stringify(devcontainerConfig, null, 2)
      );

      if (verbose) {
        console.log(`📄 Generated devcontainer.json:`);
        console.log(JSON.stringify(devcontainerConfig, null, 2));
        console.log('');
      }

      // Build and start the container
      console.log('🔨 Building container...');
      const upArgs = [
        'devcontainer',
        'up',
        '--workspace-folder',
        tempDir,
        '--log-level',
        verbose ? 'debug' : 'info',
      ];

      if (verbose) {
        console.log(`Running: ${upArgs.join(' ')}`);
      }

      await $`${upArgs}`;

      // Run the test
      console.log('🧪 Running feature test...');
      const testScript = `app/test/${featureName}/test.sh`;

      // Check if test script exists
      try {
        await Deno.stat(testScript);
      } catch {
        console.warn(
          `⚠️  No test script found at ${testScript}, skipping test execution`
        );
        console.log('✅ Build successful (no tests to run)');
        passedTests++;
        continue;
      }

      // Copy test script to temp directory
      await Deno.copyFile(testScript, `${tempDir}/test.sh`);

      // Run the test inside the container
      const testArgs = [
        'devcontainer',
        'exec',
        '--workspace-folder',
        tempDir,
        'bash',
        'test.sh',
      ];

      if (verbose) {
        console.log(`Running: ${testArgs.join(' ')}`);
      }

      const testResult = await $`${testArgs}`;

      if (verbose) {
        console.log('Test output:', testResult.stdout);
        if (testResult.stderr) {
          console.log('Test stderr:', testResult.stderr);
        }
      }

      console.log(`✅ Scenario '${scenarioName}' passed!`);
      passedTests++;

      // Cleanup unless --no-cleanup is specified
      if (!noCleanup) {
        console.log('🧹 Cleaning up...');
        try {
          await $`devcontainer down --workspace-folder ${tempDir}`;
        } catch (error) {
          if (verbose) {
            console.warn('Warning during cleanup:', error.message);
          }
        }
        await Deno.remove(tempDir, { recursive: true });
      } else {
        console.log(`📁 Test files preserved at: ${tempDir}`);
      }
    } catch (error) {
      console.error(`❌ Scenario '${scenarioName}' failed!`);
      if (verbose) {
        console.error('Error details:', error);
      } else {
        console.error('Error:', error.message);
        console.log('💡 Use --verbose for detailed error information');
      }
      failedTests++;
    }

    console.log('');
  }

  // Summary
  console.log('📊 Test Summary:');
  console.log(`   Total scenarios: ${totalTests}`);
  console.log(`   ✅ Passed: ${passedTests}`);
  console.log(`   ❌ Failed: ${failedTests}`);

  if (failedTests > 0) {
    console.log('');
    console.log('💡 Tips for debugging failures:');
    console.log('  - Use --verbose for detailed output');
    console.log('  - Use --no-cleanup to inspect generated files');
    console.log('  - Check the feature installation script and test script');
    console.log(
      '  - Use --no-common-utils if common utilities cause conflicts'
    );
    Deno.exit(1);
  } else {
    console.log('');
    console.log(`🎉 All tests passed for feature '${featureName}'!`);
  }
}
