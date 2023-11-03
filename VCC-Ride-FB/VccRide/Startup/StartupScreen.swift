//
//  StartupScreen.swift
//  VccRide
//
//  Created by Nathan King on 11/2/23.
//

import SwiftUI
import SwiftUI

struct StartupScreen: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let imageName: String = colorScheme == .dark ? "vcc-TEXT-dark" : "vcc-TEXT"

        NavigationStack {
            VStack {
                Image(imageName) // Use the name of your image asset
                    .resizable()
                    .frame(width: 209.5, height: 60) // Adjust the size as needed
                    .offset(y: -60)
            }
        }
    }
}

struct StartupScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartupScreen()
    }
}


