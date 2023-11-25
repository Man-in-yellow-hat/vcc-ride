////
////  DashboardTests.swift
////  VccRideTests
////
////  Created by Aman Momin on 11/14/23.
////
//
//import XCTest
//@testable import VccRide
//
//final class VccRideTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        let app = XCUIApplication()
//        app.launch()
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    /*
//    func testLoginScreen() throws {
//        let app = XCUIApplication()
//        guard app.staticTexts["Sign In with Google"].exists else {
//            XCTFail()
//            return
//        }
//    }
//     */
//
//    func testDashboard() throws {
//        let app = XCUIApplication()
//
//        app.navigationBars.buttons["DASHBOARD"].tap()
//
//        //check if button exists
//        XCTAssert(app.buttons["Assign Drivers"].exists)
//
//        XCTAssert(app.buttons["Send Practice Reminder"].exists)
//
//        XCTAssert(app.buttons["Confirm Attendance"].exists)
//
//        XCTAssert(app.buttons["Update Daily Practice"].exists)
//
//        //check if box (image) exists
//        XCTAssert(app.images["person.3.sequence.fill"].exists)
//
//        XCTAssert(app.images["chair.lounge.fill"].exists)
//
//        XCTAssert(app.images["figure.seated.seatbelt"].exists)
//    }
//
//    func testAssignDriver() throws {
//        let app = XCUIApplication()
//
//        //Move to assign driver view
//        app.buttons["Assign Drivers"].tap()
//
//        //Wait for view to open
//        sleep(3)
//
//        //Check whether driver view has shown up
//        XCTAssert(app.staticTexts["Drivers List"].exists)
//        XCTAssert(app.staticTexts["NORTH Drivers"].exists)
//        XCTAssert(app.staticTexts["RAND Drivers"].exists)
//
//        //Check close by swipe down
//        app.swipeDown()
//
//        //Wait for view to close
//        sleep(3)
//
//        XCTAssertFalse(app.staticTexts["Drivers List"].exists)
//    }
//
//    func testAdminCalendar() throws {
//        let app = XCUIApplication()
//
//        //Move to Calendar view page
//        app.navigationBars.buttons["Calendar"].tap()
//
//        //Check whether view moved to Calendar page
//        XCTAssert(app.navigationBars["Practice Dates"].exists)
//
//        //Check add Practice Date Button
//        XCTAssert(app.buttons["Add Practice Date"].exists)
//        app.buttons["Add Practice Date"].tap()
//
//        //Wait for datepicker control to show up
//        sleep(3)
//
//        //Check if datepicker control exists
//        XCTAssert(app.datePickers.element.exists)
//
//        //Close datepicker control
//        app.datePickers.element.buttons["Cancel"].tap()
//
//        //Wait for datepicker control to dismiss
//        sleep(3)
//
//        //Check if datepicker control has dismissed
//        XCTAssertFalse(app.datePickers.element.exists)
//
//
//    }
//
//    /*
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//     */
//
//
//}
