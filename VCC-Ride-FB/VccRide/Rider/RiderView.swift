import SwiftUI

struct LoadRiderView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var isLoaded = false
    @ObservedObject private var userViewModel = UserViewModel()
    
    @State private var isSheetPresented = false
    
    var body: some View {
        Group {
            if (dailyViewModel.practiceToday) {
                
                if dailyViewModel.riders.keys.contains(where: { $0 == userViewModel.userID }) {
                    RiderView()
                } else {
                    Button("Fill Attendance Form") {
                        isSheetPresented = true
                    }
                    .sheet(isPresented: $isSheetPresented) {
                        AttendanceFormView(isSheetPresented: $isSheetPresented, role: "rider")
                    }
                }
            } else {
                NoPracticeView()
            }
        }
        .task {
            if (!isLoaded) {
                userViewModel.fetchUserFeatures()
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
                
                if (dailyViewModel.drivers.isEmpty) {
                    Text("There are either no drivers today or there is no practice today.")
                        .padding()
                }
                
                if (userViewModel.userLocation == "North") {
                    ForEach(Array(dailyViewModel.filterDrivers(locationFilter: "north", isDepartedFilter: false)), id: \.key) { (userID, userData) in
                        // TODO: see filled seats
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(userData["name"] as? String ?? "Unknown Name")")
                            Text("Location: \(userData["location"] as? String ?? "Unknown Location")")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                        .cornerRadius(10)
                    }
                } else {
                    ForEach(Array(dailyViewModel.filterDrivers(locationFilter: "rand", isDepartedFilter: false)), id: \.key) { (userID, userData) in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(userData["name"] as? String ?? "Unknown Name")")
                            Text("Location: \(userData["location"] as? String ?? "Unknown Location")")
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

