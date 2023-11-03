//
//  LoginJoinView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: MainViewModel
//    @Environment(\.colorScheme) var colorScheme
    @State private var isVandyTextVisible = false
    @State private var isLogoVisible = false
    @State private var isTextVisible = false
    @State private var isButtonVisible = false
    @State private var isGradientVisible = false
    @State private var errorMessage: String?

    @ObservedObject var vm = SignIn_withGoogle_VM()

    var body: some View {
        NavigationView {
            ZStack {
                if isGradientVisible {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: Color(red: 0.96, green: 0.99, blue: 0.82), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.72, green: 0.72, blue: 0.52).opacity(0.95), location: 1.00),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }

                VStack {
                    if isVandyTextVisible {
                        Image("vcc-TEXT")
                            .resizable()
                            .frame(width: 209.5, height: 60)
                            .offset(y: -60)
                    }
                    
                    if isLogoVisible {
                        Image("vcc-CLIMBER")
                            .resizable()
                            .frame(width: 180, height: 207)
                            .offset(x: 7, y: -30)
                    }

                    if isTextVisible {
                        Text("VCC Ride")
                            .padding(.horizontal)
                            .offset(y: -12)
                            .foregroundStyle(.black)
                            .font(.custom("Evanson Tavern", fixedSize: 23))
                    }

                    if isButtonVisible {
                        Button(action: {
                            vm.viewModel = viewModel
                            vm.signInWithGoogle { errMessage in
                                if let message = errMessage {
                                    errorMessage = message
                                } else {
                                    print("success!")
                                }
                            }
                        }) {
                            HStack {
                                Image("google")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .offset(x: 30)
                                Text("Sign In with Google")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical)
                        }
                        .background(Color.blue)
                        .cornerRadius(50)
                        .frame(width: 280)
                    }
                }
            }
            .frame(width: 400, height: 900)
            .cornerRadius(50)
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isGradientVisible = true
                    isVandyTextVisible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isTextVisible = true
                        isButtonVisible = true
                        isLogoVisible = true
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(MainViewModel())
    }
}
