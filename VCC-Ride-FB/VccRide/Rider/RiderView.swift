import SwiftUI

struct LoadRiderView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var isLoaded = false
    @ObservedObject private var userViewModel = UserViewModel()
    
    var body: some View {
        Group {
            if (dailyViewModel.practiceToday) {
                
                if (dailyViewModel.northClimbers.first(where: { $0.id == userViewModel.userID }) ?? dailyViewModel.randClimbers.first(where: { $0.id == userViewModel.userID })) != nil {
                    RiderView()
                } else {
                    RiderNotAttendingView()
                }
            } else {
                NoPracticeView()
            }
        }
        .task {
            if (!isLoaded) {
                userViewModel.fetchUserFeatures()
                if !dailyViewModel.hasBeenAssigned {
                    dailyViewModel.getRiderList(fromLocation: "north_riders")
                    dailyViewModel.getRiderList(fromLocation: "rand_riders")
                    dailyViewModel.getDriverList(fromLocation: "north_drivers")
                    dailyViewModel.getDriverList(fromLocation: "rand_drivers")
                }
                isLoaded = true
            }
        }
    }
}

struct RiderView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel()

    var body: some View {
        VStack {
            Text("Welcome, \(userViewModel.userName)").font(.headline)
            Text("Next Practice Date: \(dailyViewModel.date)").font(.subheadline)
                .padding(.bottom)

            ScrollView {
                Text("Drivers").font(.subheadline)
                if (userViewModel.userLocation == "North") {
                    ForEach(dailyViewModel.northDrivers) { driver in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(driver.name)")
                            Text("Location: \(driver.location)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                        .cornerRadius(10)
                    }
                } else {
                    ForEach(dailyViewModel.randDrivers) { driver in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(driver.name)")
                            Text("Location: \(driver.location)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
        .padding()
        .onAppear {
            userViewModel.fetchUserFeatures()
            if !dailyViewModel.hasBeenAssigned {
                if (userViewModel.userLocation == "North") {
                    dailyViewModel.getDriverList(fromLocation: "north_drivers")
                    print("location should be north, is: ", userViewModel.userLocation)
                } else {
                    dailyViewModel.getDriverList(fromLocation: "rand_drivers")
                    print("location should be rand, is: ", userViewModel.userLocation)
                }
            }
        }
    }
}

struct RiderNotAttendingView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    
    var body: some View {
        VStack {
            Text("You are currently marked as not attending today. If you would like to come, fill out the form below!")
        }
    }
}


struct RiderView_Previews: PreviewProvider {
    static var previews: some View {
        RiderView()
    }
}

