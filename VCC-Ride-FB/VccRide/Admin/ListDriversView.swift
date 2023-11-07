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
    @State private var shouldShowUpdatedView = false // Add a state variable

    
    var body: some View {
        VStack {
            Text("Drivers List")
                .font(.title)
                .padding()
            
            if (shouldShowUpdatedView) {
                List {
                    Section(header: Text("NORTH Drivers").foregroundColor(.green)) {
                        ForEach(dailyViewModel.drivers.filter { $0.location == "NORTH" }) { driver in
                            HStack {
                                Text(driver.name)
                                Spacer()
                                Text(String(driver.seats))
                                Spacer()
                                Text(driver.locationPreference)
                                Button(action: {
                                    dailyViewModel.moveDriver(dbChild: "Daily-Practice", driverID: driver.id,
                                                              fromList: "north_drivers", toList: "rand_drivers")
                                    driver.location = "RAND"
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                }
                            }
                        }
                    }

                    Section(header: Text("RAND Drivers").foregroundColor(.blue)) {
                        ForEach(dailyViewModel.drivers.filter { $0.location == "RAND" }) { driver in
                            HStack {
                                Text(driver.name)
                                Spacer()
                                Text(String(driver.seats))
                                Spacer()
                                Text(driver.locationPreference)
                                Button(action: {
                                    dailyViewModel.moveDriver(dbChild: "Daily-Practice", driverID: driver.id,
                                                              fromList: "rand_drivers", toList: "north_drivers")
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
                    Color.black.opacity(0.8)
                      .edgesIgnoringSafeArea(.all)
                      .blur(radius: 200)

                    ZStack {
                      Color.gray.opacity(0.5)

                      Circle()
                        .trim(from: 0.2, to: 1)
                        .stroke(
                          Color.white,
                          style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round
                          )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                        .rotationEffect(.degrees(360))
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                }
            }
        }
        .onAppear {
            // When the view appears, call assignNoPref with a slight delay
            // to ensure that the data is updated before showing the updated view
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Adjust the delay as needed
                if (!dailyViewModel.isDriversListPopulated) {
                    dailyViewModel.assignNoPref()
                }
                shouldShowUpdatedView = true
            }
        }
    }
}



struct ListDriversView_Previews: PreviewProvider {
    static var previews: some View {
        ListDriversView()
    }
}
