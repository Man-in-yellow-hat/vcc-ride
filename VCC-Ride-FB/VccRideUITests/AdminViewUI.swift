//
//  AdminPeopleViewUI.swift
//  VccRideUITests
//
//  Created by Karen Pu on 11/18/23.
//


import XCTest

final class AdminViewUI: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    
    func testAdminPage() throws {
        sleep(2)
        
        let remindButton = app.buttons["Send Practice Reminder"]
        XCTAssertTrue(remindButton.exists, "Send Practice Reminder does not exist.")
        
        // test people view page
        let peopleView = app.tabBars.buttons["People"]
        XCTAssertTrue(peopleView.exists, "People view did not appear after tapping Calendar button.")
        peopleView.tap()
        
        let roleButton = app.buttons["Filter by Role, Any"]
        XCTAssertTrue(roleButton.exists, "Role filter exists.")
        
        let locationButton = app.buttons["Filter by Location, Any"]
        XCTAssertTrue(locationButton.exists, "Location filter doesn't exists.")
        
        let statusButton = app.buttons["Filter by Status, Any"]
        XCTAssertTrue(roleButton.exists, "Status filter exists.")
        
        statusButton.tap()
        let activeButton = app.buttons["Active"]
        XCTAssertTrue(activeButton.exists, "Rider button exists.")
        activeButton.tap()
        
        let searchBar = app.searchFields["Search by email"]
        XCTAssertTrue(searchBar.exists, "search bar doesn't exists.")
        searchBar.tap()
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "search bar doesn't exists.")
        cancelButton.tap()
        
        let clearFilterButton = app.buttons["Clear Filters"]
        XCTAssertTrue(clearFilterButton.exists, "Clear Filters doesn't exist.")
        
        // testing calendar view page
        let calendarView = app.tabBars.buttons["Calendar"]
        XCTAssertTrue(calendarView.exists, "Calendar view did not appear after tapping Calendar button.")
        calendarView.tap()
        
        let addPractice = app.buttons["Add Practice Date"]
        XCTAssertTrue(addPractice.exists, "Calendar view did not appear after tapping Calendar button.")
        addPractice.tap()
        
        let cancelPractice = app.buttons["Cancel"]
        XCTAssertTrue(cancelPractice.exists, "Calendar view did not appear after tapping Calendar button.")
        
        let donePractice = app.buttons["Done"]
        XCTAssertTrue(donePractice.exists, "Calendar view did not appear after tapping Calendar button.")
        // test stats page
        let statsView = app.tabBars.buttons["Stats"]
        XCTAssertTrue(statsView.exists, "Stats view did not appear after tapping Calendar button.")
        statsView.tap()
        
    }
    
    func testDriverListPage() throws {
        sleep(2)
        
        let driversNextPractice = app.staticTexts["North Drivers"]
        app.swipeLeft()
        // Check if the driver list page is now present
        XCTAssertTrue(driversNextPractice.exists, "The specific text should exist.")
    }
        
    func testSettingsPage() throws {
        sleep(2)
        // test settings view page
        let settingsView = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsView.exists, "Settings view did not appear after tapping Calendar button.")
        settingsView.tap()
        
        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists, "First Name TextField does not exist")
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists, "Last Name TextField does not exist")
        
        let autoAttendance = app.switches["Automatic Attendance Confirmation"]
        XCTAssertTrue(autoAttendance.exists, "Automatic attendance does not exist.")
        
        let stepperIncrementButton = app.buttons["Increment"]
        XCTAssertTrue(stepperIncrementButton.exists, "Automatic attendance does not exist.")
        
        let signoutButton = app.buttons["Sign Out"]
        XCTAssertTrue(signoutButton.exists, "sign out button does not exist.")
        
        let deleteButton = app.buttons["Delete Account"]
        XCTAssertTrue(deleteButton.exists, "delete button does not exist.")
        
        let selectPracticeButton = app.buttons["Select Practice Date Attendance"]
        XCTAssertTrue(selectPracticeButton.exists, "save preferences button does not exist.")
        selectPracticeButton.tap()
        
        let dateToggle = app.switches["Oct10"]
        XCTAssertTrue(dateToggle.exists, "Toggle for date exists.")
        let toggleOn = dateToggle.value as! String == "1"
        dateToggle.tap()
        let toggleOnAfterTap = dateToggle.value as! String == "0"
        XCTAssertNotEqual(toggleOn, toggleOnAfterTap, "Toggle state did not change after tap")
        
        let savePrefButton = app.buttons["Save Preferences"]
        XCTAssertTrue(savePrefButton.exists, "save preferences button does not exist.")
    }
    
    func testDriverPage() throws {
        app.swipeRight()
        
        let fillAttendanceButton = app.buttons["Fill Attendance Form"]
        XCTAssertTrue(fillAttendanceButton.exists, "Fill Attendance doesn't exist")
        fillAttendanceButton.tap()
        
        let notComingButton = app.buttons["I am not coming :("]
        XCTAssertTrue(notComingButton.exists, "Not coming doesn't exist")
        notComingButton.tap()
        
        sleep(5)
        
        let changeMindButton = app.buttons["Want to change your mind?"]
        XCTAssertTrue(changeMindButton.exists, "Change mind doesn't exist")
        changeMindButton.tap()
        
        let comingButton = app.buttons["I am coming!"]
        XCTAssertTrue(comingButton.exists, "Coming button doesn't exist")
        comingButton.tap()
        
        let startingValue = 1 // Replace with the actual starting value
        let maximumValue = 5
        
        let stepperIncrementButton = app.buttons["Increment"]
        XCTAssertTrue(stepperIncrementButton.exists, "Stepper increment button does not exist")
        
        // check maximum increments
        for _ in startingValue..<maximumValue {
            stepperIncrementButton.tap()
        }
        
        let randButton = app.buttons["Rand"]
        XCTAssertTrue(randButton.exists, "Rand does not exist")
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "cancel does not exist")
        
        let confirmButton = app.buttons["Confirm"]
        XCTAssertTrue(confirmButton.exists, "confirm does not exist")
        confirmButton.tap()
        
        let clearButton = app.buttons["clear"]
        XCTAssertTrue(clearButton.exists, "Clear button should exist")
        
        let seatIcons = app.images.matching(identifier: "person.fill").count + app.images.matching(identifier: "person").count
        XCTAssertEqual(seatIcons, 5, "There should be 4 seat icons")
    }
    
    func testAssignDriver() throws {
        sleep(2)
        
        let assignButton = app.buttons["Assign Drivers"]
        XCTAssertTrue(assignButton.exists, "Assign drivers does not exist.")
        assignButton.tap()
        
        sleep(3)
        
        let downButtons = app.buttons["down arrow"]
        XCTAssertTrue(downButtons.exists, "Down arrow for North does not exist.")
        
        let randButtons = app.buttons["rand arrow"]
        XCTAssertTrue(randButtons.exists, "Down arrow for Rand does not exist.")
    }
    
}
