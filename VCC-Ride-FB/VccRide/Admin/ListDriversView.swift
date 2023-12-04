//
//  ListDriversView.swift
//  VccRide
//
//  Created by Nathan King on 11/2/23.
//

import SwiftUI

struct ListDriversView: View {
    @ObservedObject var dailyViewModel = DailyViewModel.shared
    @State private var isLoading = true // Add a state variable
    
    var body: some View {
        VStack {
            Text("Drivers List")
                .font(.title)
                .padding()
            
            if !isLoading {
                List {
                    Section(header: Text("NORTH Drivers").foregroundColor(.green)) {
                        ForEach(Array(dailyViewModel.filterDrivers(locationFilter: "north", careDeparted: true, isDepartedFilter: false)), id: \.key) { (userID, userData) in
                            HStack {
                                Text(userData["name"] as? String ?? "Unknown Name")
                                Spacer()
                                Text("\(userData["seats"] as? Int ?? 0) Seats")
                                Spacer()
                                Button(action: {
                                    dailyViewModel.moveUser(userID: userID, to: "rand")
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("RAND Drivers").foregroundColor(.blue)) {
                        ForEach(Array(dailyViewModel.filterDrivers(locationFilter: "rand", careDeparted: true, isDepartedFilter: false)), id: \.key) { (userID, userData) in
                            HStack {
                                Text(userData["name"] as? String ?? "Unknown Name")
                                Spacer()
                                Text("\(userData["seats"] as? Int ?? 0) Seats")
                                Spacer()
                                Button(action: {
                                    dailyViewModel.moveUser(userID: userID, to: "north")
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                }
                            }
                        }
                    }
                }
            } else {
                // Loading view
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.8)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemGray)))
                        .scaleEffect(2)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isLoading = false
            }
        }
        .onDisappear {
            dailyViewModel.adjustSeats()
        }
    }
}

struct ListDriversView_Previews: PreviewProvider {
    static var previews: some View {
        ListDriversView()
    }
}
