//
//  LoginJoinView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State var isLoginMode = true
    //    @State var isUserLoggedIn = false
    //    @State var email = ""
    //    @State var password = ""
    @State var profileImage: UIImage?
    @State var isShowingImagePicker = false
    @State var selectedImage: UIImage?
    @State private var errorMessage: String?
    @ObservedObject var vm = SignIn_withGoogle_VM()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoginMode{
                    
                    Image("VCC-empty-back") // Use the name of your image asset
                        .resizable()
                        .frame(width: 170, height: 225.89) // Adjust the size as needed
                        .offset(y: -60)
                    
                    Text("VCC Ride")
                        .padding(.horizontal)
                        .offset(y: -30)
//                        .font(.system(size: 22))
                        .font(.custom("Evanson Tavern", fixedSize: 23))
                  
                    
                    
                    
                    Button(action: {
                        vm.viewModel = viewModel
                        vm.signInWithGoogle {errMessage in
                            if let message = errMessage {
                                errorMessage = message
                                // Handle successful login
                                print("Fail!") // FOR DEBUGGING
                            } else {
                                print("success!")
                            }
                        }
                    }) {
                        HStack {
                            Image("google") // Use the name of your Google logo asset
                                .resizable()
                                .frame(width: 20, height: 20) // Adjust the size as needed
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
                errorMessage.map { message in
                    Text(message)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .frame(width: 400, height: 900)
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(red: 0.98, green: 0.99, blue: 0.84), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.75, green: 0.75, blue: 0.56).opacity(0.90), location: 1.00),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(50)
            
        }
    }
}
    
//    func uploadImage() {
//        guard let safeProfileImage = profileImage else {
//            print("Image not selected")
//            return
//        }
//
//        guard (FirebaseUtil.shared.auth.currentUser?.uid) != nil else {
//            print("Not logged in")
//            return
//        }
//
//        let imagePath = "images/\(UUID().uuidString).jpg"
//
//        uploadImageToStorage(safeProfileImage, path: imagePath) { result in
//            switch result {
//            case .success(let downloadURL):
//                print("upload success: \(downloadURL)")
//                self.storeUserInformation(profileImageUrl: downloadURL)
//            case .failure(let error):
//                print("upload failed: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func storeUserInformation(profileImageUrl: String?) {
//        guard let profileImageUrl = profileImageUrl else {
//            print("no image url")
//            return
//        }
//
//        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else {
//            print("not logged in")
//            return
//        }
//
//        let userEmail = FirebaseUtil.shared.auth.currentUser?.email ?? ""
//        let userInfo: [String: Any] = [
//            "uid": uid,
//            "email": userEmail,
//            "profileImageUrl": profileImageUrl
//        ]
//
//        FirebaseUtil.shared.firestore.collection("users").document(uid).setData(userInfo) {error in
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//            } else {
//                print("db store success")
//            }
//        }
//    }
    
//    func uploadImageToStorage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to daga"])))
//            return
//        }
//
//        let storageRef = FirebaseUtil.shared.storage.reference().child(path)
//
//        storageRef.putData(imageData, metadata:nil) {metadata, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            storageRef.downloadURL {url, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                if let url = url {
//                    completion(.success(url.absoluteString))
//                } else {
//                    completion(.failure(NSError(domain: "DownloadURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
//                }
//            }
//        }
//    }
// }


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(MainViewModel())
    }
}
