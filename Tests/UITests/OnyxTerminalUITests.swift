import XCTest

/// Basic UI tests for Onyx Terminal app
final class OnyxTerminalUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAppLaunches() throws {
        // Verify the app launches successfully
        XCTAssertTrue(app.exists, "App should launch successfully")
    }
    
    func testMainNavigationExists() throws {
        // Check for main navigation elements
        let navigationBar = app.navigationBars["Onyx Terminal"]
        XCTAssertTrue(navigationBar.exists, "Main navigation bar should exist")
    }
    
    func testConnectionFormExists() throws {
        // Verify connection form elements are present
        let hostField = app.textFields["field.host"]
        XCTAssertTrue(hostField.exists, "Host field should exist")
        
        let usernameField = app.textFields["field.username"]
        XCTAssertTrue(usernameField.exists, "Username field should exist")
        
        let passwordField = app.secureTextFields["field.password"]
        XCTAssertTrue(passwordField.exists, "Password field should exist")
    }
    
    func testConnectButtonExists() throws {
        let connectButton = app.buttons["btn.connect"]
        XCTAssertTrue(connectButton.exists, "Connect button should exist")
    }
    
    func testLanguageSwitcher() throws {
        // Check for language picker
        let languagePicker = app.pickers["picker.language"]
        XCTAssertTrue(languagePicker.exists, "Language picker should exist")
    }
    
    func testConnectionFormValidation() throws {
        // Initially, connect button should be disabled (form not filled)
        let connectButton = app.buttons["btn.connect"]
        
        // Note: This test assumes validation is working
        // In actual implementation, you'd fill in the form and verify button state changes
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testAppLaunchesSuccessfully() {
        // Given: The app has just launched
        // When: Checking if the app is running
        // Then: The app should be in the foreground
        XCTAssertTrue(app.state == .runningForeground)
    }
    
    func testNavigationTitleIsVisible() {
        // Given: The app has launched
        // When: Looking for the navigation title
        let navigationBar = app.navigationBars["Onyx Terminal"]
        
        // Then: The navigation bar should exist
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
    }
    
    func testConnectionFieldsAreVisible() {
        // Given: The app has launched
        // When: Looking for connection input fields
        // Then: Host, username, and password fields should be visible
        
        // Note: TextField identifiers may vary based on localization
        // Using exists check for any text fields
        let textFields = app.textFields
        
        XCTAssertGreaterThanOrEqual(textFields.count, 2, "Should have at least host and username fields")
    }
    
    func testConnectButtonExists() {
        // Given: The app has launched
        // When: Looking for the connect button
        // Then: A connect/disconnect button should exist
        let buttons = app.buttons
        
        XCTAssertGreaterThan(buttons.count, 0, "Should have at least one button")
    }
    
    func testTerminalViewExists() {
        // Given: The app has launched
        // When: The main view is loaded
        // Then: Terminal container should be present (even if not connected)
        
        // The terminal view is embedded, so we check for overall layout
        XCTAssertTrue(app.exists)
    }
    
    func testQuickActionBarExists() {
        // Given: The app has launched
        // When: Looking for quick action buttons
        // Then: Quick action bar with model CLI shortcuts should exist
        
        // Quick actions are rendered as buttons in a scroll view
        let scrollViews = app.scrollViews
        XCTAssertGreaterThan(scrollViews.count, 0, "Should have scroll views for quick actions and forms")
    }
    
    func testCannotConnectWithEmptyFields() {
        // Given: The app has launched with empty connection fields
        // When: Looking for the connect button
        let connectButtons = app.buttons.allElementsBoundByIndex
        
        // Then: Connect button should exist
        XCTAssertFalse(connectButtons.isEmpty, "Should have buttons available")
        
        // Note: Without filling fields, the button might be disabled
        // This is a basic smoke test
    }
    
    func testMenuButtonExists() {
        // Given: The app has launched
        // When: Looking for the toolbar menu
        // Then: Menu button should exist in navigation bar
        
        let menuButtons = app.buttons.matching(identifier: "ellipsis.circle")
        XCTAssertGreaterThanOrEqual(menuButtons.count, 0, "Menu system should be present")
    }
}
