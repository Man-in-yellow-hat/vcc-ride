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

    @ObservedObject var driversViewModel = DriversViewModel.shared

    var body: some View {
        VStack {
            Text("Drivers List")
                .font(.title)
                .padding()

            List {
                Section(header: Text("NORTH Drivers").foregroundColor(.green)) {
                    ForEach(driversViewModel.drivers.filter { $0.location == "NORTH" }) { driver in
                        HStack {
                            Text(driver.name)
                            Spacer()
                            Text(driver.location)
                                .foregroundColor(.green)
                        }
                        // Handle driver selection and assignment
                    }
                }

                Section(header: Text("RAND Drivers").foregroundColor(.blue)) {
                    ForEach(driversViewModel.drivers.filter { $0.location == "RAND" }) { driver in
                        HStack {
                            Text(driver.name)
                            Spacer()
                            Text(driver.location)
                                .foregroundColor(.blue)
                        }
                        // Handle driver selection and assignment
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
