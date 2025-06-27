# OpenCode.md

## Build Commands

```bash
# Open project
open mawaddah-ios.xcodeproj
# Build from command line
xcodebuild -project mawaddah-ios.xcodeproj -scheme mawaddah-ios -destination 'platform=iOS Simulator,name=iPhone 16' build
# Run tests
xcodebuild -project mawaddah-ios.xcodeproj -scheme mawaddah-ios -destination 'platform=iOS Simulator,name=iPhone 16' test
# Run single test
xcodebuild -project mawaddah-ios.xcodeproj -scheme mawaddah-ios -destination 'platform=iOS Simulator,name=iPhone 16' test -only-testing:mawaddah-iosTests/mawaddah_iosTests/example
```

## Code Style Guidelines

- **Imports**: SwiftUI/Foundation first, one import per line
- **Naming**: PascalCase for types, camelCase for properties/functions
- **Types**: Explicit type declarations for properties, return types, and parameters
- **Formatting**: 2-space indentation, braces on same line, consistent spacing
- **Error Handling**: Optional chaining, nil coalescing, guard statements
- **Architecture**: Singleton pattern for services, @State for local view state
- **Models**: Conform to Identifiable, Codable, Hashable; use UUID for IDs
- **Documentation**: /// for public types/methods, // MARK: for code sections
- **SwiftUI**: Trailing closures for modifiers, Preview providers at file end
- **Dependencies**: No external dependencies - use native iOS frameworks only
