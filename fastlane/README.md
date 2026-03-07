# Fastlane

This directory contains Fastlane configuration for CI/CD.

## Available Actions

### ios doctor
Diagnostics: list schemes/targets and current configuration.

```bash
fastlane ios doctor
```

### ios build
Build IPA for App Store distribution.

```bash
fastlane ios build
```

### ios beta
Build and upload to TestFlight.

```bash
fastlane ios beta
```

## Environment Variables

- `PROJECT` - Path to .xcodeproj (LineFootball.xcodeproj)
- `SCHEME` - Xcode scheme name (LineFootball)
- `TEAM_ID` - Apple Developer Team ID (6Q97Y4WN67 — Ne-Va Spa)
- `BUNDLE_ID` - Bundle Identifier (app.linefootballtracker.com)
- `APP_STORE_CONNECT_KEY_ID` - ASC API Key ID
- `APP_STORE_CONNECT_ISSUER_ID` - ASC Issuer ID
- `APP_STORE_CONNECT_API_KEY` - ASC API Key content (.p8)
