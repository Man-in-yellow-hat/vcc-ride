//
//  ListDriversView.swift
//  VccRide
//
//  Created by Nathan King on 11/2/23.
//

import SwiftUI

struct ListDriversView: View {
//    @Binding var selectedDriver: Driver?
//    let assignmentAction: (Driver, String) -> Void

    @ObservedObject var dailyViewModel = DailyViewModel.shared
    @State private var isLoading = true // Add a state variable

    
    var body: some View {
        VStack {
            Text("Drivers List")
                .font(.title)
                .padding()
            
            if (!isLoading) {
                List {
                    Section(header: Text("NORTH Drivers").foregroundColor(.green)) {
                        ForEach(dailyViewModel.northDrivers) { driver in
                            HStack {
                                Text(driver.name)
                                Spacer()
                                Text(String(driver.seats))
                                Spacer()
                                Text(driver.locationPreference)
                                Button(action: {
                                    dailyViewModel.moveDriver(dbChild: "Daily-Practice", driver: driver,
                                                              fromList: "north_drivers", toList: "rand_drivers")
                                    dailyViewModel.northDrivers.removeAll(where: { $0.id == driver.id })
                                    driver.location = "RAND"
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                }
                            }
                        }
                    }

                    Section(header: Text("RAND Drivers").foregroundColor(.blue)) {
                        ForEach(dailyViewModel.randDrivers) { driver in
                            HStack {
                                Text(driver.name)
                                Spacer()
                                Text(String(driver.seats))
                                Spacer()
                                Text(driver.locationPreference)
                                Button(action: {
                                    dailyViewModel.moveDriver(dbChild: "Daily-Practice", driver: driver,
                                                              fromList: "rand_drivers", toList: "north_drivers")
                                    dailyViewModel.randDrivers.removeAll(where: { $0.id == driver.id })
                                    driver.location = "NORTH"
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                }
                            }
                        }
                    }
                }
            } else {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.8)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .scaleEffect(2)
                }
                
            }
        }
        .onAppear {
            // When the view appears, call assignNoPref with a slight delay
            // to ensure that the data is updated before showing the updated view
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Adjust the delay as needed
                isLoading = false
            }
        }
    }
}



struct ListDriversView_Previews: PreviewProvider {
    static var previews: some View {
        ListDriversView()
    }
}
