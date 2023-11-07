import SwiftUI


struct RiderView: View {
    let dailyViewModel = DailyViewModel.shared
    @State private var filteredDrivers: [Driver] = [] // Store the filtered drivers here
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel()

    var body: some View {
        VStack {
            Text("Welcome, \(userViewModel.riderName)").font(.headline)
            Text("Next Practice Date: \(nextPracticeDate)").font(.subheadline)
                .padding(.bottom)

            ScrollView {
                Text("Drivers").font(.subheadline)
                ForEach(filteredDrivers) { driver in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(driver.name)")
                        Text("Location: \(driver.location)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                    .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
        .padding()
        .onAppear {
            userViewModel.fetchUserFeatures()
            if !isViewAppeared {
                isViewAppeared = true
                fetchDriversByLocation(riderLocation: userViewModel.riderLocation)
            }
        }
    }

    private func fetchDriversByLocation(riderLocation: String) {
        // Call the DailyViewModel method to fetch drivers from the specified location
//        dailyViewModel.getDriverList(fromLocation: riderLocation, assignedLocation: riderLocation)
        // Update filteredDrivers with the fetched driver list
        print("attempt")
        filteredDrivers = dailyViewModel.drivers
    }
}

//struct RiderView: View {
//
//    let dailyViewModel = DailyViewModel.shared
//    @State private var selectedLocation = "Any"
//    @State private var isActive = "Any"
//    @State private var filteredUsers: [String: [String: Any]] = [:] // Replace with appropriate data structure
//    @State private var isViewAppeared = false
//    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users
//
//    var body: some View {
//        VStack {
//            // Title and Subtitle
//            Text("Welcome, \(userViewModel.riderName)").font(.headline)
//            Text("Next Practice Date: \(nextPracticeDate)").font(.subheadline)
//                .padding(.bottom)
//
//            ScrollView {
//                Text("Drivers").font(.subheadline)
//                ForEach(Array(filteredUsers), id: \.key) { (userID, userData) in
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Email: \(userData["email"] as? String ?? "")")
//                        Text("Location: \(userData["default_location"] as? String ?? "")")
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
//                    .cornerRadius(10)
//                }
//            }
//            .padding(.top, 20)  // Adjusted padding for ScrollView
//            .padding(.horizontal, 20) // Add horizontal padding to the ScrollView
//        }
//        .padding()
//        .onAppear { // Move the onAppear block inside the body
//            userViewModel.fetchUserFeatures()
//            if !isViewAppeared {
//                isViewAppeared = true
//                userViewModel.fetchUsers {
//                    applyFilters() // Apply filters once data is fetched
//                }
//            }
//        }
//    }
//
//    // Define the filter function outside of the body
//    private func applyFilters() {
//        filteredUsers = userViewModel.filterUsers(
//            roleFilter: "driver",
//            activeFilter: isActive,
//            locationFilter: riderLocation
//        )
//    }
//}

struct RiderView_Previews: PreviewProvider {
    static var previews: some View {
        RiderView()
    }
}

