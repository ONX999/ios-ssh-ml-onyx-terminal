import XCTest

final class OnyxTerminalUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
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
    }
}
