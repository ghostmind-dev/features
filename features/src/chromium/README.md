# Chromium (chromium)

Installs Chromium browser and required libraries for headless browser automation.

## Example Usage

```json
"features": {
    "ghcr.io/ghostmind-dev/features/chromium:1": {}
}
```

## Options

This feature has no configurable options.

## What's Installed

- `chromium` - The Chromium web browser
- `libnss3-tools` - Network Security Services tools for certificate management

## Notes

This feature installs the Chromium browser which can be used for:

- Headless browser automation
- Web scraping
- Testing web applications
- Browser-based development tools

The installation includes `libnss3-tools` which provides certificate management utilities often needed for browser automation scenarios.
