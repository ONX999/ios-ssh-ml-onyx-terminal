# GitHub Copilot Instructions for Onyx Terminal

## Project Overview

Onyx Terminal is an iOS SSH terminal application with SFTP support and ML model command shortcuts. The project is built using:
- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Platform**: iOS 16.0+
- **Dependencies**: SwiftTerm, Shout (libssh2), swift-nio-ssh
- **Build Tool**: XcodeGen
- **Project Structure**: Single-target iOS app with modular organization

## Coding Standards

### Swift Style Guidelines

1. **Language**: Use Swift 5.9 features and conventions
2. **UI Framework**: Use SwiftUI for all UI components
3. **State Management**: 
   - Use `@StateObject` for view models and services
   - Use `@State` for local view state
   - Use `@AppStorage` for persistent user preferences
````instructions
# GitHub Copilot Instructions for Onyx Terminal

## Project Overview

Onyx Terminal is an iOS SSH terminal application with SFTP support and ML model command shortcuts. The project is built using:
- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Platform**: iOS 16.0+
- **Dependencies**: SwiftTerm, Shout (libssh2), swift-nio-ssh
- **Build Tool**: XcodeGen
- **Project Structure**: Single-target iOS app with modular organization

## Coding Standards

### Swift Style Guidelines

1. **Language**: Use Swift 5.9 features and conventions
2. **UI Framework**: Use SwiftUI for all UI components
3. **State Management**: 
   - Use `@StateObject` for view models and services
   - Use `@State` for local view state
   - Use `@AppStorage` for persistent user preferences
4. **Naming Conventions**:
   - Use camelCase for variables and functions
   - Use PascalCase for types (classes, structs, enums)
   - Prefix private properties with underscore when needed for clarity
5. **Comments**: 
   - Use Chinese (Traditional Chinese/繁體中文) for comments when contextually appropriate
   - Use English for API documentation and public interfaces
   - Both Chinese and English comments are acceptable based on context

### Code Organization

- **Models**: Place in `Sources/App/Models/` - Simple data structures
- **Views**: Place in `Sources/App/Views/` - SwiftUI view components
- **Services**: Place in `Sources/App/Services/` - Business logic, SSH/SFTP services
- **Utils**: Place in `Sources/App/Utils/` - Helper functions and utilities

### Localization

- The app supports bilingual interface: Traditional Chinese (zh-Hant) and English (en)
- Default language is Traditional Chinese (zh-Hant)
- Always use `LocalizedStringKey` for user-facing strings
- Use `NSLocalizedString` for dynamic strings that need comment context
- When adding new UI text:
  1. Use `LocalizedStringKey("key.name")` in SwiftUI views
  2. Ensure localization keys follow the pattern: `section.name`, `field.name`, `btn.action`, `hint.description`, etc.

### SwiftUI Best Practices

1. **Views**: Keep views focused and composable
2. **State**: Minimize state scope - use `@State` only where needed
3. **Observable Objects**: Use `@StateObject` for owned objects, `@ObservedObject` for injected dependencies
4. **Environment**: Use `@AppStorage` for user preferences that should persist
5. **Modifiers**: Chain view modifiers in a logical order (layout → styling → behavior)
6. **Performance**: Avoid heavy computations in view bodies; use computed properties or functions

### Error Handling

1. Use Swift's error handling with `do-catch` blocks
2. Provide user-friendly error messages in both Chinese and English
3. Log errors appropriately but avoid exposing sensitive information
4. For SSH/SFTP operations, handle network errors gracefully

### SSH/SFTP Specific Guidelines

1. **SFTP Paths**: 
   - Prefer absolute paths over relative paths
   - Be aware that `~` may not auto-expand in SFTP library
   - Document path requirements clearly
2. **Long-running Tasks**: 
   - Recommend using tmux/screen for long-running commands
   - Handle connection timeouts appropriately
3. **Security**:
   - Never log or expose passwords or keys in error messages
   - Use secure field types for password inputs
   - Validate connection parameters before attempting connections

## Build and Testing

### Building the Project

1. **Prerequisites**: Requires Xcode with iOS 16+ SDK
2. **Setup**:
   ```bash
   brew install xcodegen
   xcodegen generate
   ```
3. **Dependencies**: Managed via Swift Package Manager (SPM) - defined in `project.yml`
4. **Build**: Open `OnyxTerminal.xcodeproj` in Xcode

### Testing

- Currently no automated test infrastructure in place
- Manual testing required for SSH/SFTP functionality
- Test on real iOS devices as networking features may not work in simulator

### CI/CD

- GitHub Actions workflow exists at `.github/workflows/blank.yml`
- Basic CI setup is in place
- TestFlight deployment workflows may be configured separately

## Project-Specific Considerations

### Bundle Identifier
- Use `com.onx999.OnyxTerminal` (defined in project.yml)
- Product name: "Onyx Terminal"

### Deployment Target
- Minimum iOS version: 16.0
- Use features compatible with iOS 16+

### Quick Actions / Shortcuts
- The app includes ML model command shortcuts (llama.cpp, ollama, transformers, conda, tmux, etc.)
- Located in `QuickActionsBar` component
- When adding new shortcuts, ensure they're useful for terminal/ML workflows

### Dependencies
- **SwiftTerm**: Terminal emulator (main branch)
- **Shout**: SFTP support via libssh2 (main branch)
- **NIOSSH**: SSH protocol implementation (main branch)
- Avoid adding unnecessary dependencies; prefer built-in Swift/iOS frameworks

## Common Tasks

### Adding a New View
1. Create a new Swift file in `Sources/App/Views/`
2. Use SwiftUI `View` protocol
3. Add localized strings for any user-facing text
4. Follow existing view patterns for consistency

### Adding SSH/SFTP Features
1. Extend `SSHTerminalSession` or `SFTPService` in `Sources/App/Services/`
2. Handle errors appropriately and update status messages
3. Test with real SSH servers
4. Consider connection state management

### Modifying Localization
1. Ensure both Chinese and English strings are meaningful
2. Use appropriate localization keys (section.*, field.*, btn.*, etc.)
3. Test language switching works correctly
4. Remember default is Traditional Chinese (zh-Hant)

### Updating Dependencies
1. Modify `project.yml` packages section
2. Run `xcodegen generate` to update project
3. Test thoroughly as dependencies are from main branches

## Documentation

- Update `README.md` for user-facing changes
- Include code comments for complex logic
- Document any new configuration requirements
- Maintain bilingual support in documentation where appropriate

## Security and Privacy

- Never commit secrets, API keys, or credentials
- Use `.gitignore` to exclude sensitive files
- Handle user SSH credentials securely in memory
- Clear sensitive data when disconnecting
- Use iOS Keychain for credential storage if implementing persistence

## Pull Request Guidelines

- Keep changes focused and minimal
- Test on a real iOS device when possible
- Ensure localization is complete for UI changes
- Verify Xcode project generates correctly with `xcodegen`
- Document breaking changes clearly
- Include screenshots for UI changes

## Agent onboarding and scope (for automated coding agents)

These additional notes are intended for automated coding agents (for example GitHub Copilot coding agent) that are performing changes in this repository. Follow these rules in addition to the repository guidance above.

- Purpose: safely implement small-to-medium code changes, tests, documentation, and CI updates. Avoid large design shifts without human review.
- One change per pull request: keep PRs focused and small. Include a clear description, a short testing checklist, and localization updates if UI text changed.

Allowed edits (examples):
- Fix bugs in `Sources/**` and `Tests/**`.
- Add unit tests in `Tests/Unit/**` for new behaviors.
- Update `project.yml` and regenerate Xcode project entries if dependency changes are required.
- Add or update `.github/workflows/*` CI jobs to run tests or linters.

Disallowed edits:
- Do not add or modify deployment credentials, fastlane secrets, or other secret management files.
- Do not modify `fastlane/Fastfile` deployment logic without explicit human approval.

Agent behavior and checks:
- Write or update at least one unit test for any behavioral code change. If tests cannot run in this environment (Xcode required), include clear manual verification steps in the PR body.
- Follow localization rules: all user-facing strings must be added to `Sources/App/Resources/*/Localizable.strings` and use `LocalizedStringKey` in SwiftUI code.
- Preserve existing code style and file organization. Prefer small, well-tested commits.

Quality gates for automated edits:
- Build: Validate that `xcodegen generate` runs without error locally (note: actual Xcode build cannot be run here). If changing package dependencies, update `project.yml` and document the generation step.
- Tests: Add unit tests under `Tests/Unit` where practical. If adding Swift tests, ensure they compile (best-effort) and reference existing test targets.
- Lint/Typecheck: Respect Swift style guidelines above; avoid using language features that reduce compatibility with Swift 5.9/iOS 16.

When in doubt, create a draft pull request and add the maintainers as reviewers. Mark PR description with `WIP` and include a short rationale and verification steps.

Contact/owners:
- Primary repo owner: ONX999 (see repository settings for CODEOWNERS). Use PR reviewers for human approval on sensitive changes.

## How to run local checks (for contributors and agents)

- Generate Xcode project (requires xcodegen installed on macOS):

  ```bash
  # install xcodegen (macOS Homebrew)
  brew install xcodegen
  # generate project
  xcodegen generate
  ```

- Run repository structure check (Linux/macOS):

  ```bash
  ./Tools/check-structure.sh
  ```

- Tests: There is a `Tests` folder with unit and UI tests. Running tests requires Xcode. If you cannot run Xcode in your environment, include manual verification steps in PRs.

Notes:
- Automated agents should prefer adding unit tests under `Tests/Unit` for behavioral changes. If a full Xcode run is not possible in CI, add clear manual verification steps in the PR.

````
