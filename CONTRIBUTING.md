# Contributing to Onyx Terminal

Thank you for your interest in contributing to Onyx Terminal! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background or identity.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

### Prerequisites

1. **macOS** with Xcode 15.0+
2. **Homebrew** package manager
3. **Ruby** 3.0+ (for Fastlane)
4. **Git** for version control

### Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/ONX999/ios-ssh-ml-onyx-terminal.git
cd ios-ssh-ml-onyx-terminal

# Install XcodeGen
brew install xcodegen

# Install Ruby dependencies
bundle install

# Install SwiftLint
brew install swiftlint

# Generate Xcode project
xcodegen generate

# Open in Xcode
open OnyxTerminal.xcworkspace
```

## 🔄 Development Workflow

### Branch Strategy

We use **Git Flow** branching model:

- `main` - Production-ready code, only accepts PRs from `develop` or hotfix branches
- `develop` - Development integration branch
- `feature/*` - Feature development branches
- `fix/*` - Bug fix branches
- `hotfix/*` - Emergency fixes for production
- `release/*` - Release preparation branches

### Creating a Feature Branch

```bash
# Start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### Working on Your Changes

1. Make your changes in small, logical commits
2. Write or update tests as needed
3. Run linter and tests locally before committing
4. Keep your branch up to date with develop

```bash
# Sync with develop regularly
git fetch origin
git rebase origin/develop

# Run linter
bundle exec fastlane lint

# Run tests
bundle exec fastlane test
```

## 💻 Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and enforce them with SwiftLint.

### Key Principles

1. **Clarity at the point of use** is your most important goal
2. **Prefer clarity over brevity**
3. **Use terminology well** - avoid obscure terms
4. **Strive for fluent usage**
5. **Name protocols** according to what they do
6. **Name types** according to what they are

### SwiftLint Rules

All code must pass SwiftLint checks:

```bash
bundle exec fastlane lint
```

Common rules:
- Line length: max 150 characters
- Function body length: max 60 lines (warning), 100 (error)
- Type body length: max 300 lines (warning), 500 (error)
- Cyclomatic complexity: max 15 (warning), 25 (error)

### Code Organization

```swift
// MARK: - Type Definition
class MyClass {
    // MARK: - Properties
    private let dependency: Dependency
    
    // MARK: - Initialization
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Public Methods
    func publicMethod() {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func privateMethod() {
        // Implementation
    }
}

// MARK: - Protocol Conformance
extension MyClass: SomeProtocol {
    func protocolMethod() {
        // Implementation
    }
}
```

### Documentation

- Document all public APIs with doc comments
- Use `///` for documentation comments
- Include parameter descriptions and return values
- Add code examples for complex functionality

```swift
/// Connects to an SSH server with the specified configuration
///
/// - Parameter config: SSH connection configuration including host, port, and credentials
/// - Throws: `SSHClientError` if connection fails
/// - Returns: A connected SSH client instance
func connect(config: SSHConnectionConfig) async throws -> SSHClient {
    // Implementation
}
```

## 🧪 Testing Guidelines

### Test Coverage

- All new features must include unit tests
- UI changes should include UI tests
- Aim for >80% code coverage
- Test edge cases and error conditions

### Test Structure

```swift
// Arrange-Act-Assert pattern
func testFeatureName() async throws {
    // Given: Setup test conditions
    let sut = SystemUnderTest()
    
    // When: Perform action
    let result = try await sut.performAction()
    
    // Then: Verify results
    XCTAssertEqual(result, expectedValue)
}
```

### Running Tests

```bash
# All tests
bundle exec fastlane test

# Unit tests only
xcodebuild test -workspace OnyxTerminal.xcworkspace -scheme OnyxTerminal -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:OnyxTerminalTests

# UI tests only
xcodebuild test -workspace OnyxTerminal.xcworkspace -scheme OnyxTerminal -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:OnyxTerminalUITests
```

## 📝 Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, missing semicolons, etc.)
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Build process or auxiliary tool changes
- `ci:` - CI/CD changes

### Scopes (optional)

- `ssh` - SSH client
- `sftp` - SFTP client
- `ui` - User interface
- `security` - Security features
- `terminal` - Terminal emulation
- `tests` - Testing infrastructure
- `ci` - Continuous integration

### Examples

```bash
# Feature
git commit -m "feat(ssh): add host key verification"

# Bug fix
git commit -m "fix(sftp): handle file upload errors correctly"

# Documentation
git commit -m "docs: update contributing guidelines"

# Breaking change
git commit -m "feat(ssh)!: change authentication API

BREAKING CHANGE: authenticate() now requires async/await"
```

### Commit Message Rules

- Use imperative mood ("add feature" not "added feature")
- First line should be 50 characters or less
- Reference issue numbers in footer (e.g., "Fixes #123")
- Use body to explain what and why, not how

## 🔍 Pull Request Process

### Before Submitting

1. ✅ Code passes all linter checks
2. ✅ All tests pass
3. ✅ Code coverage is maintained or improved
4. ✅ Documentation is updated
5. ✅ Commit messages follow conventions
6. ✅ Branch is up to date with develop

### PR Checklist

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] UI tests added/updated (if applicable)
- [ ] All tests passing
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Passes all CI checks
```

### PR Review Process

1. Create PR targeting `develop` branch
2. Fill in PR template completely
3. Ensure CI checks pass
4. Request review from maintainers
5. Address review feedback
6. Wait for approval from at least one maintainer
7. Maintainer will merge when ready

### PR Guidelines

- Keep PRs focused on a single feature or fix
- Limit PR size (ideally <500 lines of code)
- Write clear PR description
- Link related issues
- Respond to review comments promptly
- Don't force push after review has started (use additional commits)

## 🚢 Release Process

Releases are managed by maintainers following semantic versioning.

### Version Numbering

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Steps (Maintainers)

1. Create release branch from develop
2. Update version number
3. Update CHANGELOG.md
4. Create PR to main
5. After merge, tag release
6. Deploy to TestFlight
7. Merge main back to develop

## 🐛 Reporting Bugs

### Bug Report Template

When reporting bugs, include:

1. **Description**: Clear and concise description
2. **Steps to Reproduce**: Numbered steps to reproduce the issue
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Environment**:
   - iOS version
   - Device model
   - App version
6. **Screenshots**: If applicable
7. **Logs**: Relevant error messages or logs

## 💡 Feature Requests

### Feature Request Template

When requesting features, include:

1. **Problem**: What problem does this solve?
2. **Proposed Solution**: Your suggested solution
3. **Alternatives**: Alternative solutions considered
4. **Additional Context**: Any other relevant information

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Documentation**: Check the Wiki for detailed guides

## 🙏 Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project README

Thank you for contributing to Onyx Terminal! 🎉
