//
//  NoPracticeView.swift
//  VccRide
//
//  Created by Nathan King on 11/29/23.
//

import SwiftUI

struct NoPracticeView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
        
    var body: some View {
        VStack {
            Text("NO PRACTICE TODAY")
        }
    }
}

struct NoPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoPracticeView()
    }
}
