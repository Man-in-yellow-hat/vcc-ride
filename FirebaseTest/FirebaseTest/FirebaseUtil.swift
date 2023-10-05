//
//  FirebaseUtil.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import GoogleSignIn

class FirebaseUtil: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseUtil()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

class SignIn_withGoogle_VM: ObservableObject {
    @Published var isLoginSuccessed = false
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting:Application_utility.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else {return}
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {res, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = res?.user else {return}
                print(user)
            }
        }
    }
}
