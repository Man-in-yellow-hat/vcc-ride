//
//  DriverFormView.swift
//  VccRide
//
//  Created by Nathan King on 11/30/23.
//

import SwiftUI
import Firebase

struct DriverFormView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @ObservedObject private var userViewModel = UserViewModel()

    @State private var isAttending = false
    @State private var responded = false
    @State private var changeMindOption = false
    @State private var numPassengers = 4
    @State private var pickupLocation = "north"
    @State private var navigating = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if (navigating) {
            LoadDriverView()
        }
        VStack {
            if (!responded) {
                Text("You are currently marked as not attending today. If you would like to drive today, fill out the form below!")
                Button(action: {
//                    handleNotComing()
                    print("not coming")
                    responded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        changeMindOption = true
                    }
                }) {
                    Text("I am not coming :(")
                        .padding()
                }
                .background(Color(UIColor.systemGray5))
                .cornerRadius(10)
                
                Button(action: {
                    responded = true
                    isAttending = true
                }) {
                    Text("I am coming!")
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.green)
                .cornerRadius(10)
            } else {
                if (isAttending) {
                    Text("Please fill out the form to attend.")
                    
                    // Customize this view based on your requirements
                    Stepper(value: $numPassengers, in: 1...5, label: {
                        Text("Number of passengers: \(numPassengers)")
                    })
                    
                    Picker("Pickup Location", selection: $pickupLocation) {
                        Text("North").tag("north")
                        Text("Rand").tag("rand")
                        // Add other location options as needed
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Button(action: {
                            responded = false
                        }) {
                            Text("Cancel")
                                .padding()
                        }
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                        
                        Button(action: {
                            handleComing() {navigating = true}
                        }) {
                            Text("Confirm")
                                .padding()
                        }
                        .background(.green)
                        .cornerRadius(10)
                    }
                    
                    
                

                } else {
                    Text("You have been marked as not attending.")
                    if (changeMindOption) {
                        Button(action: {
                            responded = false
                        }) {
                            Text("Want to change your mind?")
                                .padding()
                        }
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
    
    
    func handleNotComing() {
        // TODO: Handle logic
        
        print("nah not today")
//        dailyViewModel.updateFilledSeats(forLocation: pickupLocation, change: 1)
        // Go to the NextPracticeScreen or implement your navigation logic
    }
    
    func handleComing(completion: @escaping () -> Void) {
        print("coming!")
        
        // TODO: update seats? or will it automatically

        let userID = userViewModel.userID

        // Prepare the driver data
        let driverData: [String: Any] = [
            "filled_seats": 0,
            "isDeparted": false,
            "location": pickupLocation,
            "name": userViewModel.userName,
            "preference": pickupLocation,
            "seats": numPassengers
        ]

        // Reference to the Daily-Practice/drivers location in the Realtime Database
        let driversRef = Database.database().reference().child("Daily-Practice").child("drivers")

        // Set the driver data under the user's ID
        driversRef.child(userID).setValue(driverData) { error, _ in
            if let error = error {
                // Handle the error
                print("Error adding driver to database:", error)
            } else {
                // Call the completion closure when the operation is done
                completion()
            }
        }
    }
}


#Preview {
    DriverFormView()
}


