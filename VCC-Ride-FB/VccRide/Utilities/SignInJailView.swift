import SwiftUI
import Firebase

struct SignInJailView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State var selectedRole: String = "rider"
    
    @State private var selectedLocation: String = "North"
    
    @State private var selectedConfirm: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Group {
                    Text("Please fill out the form below, an admin will give you access soon")
                        .font(.subheadline)
                    Spacer()
                    
                    Text("Select your Role. If you wish to be an Admin, please contact your Transportation Director.")
                        .font(.subheadline)
                    Text("")
                    
                }
                Picker("Role", selection: $selectedRole) {
                    Text("Rider").tag("rider")
                    Text("Driver").tag("driver")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Select Default Location")
                    .font(.subheadline)
                
                if selectedRole == "driver" {
                    Picker("Default Location", selection: $selectedLocation) {
                        Text("North").tag("North")
                        Text("Rand").tag("Rand")
                        Text("No Preference").tag("No Preference")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } else {
                    Picker("Default Location", selection: $selectedLocation) {
                        Text("North").tag("North")
                        Text("Rand").tag("Rand")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Text("Do you want to be automatically confirmed for attendance or fill out a form?")
                    .font(.subheadline)

                // Attendance Confirmation Picker (Available for all)
                Picker("Attendance Confirmation", selection: $selectedConfirm) {
                    Text("Form").tag(false)
                    Text("Automatic").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())

                ZStack {
                    Button(action: {
                        // Save the selected role to the database
                        viewModel.getOutOfJail(newRole: selectedRole, newLocation: selectedLocation, newConfirm: selectedConfirm)
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .padding(.top, 20)

                ZStack {
                    Button(action: {
                        // Sign out the user
                        do {
                            try Auth.auth().signOut()
                            viewModel.handleSignOut() // Handle sign out in the main view model
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.red)
                    .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding() // Add margins to the entire content
            .navigationBarTitle("Sign In") // Set a navigation bar title
        }
    }
}

struct SignInJailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInJailView()
    }
}
