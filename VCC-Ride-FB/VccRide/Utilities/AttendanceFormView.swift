//
//  DriverFormView.swift
//  VccRide
//
//  Created by Nathan King on 11/30/23.
//

import SwiftUI
import Firebase

struct AttendanceFormView: View {
    @Binding var isSheetPresented: Bool
    
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @ObservedObject private var userViewModel = UserViewModel()

    @State private var isAttending = false
    @State private var responded = false
    @State private var changeMindOption = false
    @State private var seats = 4
    @State private var pickupLocation = "north"
    @State private var navigating = false
    
    var role: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if (!responded) {
                Text("You are currently marked as not attending today. If you would like to attend today, fill out the form below!")
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
                    
                    if (role == "driver") {
                        Stepper(value: $seats, in: 1...5, label: {
                            Text("Number of passengers: \(seats)")
                        })
                    }
                    
                    Picker("Pickup Location", selection: $pickupLocation) {
                        Text("North").tag("north")
                        Text("Rand").tag("rand")
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
                            handleComing() {isSheetPresented = false}
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
        .navigationTitle("Attendance Form")
        .navigationBarItems(trailing: Button("Dismiss") {
            isSheetPresented = false
        })
    }
    
    
    func handleNotComing() {
        // TODO: Handle logic
        
        print("nah not today")
        // Go to the NextPracticeScreen or implement your navigation logic
    }
    
    func handleComing(completion: @escaping () -> Void) {
        print("coming!")

        let userID = userViewModel.userID

        var setUserData: [String: Any]
        if role == "driver" {
            setUserData = [
                "filled_seats": 0,
                "name": userViewModel.userName,
                "preference": pickupLocation,
                "seats": seats,
                "isDeparted": false,
                "location": pickupLocation
            ]
        } else { // role == "rider"
            setUserData = [
                "in_car": false,
                "name": userViewModel.userName,
                "seats": 1,
                "location": pickupLocation
            ]
        }
        
        // Reference to the Daily-Practice/drivers location in the Realtime Database
        let userRef = Database.database().reference().child("Daily-Practice").child(role + "s")

        // Set the driver data under the user's ID
        userRef.child(userID).setValue(setUserData) { error, _ in
            if let error = error {
                // Handle the error
                print("Error adding user to database:", error)
            } else {
                // Call the completion closure when the operation is done
                completion()
            }
        }
    }
}

