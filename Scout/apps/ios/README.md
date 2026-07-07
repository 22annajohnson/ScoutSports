# Scout iOS App Placeholder

This directory is reserved for the future iOS app location in the Scout monorepo.

The existing Swift/SwiftUI iOS application has not been moved yet. It currently remains in its original root-level location, including:

- `Scout/`
- `ScoutTests/`
- `ScoutUITests/`
- `Scout.xcodeproj`
- `fastlane/`
- root-level Xcode configuration and build files

Do not move files into this directory, update Xcode references, rename source folders, change package paths, or alter build settings until an approved iOS monorepo migration plan exists.

Any future migration should preserve:

- Xcode project integrity
- Build and test workflows
- Fastlane configuration
- App target naming
- Existing feature organization
- CI behavior
- Git history readability
