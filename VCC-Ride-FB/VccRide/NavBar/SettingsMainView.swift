//
//  SettingsMainView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI

struct SettingsMainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        NavigationStack {
            if viewModel.userRole == "rider" {
                RiderSettingsView().environmentObject(viewModel)
                    .tag(0)
            } else {
                DriverSettingsView().environmentObject(viewModel)
                    .tag(1)
            }
        }
    }
}

struct SettingsMainView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMainView()
    }
}

