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
//            AppSettingsView()
//                .tag(0)

            if viewModel.userRole == "admin" {
                AdminSettingsView().environmentObject(viewModel)
                    .tag(0)
            } else if viewModel.userRole == "driver" {
                DriverSettingsView().environmentObject(viewModel)
                    .tag(0)
            }
            // ALSO WANT TO BE ABLE TO
            RiderSettingsView().environmentObject(viewModel) // CHANGE THIS TO DEPEND ON USER ROLE
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

