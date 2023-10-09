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
        TabView {
            AppSettingsView()
                .tag(0)

            if viewModel.userRole == "admin" {
                AdminSettingsView()
                    .tag(1)
            } else if viewModel.userRole == "driver" {
                DriverSettingsView()
                    .tag(1)
            } else {
                RiderSettingsView()
            }
            // ALSO WANT TO BE ABLE TO 
            DriverSettingsView() // CHANGE THIS TO DEPEND ON USER ROLE
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct SettingsMainView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMainView()
    }
}
