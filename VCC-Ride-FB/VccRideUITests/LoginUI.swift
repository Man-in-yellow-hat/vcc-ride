//
//  LoginUI.swift
//  VccRideUITests
//
//  Created by Karen Pu on 12/4/23.
//

import XCTest

final class LoginUI: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    

    func testLoginScreen() throws {
        
        let settingsView = app.tabBars.buttons["Settings"]
        settingsView.tap()

        let signoutButton = app.buttons["Sign Out"]
        signoutButton.tap()

        sleep(3)

        let googleButton = app.buttons["Sign in with Google"]
        XCTAssertTrue(googleButton.exists, "sign in google button doesn't exist")

        let toggleButton = app.buttons["AppleVisibilityToggleButton"]
        XCTAssertTrue(toggleButton.exists, "The button to toggle Apple Sign-In visibility should exist")
        toggleButton.tap()

        let appleButton = app.buttons["Sign in with Apple"]
        XCTAssertTrue(appleButton.exists, "sign in apple button doesn't exist")
    }
    
}
