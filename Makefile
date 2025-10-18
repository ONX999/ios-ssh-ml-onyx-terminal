.PHONY: help setup generate clean build test lint format

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Install development dependencies
	@echo "Installing dependencies..."
	@command -v xcodegen >/dev/null 2>&1 || brew install xcodegen
	@command -v swiftlint >/dev/null 2>&1 || brew install swiftlint
	@gem install bundler || true
	@bundle install
	@echo "Setup complete!"

generate: ## Generate Xcode project from project.yml
	@echo "Generating Xcode project..."
	@xcodegen generate
	@echo "Project generated! Open OnyxTerminal.xcodeproj"

clean: ## Clean build artifacts
	@echo "Cleaning..."
	@rm -rf build/
	@rm -rf DerivedData/
	@rm -rf .build/
	@rm -rf *.xcodeproj
	@echo "Clean complete!"

build: generate ## Build the project
	@echo "Building..."
	@xcodebuild -project OnyxTerminal.xcodeproj \
		-scheme OnyxTerminal \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		-configuration Debug \
		clean build \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO

test: generate ## Run tests
	@echo "Running tests..."
	@xcodebuild test \
		-project OnyxTerminal.xcodeproj \
		-scheme OnyxTerminal \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		-enableCodeCoverage YES \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO

lint: ## Run SwiftLint
	@echo "Running SwiftLint..."
	@swiftlint lint

format: ## Auto-fix SwiftLint issues
	@echo "Auto-fixing SwiftLint issues..."
	@swiftlint --fix

fastlane-lint: ## Run lint via Fastlane
	@bundle exec fastlane lint

fastlane-test: ## Run tests via Fastlane
	@bundle exec fastlane test

fastlane-build: ## Build via Fastlane
	@bundle exec fastlane build_debug
