//
//  DriverFormView.swift
//  VccRide
//
//  Created by Nathan King on 11/30/23.
//

import SwiftUI

struct DriverFormView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @ObservedObject private var userViewModel = UserViewModel()

    @State private var isAttending = false
    @State private var numPassengers = 0
    @State private var pickupLocation = ""
    
    var body: some View {
        VStack {
            Text("You are currently marked as not attending today. If you would like to drive today, fill out the form below!")
            Button(action: {
                handleNotComing()
            }) {
                Text("I am not coming :(")
            }
            
            Button(action: {
                isAttending = true
            }) {
                Text("I am coming!")
            }
            .sheet(isPresented: $isAttending, onDismiss: {
                // Perform actions when sheet is dismissed
                handleComing()
            }) {
                // Additional options for coming
                ComingOptionsView(numPassengers: $numPassengers, pickupLocation: $pickupLocation)
            }
        }
    }
    
    func handleNotComing() {
        // TODO: Handle logic
        print("nah not today")
//        dailyViewModel.updateFilledSeats(forLocation: pickupLocation, change: 1)
        // Go to the NextPracticeScreen or implement your navigation logic
    }
    
    func handleComing() {
        // TODO: Handle logic
        print("coming!")
    }
}

struct ComingOptionsView: View {
    @Binding var numPassengers: Int
    @Binding var pickupLocation: String
    
    var body: some View {
        // Additional options for coming
        VStack {
            // Customize this view based on your requirements
            Stepper(value: $numPassengers, in: 0...5, label: {
                Text("Number of passengers: \(numPassengers)")
            })
            
            Picker("Pickup Location", selection: $pickupLocation) {
                Text("North").tag("north")
                Text("Rand").tag("rand")
                // Add other location options as needed
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                // Additional actions for the coming options
            }) {
                Text("Confirm")
            }
        }
    }
}


#Preview {
    DriverFormView()
}


