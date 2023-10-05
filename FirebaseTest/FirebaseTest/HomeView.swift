//
//  HomeView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home View")
                Divider()
                Button("logout") {
                    viewModel.isLoggedIn = false
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MainViewModel())
    }
}
