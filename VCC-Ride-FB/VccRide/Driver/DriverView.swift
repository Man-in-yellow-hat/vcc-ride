import SwiftUI

let pickupLocation = "Rand"
let minSeats = 3

struct DriverView: View {
    
    let driversViewModel = DriversViewModel.shared
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State private var filteredUsers: [String: [String: Any]] = [:] // Replace with appropriate data structure
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users
    
    var body: some View {
        VStack {
            // Title and Subtitle
            Text("Welcome, \(userViewModel.riderName)").font(.headline)
            Text("Next Practice Date: \(nextPracticeDate)").font(.subheadline)
                .padding(.bottom)
            
            VStack { // Wrap the specific lines in a VStack
                Text("**Picking up from: \(pickupLocation)**").font(.headline)
                Text("Your Seats: Please fill \(minSeats) seats before you leave!").font(.subheadline)
                Text("")
                HStack { // Use HStack here
                    ForEach(0..<minSeats, id: \.self) { index in
                        Image(systemName: "person.fill") // Replace with your icon
                            .font(.system(size: 30)) // Adjust the size as needed
                            .foregroundColor(.black) // Change icon color if needed
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3)))
            
            

                        
            ScrollView {
                Text("Rider Manifest").font(.subheadline)
                ForEach(Array(filteredUsers), id: \.key) { (userID, userData) in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email: \(userData["email"] as? String ?? "")")
                        Text("Location: \(userData["default_location"] as? String ?? "")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                    .cornerRadius(10)
                }
            }
            .padding(.top, 20)  // Adjusted padding for ScrollView
            .padding(.horizontal, 20) // Add horizontal padding to the ScrollView
        }
        .padding()
        .onAppear {
            userViewModel.fetchUserFeatures()
            // Move the onAppear block inside the body
            if !isViewAppeared {
                isViewAppeared = true
                userViewModel.fetchUsers {
                    applyFilters() // Apply filters once data is fetched
                }
            }
        }
    }
    
    // Define the filter function outside of the body
    private func applyFilters() {
        filteredUsers = userViewModel.filterUsers(
            roleFilter: "rider", // Filter by the "rider" role
            activeFilter: isActive,
            locationFilter: pickupLocation
        )
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView()
    }
}

