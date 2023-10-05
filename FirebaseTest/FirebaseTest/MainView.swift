//
//  ContentView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
            HomeView(viewModel: viewModel)
        } else {
            LoginJoinView(viewModel: viewModel)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

