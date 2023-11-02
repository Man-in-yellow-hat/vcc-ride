//
//  OrganizeDrivers.swift
//  VccRide
//
//  Created by Nathan King on 10/10/23.
//

import Foundation
import FirebaseDatabase

// Function to retrieve daily practice data
func retrieveDailyPracticeData(forDate date: String, completion: @escaping ([String: Any]?) -> Void) {
    let databaseRef = Database.database().reference()
    let dailyPracticeRef = databaseRef.child("daily_practice").child(date)

    dailyPracticeRef.observeSingleEvent(of: .value) { snapshot in
        guard let dailyPracticeData = snapshot.value as? [String: Any] else {
            completion(nil)
            return
        }
        completion(dailyPracticeData)
    }
}

func processDailyPracticeData(data: [String: Any]) {
    // Extract data for north drivers, north riders, and rand riders
    if let northDrivers = data["north_drivers"] as? [String: [String: Any]],
       let northRiders = data["north_riders"] as? [String: Int],
       let randRiders = data["rand_riders"] as? [String: Int] {
       
        // Process north drivers and calculate available seats
        var availableSeats = 0
        for (_, driverData) in northDrivers {
            if let filledSeats = driverData["filled_seats"] as? Int,
               let totalSeats = driverData["total_seats"] as? Int {
                availableSeats += (totalSeats - filledSeats)
            }
        }

        // Calculate the difference between riders and available seats
        let diffNorth = availableSeats - northRiders.values.reduce(0, +)
        let diffRand = randRiders.values.reduce(0, +)

        // Implement your assignment logic here, similar to your Python script
        // ...
        
        // Print the results
        print("North Difference: \(diffNorth)")
        print("Rand Difference: \(diffRand)")
    }
}
