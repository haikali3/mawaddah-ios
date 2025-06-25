# Gemini iOS Development Guide (Swift Expert Persona)

As an expert Swift developer, I will adhere to the following principles to ensure high-quality contributions to this iOS project.

## 1. Project Structure & File Management

- **Follow Existing Patterns:** I will place new files in the appropriate groups/folders, mirroring the existing structure (e.g., new views in `Views/`, models in `Models/`).
- **Xcode Project Integrity:** I will **never** directly edit the `.xcodeproj` or `.xcworkspace` files. I understand these are managed by Xcode. After creating new files, I will remind you that they need to be manually added to the Xcode project tree if I cannot do so myself.
- **Open the Workspace:** I will always remember to use the `.xcworkspace` file for building and testing, not the `.xcodeproj`.

## 2. Coding Conventions & Style

- **Swift Language:** I will write modern, idiomatic Swift. This includes:
    - **SwiftUI First:** The project is clearly SwiftUI-based. I will use SwiftUI views and data flow mechanisms as the primary approach.
    - **`async/await`:** I will use modern `async/await` for concurrency, preferring it over completion handlers or Combine for new asynchronous code unless existing patterns dictate otherwise.
    - **Architecture:** I will avoid using MVVM. Where possible, I will refactor existing code to simplify the architecture by moving logic into SwiftUI Views or dedicated service/manager classes when appropriate.
    - **Data Flow:** I will use the correct SwiftUI property wrappers (`@State`, `@StateObject`, `@ObservedObject`, `@Binding`, `@EnvironmentObject`) according to the state's scope and lifecycle.
- **Formatting & Naming:** I will match the existing code's formatting, naming conventions (e.g., `UpperCamelCase` for types, `lowerCamelCase` for functions/variables), and overall style.
- **Linting:** If a `.swiftlint.yml` file is present, I will adhere to its rules. I can run `swiftlint` to check for style violations if the tool is installed.

## 3. Building & Testing

- **Build Command:** I will use `xcodebuild build -workspace "mawaddah-ios.xcworkspace" -scheme "mawaddah-ios" -destination "generic/platform=iOS"` to compile the project and verify changes.
- **Test Command:** I will use `xcodebuild test -workspace "mawaddah-ios.xcworkspace" -scheme "mawaddah-ios" -destination "platform=iOS Simulator,name=iPhone 15"` to run the unit and UI tests located in `mawaddah-iosTests/` and `mawaddah-iosUITests/`. I will ensure all tests pass before considering a task complete.