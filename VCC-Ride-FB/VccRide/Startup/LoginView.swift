//
//  LoginJoinView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject private var viewModel = MainViewModel.shared
    @Environment(\.colorScheme) var colorScheme

    @State private var isVandyTextVisible = false
    @State private var isLogoVisible = false
    @State private var isTextVisible = false
    @State private var isButtonVisible = false
    @State private var isGradientVisible = false
    @State private var isAppleVisible = false
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
                                    .offset(x: 45)
                                Text("Sign in with Google")
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical)
                        }
                        .background(Color.blue)
                        .frame(width: 280, height: 50)
                        .cornerRadius(50)
                    }
                    
                    if isAppleVisible {
                        SignInWithAppleButton { request in
                            // Request desired user details
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                // Handle authentication success
                                switch authResults.credential {
                                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                    // Extract token and user details
                                    let userID = appleIDCredential.user
                                    guard let identityToken = appleIDCredential.identityToken,
                                          let tokenString = String(data: identityToken, encoding: .utf8) else { return }

                                    // Create Apple credential
                                    let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                              idToken: tokenString,
                                                                              rawNonce: nil)

                                    // Firebase sign in with credential
                                    signInWithFirebase(credential: credential)
                                default: break
                                }
                            case .failure(let error):
                                // Handle error
                                print("Authentication error: \(error.localizedDescription)")
                            }
                        }
                        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                        .frame(width: 280, height: 50)
                        .cornerRadius(50)
                    }
                    

                    
                    if isButtonVisible {
                        Button(action: {
                            withAnimation {
                                isAppleVisible.toggle()
                            }
                        }) {
                            Image(systemName: isAppleVisible ? "chevron.up" : "chevron.down.circle.fill")
                                .offset(y: 12)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    func signInWithFirebase(credential: AuthCredential) {
        vm.signInWithApple(credential: credential) { errMessage in
            if let message = errMessage {
                errorMessage = message
            } else {
                print("Apple sign-in successful!")
                // Handle successful sign-in, such as navigating to another view
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
