#!/bin/bash

# Script to verify project structure is correct

echo "🔍 Checking Onyx Terminal Project Structure..."
echo ""

errors=0
warnings=0

# Check required directories
echo "📁 Checking directories..."
directories=(
    "Sources/App"
    "Sources/App/Features/SSH"
    "Sources/App/Features/SFTP"
    "Sources/App/Features/TerminalUI"
    "Sources/App/Core/Networking"
    "Sources/App/Core/Security"
    "Sources/App/Core/Storage"
    "Sources/App/Core/DesignSystem"
    "Tests/Unit"
    "Tests/UITests"
    "fastlane"
    ".github/workflows"
)

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir"
    else
        echo "  ❌ $dir (missing)"
        ((errors++))
    fi
done

echo ""
echo "📄 Checking required files..."
files=(
    "project.yml"
    ".gitignore"
    ".swiftlint.yml"
    "README.md"
    "CONTRIBUTING.md"
    "LICENSE"
    "Gemfile"
    "Makefile"
    "fastlane/Fastfile"
    "fastlane/Appfile"
    ".github/workflows/ci.yml"
    "Sources/App/Info.plist"
    "Sources/App/TerminalCLIApp.swift"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        ((errors++))
    fi
done

echo ""
echo "🧪 Checking test files..."
test_files=(
    "Tests/Unit/SSHClientTests.swift"
    "Tests/Unit/SFTPClientTests.swift"
    "Tests/UITests/OnyxTerminalUITests.swift"
)

for file in "${test_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ⚠️  $file (missing)"
        ((warnings++))
    fi
done

echo ""
echo "🌍 Checking localization files..."
loc_files=(
    "Sources/App/Resources/en.lproj/Localizable.strings"
    "Sources/App/Resources/zh-Hant.lproj/Localizable.strings"
)

for file in "${loc_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        ((errors++))
    fi
done

echo ""
echo "📊 Summary:"
echo "  Errors: $errors"
echo "  Warnings: $warnings"
echo ""

if [ $errors -eq 0 ]; then
    echo "✅ Project structure is valid!"
    exit 0
else
    echo "❌ Project structure has errors. Please fix them."
    exit 1
fi
