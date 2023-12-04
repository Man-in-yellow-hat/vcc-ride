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
                
                if (dailyViewModel.drivers.isEmpty) {
                    Text("There are either no drivers today or there is no practice today.")
                        .padding()
                }
                // we want to see the drivers who are still there
                ForEach(Array(dailyViewModel.filterDrivers(careDeparted: true, isDepartedFilter: false).keys), id: \.self) { driverID in
//                ForEach(Array(dailyViewModel.drivers.keys), id: \.self) { driverID in
                    if let driverData = dailyViewModel.drivers[driverID], let location = driverData["location"] as? String, location == userViewModel.userLocation.lowercased() {
                        Text(userViewModel.userLocation + " Drivers")
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(driverData["name"] as? String ?? "Unknown Name")")
                            Text("Seats Filled: \(driverData["filled_seats"] as? Int ?? 0)/\(driverData["seats"] as? Int ?? 0)")
//                            Text("Departed: \(driverData["isDeparted"] as? Bool ?? false ? "Yes" : "No")")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    else {
                        
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

