////
////  adminEditUserView.swift
////  VccRide
////
////  Created by Nathan King on 10/10/23.
////
//
//import SwiftUI
//
//struct AdminEditUserView: View {
//    let userID: String
//    @State var userData: [String: Any]
//    
//    @State private var selectedRole: String = ""
//    @State private var isActive: Bool = false
//    
//    var body: some View {
//        VStack {
//            Text("Edit User")
//                .font(.largeTitle)
//                .padding()
//            
//            Text("User ID: \(userID)")
//                .font(.headline)
//                .padding()
//            
//            Form {
//                // Role Picker
//                Section(header: Text("Role")) {
//                    Picker("Select Role", selection: $selectedRole) {
//                        Text("Rider").tag("rider")
//                        Text("Driver").tag("driver")
//                        Text("Admin").tag("admin")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    .onAppear {
//                        // Set the initial value based on userData
//                        selectedRole = userData["role"] as? String ?? ""
//                    }
//                }
//                
//                // Active Toggle
//                Section(header: Text("Active")) {
//                    Toggle("Active", isOn: $isActive)
//                        .onAppear {
//                            // Set the initial value based on userData
//                            isActive = userData["active"] as? Bool ?? false
//                        }
//                }
//            }
//            
//            Button("Save Changes") {
//                // Update the userData with the selectedRole and isActive
//                userData["role"] = selectedRole
//                userData["active"] = isActive
//                
//                // Perform the update in your data source or database
//                // Example: userViewModel.updateUser(userID: userID, userData: userData)
//            }
//            .padding()
//        }
//        .navigationTitle("Edit User")
//    }
//}
//
////struct AdminEditUserView_Previews: PreviewProvider {
////    static var previews: some View {
////        AdminEditUserView()
////    }
////}
