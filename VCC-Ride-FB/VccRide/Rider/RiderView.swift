import SwiftUI


struct RiderView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel()

    var body: some View {
        VStack {
            Text("Welcome, \(userViewModel.riderName)").font(.headline)
            Text("Next Practice Date: \(dailyViewModel.date)").font(.subheadline)
                .padding(.bottom)

            ScrollView {
                Text("Drivers").font(.subheadline)
                if (userViewModel.riderLocation == "North") {
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
                        .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
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
                if (userViewModel.riderLocation == "North") {
                    dailyViewModel.getDriverList(fromLocation: "north_drivers", assignedLocation: "NORTH")
                    print("location should be north, is: ", userViewModel.riderLocation)
                } else {
                    dailyViewModel.getDriverList(fromLocation: "rand_drivers", assignedLocation: "RAND")
                    print("location should be rand, is: ", userViewModel.riderLocation)
                }
            }
        }
    }
}


struct RiderView_Previews: PreviewProvider {
    static var previews: some View {
        RiderView()
    }
}

