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

    var body: some View {
        VStack {
            Text("Drivers List")
                .font(.title)
                .padding()

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
                                                          fromList: "north_driver", toList: "rand_driver")
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
                                                          fromList: "rand_driver", toList: "north_driver")
                                driver.location = "NORTH"
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                            }
                        }
                    }
                }
            }
        }
    }
}



struct ListDriversView_Previews: PreviewProvider {
    static var previews: some View {
        ListDriversView()
    }
}
