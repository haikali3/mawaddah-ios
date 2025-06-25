# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Mawaddah** is a SwiftUI-based iOS relationship advice app that helps users evaluate potential relationships through structured questions, statistics, and AI analysis.

## Development Environment

- **Platform**: iOS 16.0+ deployment target
- **Language**: Swift 5.7+
- **Framework**: SwiftUI
- **Development**: Xcode 14+
- **Dependency Management**: None (no external dependencies)

## Build Commands

### Basic Development
```bash
# Open the project
open mawaddah-ios.xcodeproj

# Build in Xcode
# Use Cmd+B or Cmd+R in Xcode

# Build from command line
xcodebuild -project mawaddah-ios.xcodeproj -scheme mawaddah-ios -destination 'platform=iOS Simulator,name=iPhone 16' build
```

### Testing
```bash
# Run tests in Xcode
# Use Cmd+U in Xcode for unit tests
# Test targets: mawaddah-iosTests, mawaddah-iosUITests
```

## Architecture

### Pattern: Plain SwiftUI with Data Services
- **Models**: `Person`, `Question` with Codable conformance
- **Views**: SwiftUI views organized in `/Views` folder
- **Services**: Simple data service (`PersonStore`) using singleton pattern
- **State**: Local `@State` properties in views

### Key Components

**TabView Architecture**: 4-tab structure
- Questions Tab: Swipeable flashcard interface with 1-5 rating system
- Partners Tab: Person management and selection
- Statistics Tab: Data visualization using native SwiftUI Charts framework
- AI Analysis Tab: Core ML integration (placeholder implementation)

**Data Flow**:
- `PersonStore.shared`: Singleton service for data management
- Direct function calls for question navigation
- `QuestionRepository`: JSON-based question loading with fallbacks

## Dependencies

### Native iOS Frameworks Only
- **SwiftUI**: UI framework
- **Charts**: Native visualization (iOS 16+)
- No external dependencies or package managers

### Data Storage
- **UserDefaults**: Primary persistence for persons, ratings, app state
- **JSON Files**: Question data in `/Resources` folder (multilingual support)

## Project Structure

```
mawaddah-ios/
├── Models/                    # Data models and repository
├── Services/                  # Data services (PersonStore)
├── Views/                    # UI components organized by feature
│   └── Questions/           # Question-specific UI components
├── Resources/               # JSON data files (questions-en.json, questions-bm.json)
└── Assets.xcassets/        # App assets
```

## Key Development Patterns

### State Management
- Use `@State` for local view state
- Use `PersonStore.shared` singleton for shared data
- No environment objects or observable objects

### Data Models
- All models conform to `Identifiable`, `Codable`, `Hashable`
- Use `UUID` for stable identifiers
- Simple structs for data transfer

### UI Patterns
- Swipeable cards with custom gesture handling
- Heart-based rating system (1-5 scale)
- Consistent color theming via `AppColors` and `QuestionColors`
- Native SwiftUI Charts for data visualization

## Important Files

- `Services/PersonStore.swift`: Data service with UserDefaults persistence
- `QuestionRepository.swift`: Question loading with JSON fallback system
- `ContentView.swift`: Root TabView structure
- `Resources/questions-*.json`: Localized question data

## Current Limitations

- AI Analysis uses placeholder Core ML implementation
- Test coverage is minimal
- No data export/import functionality

## Development Notes

- No external dependencies - pure iOS development
- Always test data persistence by checking UserDefaults behavior
- Question JSON files support bilingual content (English/Bahasa Malaysia)
- Statistics tab uses native SwiftUI Charts for all visualizations
- Use singleton pattern for shared data access across views