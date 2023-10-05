//
//  LoginJoinView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI

struct LoginJoinView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isLoginMode = true
    @State var email = ""
    @State var password = ""
    @State var profileImage: UIImage?
    @State var isShowingImagePicker = false
    @State var selectedImage: UIImage?
    @StateObject var vm = SignIn_withGoogle_VM()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if isLoginMode{
                        Group {
                            TextField("email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("password", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        MyButton(title: "login", color: .blue) {
                            loginUserAction()
                        }
                        
                        MyButton(title: "sign up", color: Color(.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0))) {
                            isLoginMode.toggle()
                        }
                        
                        Button {
                            vm.signInWithGoogle()
                        } label: {
                            Text("Sign In with Google")
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(.black)
                                .cornerRadius(10)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Image(systemName: "g.circle")
                                            .font(.title2)
                                            .padding()
                                            .foregroundColor(.white)
                                            .padding(.trailing, 53)
                                    }
                                )
                        }
                        .padding(.vertical)
                    } else {
                        Button {
                            isShowingImagePicker.toggle()
                        } label: {
                            VStack {
                                if let profileImage = self.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .cornerRadius(32)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 32))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3))
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePickerView(selectedImage: $profileImage)
                        }
                        Group {
                            TextField("email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("password", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        MyButton(title: "sign up", color: .blue) {
                            registerUserAction()
                        }
                        
                        MyButton(title: "login", color: Color(.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0))) {
                            isLoginMode.toggle()
                        }
                    }
                    
                }
                .padding(16)
            }
            .navigationBarTitle(isLoginMode ? "login" : "sign up")
            .background(Color(.init(gray:0.1, alpha: 0.1))
                .ignoresSafeArea())
        }
    }
    
    func registerUserAction() {
        FirebaseUtil.shared.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            print("joined user: \(authResult?.user.email ?? "")")
            
            self.uploadImage()
        }
    }
    
    func uploadImage() {
        guard let safeProfileImage = profileImage else {
            print("Image not selected")
            return
        }
        
        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else {
            print("Not logged in")
            return
        }
        
        let imagePath = "images/\(UUID().uuidString).jpg"
        
        uploadImageToStorage(safeProfileImage, path: imagePath) { result in
            switch result {
            case .success(let downloadURL):
                print("upload success: \(downloadURL)")
                self.storeUserInformation(profileImageUrl: downloadURL)
            case .failure(let error):
                print("upload failed: \(error.localizedDescription)")
            }
        }
    }
    
    func storeUserInformation(profileImageUrl: String?) {
        guard let profileImageUrl = profileImageUrl else {
            print("no image url")
            return
        }
        
        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else {
            print("not logged in")
            return
        }
        
        let userEmail = FirebaseUtil.shared.auth.currentUser?.email ?? ""
        let userInfo: [String: Any] = [
            "uid": uid,
            "email": userEmail,
            "profileImageUrl": profileImageUrl
        ]
        
        FirebaseUtil.shared.firestore.collection("users").document(uid).setData(userInfo) {error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("db store success")
            }
        }
    }
    
    func uploadImageToStorage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to daga"])))
            return
        }
        
        let storageRef = FirebaseUtil.shared.storage.reference().child(path)
        
        storageRef.putData(imageData, metadata:nil) {metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL {url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "DownloadURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
    
    func loginUserAction() {
        FirebaseUtil.shared.auth.signIn(withEmail: email, password: password) {authResult, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            print("logined user: \(authResult?.user.email ?? "")")
            print("logined user: \(authResult?.user.uid ?? "")")
        }
    }

}

struct MyButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                Spacer()
            }
            .background(color)
            .cornerRadius(5)
        }
    }
}


struct LoginJoinView_Previews: PreviewProvider {
    static var previews: some View {
        LoginJoinView(viewModel: MainViewModel())
    }
}
