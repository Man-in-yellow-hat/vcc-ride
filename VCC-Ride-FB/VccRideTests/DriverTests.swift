//import XCTest
//@testable import VccRide
//
//class DriverTests: XCTestCase {
//    
//    var driver: Driver!
//
//    override func setUp() {
//        super.setUp()
//        // Initialize a Driver object before each test
//        driver = Driver(id: "123", name: "John Doe", location: "NORTH", seats: 4, preference: "SOUTH")
//    }
//
//    override func tearDown() {
//        // Clean up after each test
//        driver = nil
//        super.tearDown()
//    }
//
//    func testToggleSeat() {
//        // Test toggling a seat
//        XCTAssertEqual(driver.filledSeats, 0, "Initial filled seats should be 0")
//        driver.toggleSeat(at: 0)
//        XCTAssertEqual(driver.filledSeats, 1, "Filled seats should be 1 after toggling")
//        driver.toggleSeat(at: 0)
//        XCTAssertEqual(driver.filledSeats, 0, "Filled seats should be 0 after toggling again")
//    }
//
//    func testIsSeatFilled() {
//        // Test isSeatFilled method
//        XCTAssertFalse(driver.isSeatFilled(at: 0), "Seat should not be filled initially")
//        driver.toggleSeat(at: 0)
//        XCTAssertTrue(driver.isSeatFilled(at: 0), "Seat should be filled after toggling")
//    }
//
//    func testFilledSeatCounts() {
//        // Test filledSeatCounts method
//        XCTAssertEqual(driver.filledSeatCounts(), 0, "Initial filled seat count should be 0")
//        driver.toggleSeat(at: 0)
//        XCTAssertEqual(driver.filledSeatCounts(), 1, "Filled seat count should be 1 after toggling a seat")
//    }
//
//    func testIsFull() {
//        // Test isFull method
//        XCTAssertFalse(driver.isFull(), "Driver should not be full initially")
//        for i in 0..<driver.seats {
//            driver.toggleSeat(at: i)
//        }
//        XCTAssertTrue(driver.isFull(), "Driver should be full when all seats are toggled")
//    }
//}
