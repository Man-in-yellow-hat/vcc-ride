////
////  AdminPeopleViewTests.swift
////  VccRideTests
////
////  Created by Aman Momin on 11/14/23.
////
//
//import XCTest
//import SwiftUI
//@testable import VccRide
//
//class AdminPeopleViewTests: XCTestCase {
//    var adminPeopleView: AdminPeopleView!
//
//    override func setUp() {
//        super.setUp()
//        adminPeopleView = AdminPeopleView()
//    }
//
//    override func tearDown() {
//        adminPeopleView = nil
//        super.tearDown()
//    }
//
//    func testAdminPeopleView_InitialState() {
//        let filteredUsers = adminPeopleView.$filteredUsers
//        let isEditUserViewPresented = adminPeopleView.$isEditUserViewPresented
//
//        // Check initial state
//        XCTAssertEqual(filteredUsers.wrappedValue.count, 0)
//        XCTAssertFalse(isEditUserViewPresented.wrappedValue)
//    }
//
//    func testAdminPeopleView_ApplyFilters() {
//        adminPeopleView.selectedRole = "admin"
//        adminPeopleView.isActive = "true"
//        adminPeopleView.selectedLocation = "North"
//
//        adminPeopleView.applyFilters()
//
//        let filteredUsers = adminPeopleView.$filteredUsers
//
//        // Check if filters are applied correctly
//        XCTAssertTrue(filteredUsers.wrappedValue.count > 0)
//        XCTAssertTrue(filteredUsers.wrappedValue.allSatisfy { (_, userData) in
//            let roleMatches = adminPeopleView.selectedRole == "Any" || userData["role"] as? String == adminPeopleView.selectedRole
//            let activeMatches = adminPeopleView.isActive == "Any" || (userData["active"] as? Bool ?? false) == (adminPeopleView.isActive == "true")
//            let locationMatches = adminPeopleView.selectedLocation == "Any" || userData["default_location"] as? String == adminPeopleView.selectedLocation
//
//            return roleMatches && activeMatches && locationMatches
//        })
//    }
//
//    func testAdminPeopleView_ClearFilters() {
//        adminPeopleView.selectedRole = "admin"
//        adminPeopleView.isActive = "true"
//        adminPeopleView.selectedLocation = "North"
//
//        adminPeopleView.clearFilters()
//
//        let filteredUsers = adminPeopleView.$filteredUsers
//
//        // Check if filters are cleared correctly
//        XCTAssertEqual(adminPeopleView.selectedRole, "Any")
//        XCTAssertEqual(adminPeopleView.isActive, "Any")
//        XCTAssertEqual(adminPeopleView.selectedLocation, "Any")
//        XCTAssertEqual(filteredUsers.wrappedValue.count, 0)
//    }
//
//    func testAdminPeopleView_SearchByEmail() {
//        // Simulate entering a search string in the search bar
//        adminPeopleView.searchString = "test@example.com"
//
//        adminPeopleView.applyFilters()
//
//        let filteredUsers = adminPeopleView.$filteredUsers
//
//        // Check if the list is correctly filtered based on email search
//        XCTAssertTrue(filteredUsers.wrappedValue.count == 1)
//        XCTAssertTrue(filteredUsers.wrappedValue.contains { (_, userData) in
//            return (userData["email"] as? String ?? "") == "test@example.com"
//        })
//    }
//
//    func testAdminPeopleView_EditUserViewPresentation() {
//        // Simulate tapping on a user in the list
//        adminPeopleView.selectedUserID = "testUserID"
//        adminPeopleView.selectedUserData = ["email": "test@example.com", "role": "admin"]
//        adminPeopleView.isEditUserViewPresented = true
//
//        XCTAssertTrue(adminPeopleView.isEditUserViewPresented)
//    }
//
//    func testAdminPeopleView_ClearFiltersButton() {
//        // Simulate tapping the "Clear Filters" button
//        adminPeopleView.clearFilters()
//
//        XCTAssertEqual(adminPeopleView.selectedRole, "Any")
//        XCTAssertEqual(adminPeopleView.isActive, "Any")
//        XCTAssertEqual(adminPeopleView.selectedLocation, "Any")
//    }
//
//}
//
//class EditUserViewTests: XCTestCase {
//    var editUserView: EditUserView!
//
//    override func setUp() {
//        super.setUp()
//        editUserView = EditUserView(userID: .constant("testUserID"), userData: .constant(["email": "test@example.com", "role": "admin"]))
//    }
//
//    override func tearDown() {
//        editUserView = nil
//        super.tearDown()
//    }
//
//    func testEditUserView_InitialState() {
//        let emailTextField = try? editUserView.inspect().text().get()
//        let rolePicker = try? editUserView.inspect().picker("Select Role").get()
//        let activeToggle = try? editUserView.inspect().toggle("Active").get()
//        let locationPicker = try? editUserView.inspect().picker("Select Location").get()
//        let seatsStepper = try? editUserView.inspect().stepper("Seats: 4").get()
//
//        // Check initial state
//        XCTAssertEqual(emailTextField?.string, "Email: test@example.com")
//        XCTAssertEqual(rolePicker?.string, "Rider")
//        XCTAssertEqual(activeToggle?.isOn, false)
//        XCTAssertEqual(locationPicker?.string, "North")
//        XCTAssertEqual(seatsStepper?.value, 4)
//    }
//
//    func testEditUserView_RoleChangeConfirmation() {
//        // Simulate changing the role to "admin" and check if confirmation is required
//        editUserView.role = "admin"
//        XCTAssertTrue(editUserView.confirmRoleChange)
//    }
//
//    func testEditUserView_RoleChangeCancellation() {
//        // Simulate changing the role without requiring confirmation
//        editUserView.role = "rider"
//        XCTAssertFalse(editUserView.confirmRoleChange)
//    }
//
//    func testEditUserView_SaveUserData() {
//        // Simulate changing various user data fields and saving
//        editUserView.role = "driver"
//        editUserView.active = true
//        editUserView.defaultLocation = "Rand"
//        editUserView.seats = 6
//
//        // Simulate tapping the "Save" button
//        editUserView.onSaveButtonTapped()
//
//        // Verify that the changes are reflected
//        XCTAssertEqual(editUserView.userData["role"] as? String, "driver")
//        XCTAssertTrue(editUserView.userData["active"] as? Bool ?? false)
//        XCTAssertEqual(editUserView.userData["default_location"] as? String, "Rand")
//        XCTAssertEqual(editUserView.userData["default_seats"] as? Int, 6)
//    }
//
//}
//
