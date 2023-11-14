import SwiftUI

let pickupLocation = "Rand"
let minSeats = 3

struct DriverView: View {
    
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users
    
    var body: some View {
        VStack {
            // Title and Subtitle
            Text("Welcome, \(userViewModel.riderName)").font(.headline)
            Text("Next Practice Date: \(dailyViewModel.date)").font(.subheadline)
                .padding(.bottom)
            
            VStack { // Wrap the specific lines in a VStack
                Text("**Picking up from: \(pickupLocation)**").font(.headline)
                Text("Your Seats: Please fill \(minSeats) seats before you leave!").font(.subheadline)
                Text("")
                HStack { // Use HStack here
                    ForEach(0..<minSeats, id: \.self) { index in
                        Image(systemName: dailyViewModel.isSeatFilled(at: index) ? "person.fill" : "person")
                            .font(.system(size: 30)) // Adjust the size as needed
                            .foregroundColor(.black) // Change icon color if needed
                            .onTapGesture {
                                dailyViewModel.toggleSeat(at: index)
                                // Update the database and dailyViewModel as needed
                                dailyViewModel.updateNumFilledSeats(forLocation: pickupLocation, count: dailyViewModel.filledSeatsCount)
                            }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3)))
            
            ScrollView {
                Text("North Rider Manifest").font(.subheadline)
                ForEach(dailyViewModel.northClimbers) { climber in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(climber.name)")
                        Text("Location: \(climber.location)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                    .cornerRadius(10)
                }
            }
            .padding(.top, 20)  // Adjusted padding for ScrollView
            .padding(.horizontal, 20) // Add horizontal padding to the ScrollView
            
            ScrollView {
                Text("Rand Rider Manifest").font(.subheadline)
                ForEach(dailyViewModel.randClimbers) { climber in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(climber.name)")
                        Text("Location: \(climber.location)")
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
            if !dailyViewModel.hasBeenAssigned {
                dailyViewModel.getRiderList(fromLocation: "north_riders", assignedLocation: "NORTH")
                dailyViewModel.getRiderList(fromLocation: "rand_riders", assignedLocation: "RAND")
            }
        }
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView()
    }
}

