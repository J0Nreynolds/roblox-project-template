# Cloud Testing Setup

This project supports running tests via Roblox's Open Cloud API, enabling CI/CD testing without requiring local `run-in-roblox` installation.

## Overview

Cloud testing uses Roblox's **Open Cloud Luau Execution API** to:
1. Upload your test place to a dedicated Roblox test place
2. Execute your Jest test runner remotely in Roblox's cloud
3. Retrieve test results and logs via the API

This approach works on **any platform** (Windows, macOS, Linux) and is perfect for CI/CD environments.

## Setup Requirements

### 1. Create Test Place

Create the place file dedicated to testing using this command: 
```bash
lune run build-test
```
> **Note:** This step is only necessary if you haven't already created a test place. If you have, skip to the next section.

Open the place in Roblox Studio and publish it.

### 2. Generate Open Cloud API Key

1. Go to [Roblox Creator Hub](https://create.roblox.com/)
2. Navigate to your experience settings
3. Go to the **Open Cloud** section  
4. Create a new API key with these permissions for **both** your test place:
   - Select API System: `universe-places` 
      - Enable `write` operation: `universe-places:write`
   - Select API System: `luau-execution-sessions` 
      - Enable `write` operation: `universe.place.luau-execution-session:write`
5. Save your API key and use it in the next step

### 3. Setup Environment Variables
You will need 
- Your Open Cloud API key
- Your test project's place ID
- Your test project's universe ID

You can get the place ID and universe ID from your [creator dashboard](https://create.roblox.com/dashboard/creations). 
- Mouse over the square place card and click the three dot menu. 
- Select **Copy Start Place ID** to get the place ID
- Select **Copy -> Copy Universe ID** to get the universe ID

#### Option 1: Environment Variables (Recommended for CI/CD)

For local testing:
```bash
export ROBLOX_API_KEY="your_api_key_here"
export ROBLOX_TEST_UNIVERSE_ID="your_test_universe_id"
export ROBLOX_TEST_PLACE_ID="your_test_place_id"
```

For CI/CD (GitHub Actions):
- **[Set Repository Secrets](../../settings/secrets/actions)**: `ROBLOX_API_KEY`, `ROBLOX_TEST_UNIVERSE_ID`, `ROBLOX_TEST_PLACE_ID`
> **Note:** Your `ROBLOX_TEST_UNIVERSE_ID` and `ROBLOX_TEST_PLACE_ID` can be set as **[repository variables](../../settings/variables/actions)** rather than [repository secrets](../../settings/secrets/actions) if desired (e.g. replace `secrets.ROBLOX_TEST_UNIVERSE_ID` with `vars.ROBLOX_TEST_UNIVERSE_ID` in the `ci.yml` file)

#### Option 2: Configuration File (Recommended for Local Development)

1. Copy the template file:
   ```bash
   cp project.config.template.toml project.config.toml
   ```

2. Edit `project.config.toml` and fill in your values:
   ```toml
   [project]
   name = "YourProjectName"
   
   [cloud]
   test_place_id = "your_test_place_id"
   test_universe_id = "your_test_universe_id"
   api_key = "your_api_key_here"
   ```

> **⚠️ SECURITY WARNING**: 
> - `project.config.toml` is gitignored and will NOT be committed to version control
> - **Never commit API keys** to your repository
> - For CI/CD, you can use GitHub repository variables/secrets instead of the config file
> - Make sure you copy to `project.config.toml` (not `project.config.template.toml`) to ensure it's gitignored

## Usage

### Local Testing
```bash
lune run test-cloud    # Run tests via Open Cloud
```

### CI Integration

The GitHub Actions workflow automatically runs cloud tests when the required variables are configured:

```yaml
test-cloud:
  name: Test (Cloud)
  runs-on: ubuntu-latest
  # ... rest of job configuration
```

## How It Works

1. **Build**: Creates test project with Jest-Lua test runner
2. **Upload**: Uploads `.rbxl` file to test place via Open Cloud API
3. **Execute**: Runs cloud test task that executes the Jest test runner
4. **Retrieve**: Gets test logs and results from the cloud execution
5. **Report**: Parses results and exits with appropriate code for CI

## File Structure

```
lune/
├── test-cloud.luau            # Main cloud testing script
└── lib/
    └── config.luau             # Configuration loader

python/
├── upload_and_run_task.py     # Handles place upload and task execution
└── luau_execution_task.py     # Open Cloud API wrapper

tasks/
└── cloud-test-runner.luau     # Cloud execution task script
```

## Benefits

- **Platform Independent**: Works on Windows, macOS, and Linux
- **CI/CD Ready**: Perfect for GitHub Actions and other CI systems
- **No Local Dependencies**: No need for `run-in-roblox` installation
- **Consistent Environment**: Tests run in actual Roblox cloud infrastructure
- **Parallel Safe**: Can run multiple test jobs concurrently (with API limits)

## Limitations

- **API Rate Limits**: Roblox Open Cloud has concurrency limits on the number of parallel tasks that can be run per universe
- **Setup Required**: Requires initial API key and place configuration
- **Network Dependent**: Requires internet connectivity

## Troubleshooting

### Missing Environment Variables
```
❌ ROBLOX_API_KEY environment variable required
```
Ensure all required environment variables are set.

### API Permission Errors
Verify your API key has the correct permissions for both test and production places.

### Concurrency Issues
If multiple cloud tests fail, check API rate limits. The CI workflow uses concurrency groups to prevent this.

## Integration with [place-ci-cd-demo](https://github.com/Roblox/place-ci-cd-demo)

This implementation is based on [Roblox's place-ci-cd-demo](https://github.com/Roblox/place-ci-cd-demo) and uses their Python scripts for Open Cloud API interaction. The scripts have been adapted to work with our Jest-Lua testing infrastructure.