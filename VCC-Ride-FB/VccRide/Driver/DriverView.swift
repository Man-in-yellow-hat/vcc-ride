import SwiftUI
import Firebase

let pickupLocation = "Rand"
let minSeats = 3

struct DriverView: View {
    
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users
    public let thisDriver: Driver
    
    init() {
        thisDriver = Driver(id: "temp", name: "temp", location: "temp", seats: 4, preference: "temp")
    }
    
//    init() {
//        let driverID = userViewModel.userID
//        let location = userViewModel.userLocation.lowercased() + "_drivers"
//        let northRef = Database.database().reference().child("Daily-Practice").child("north_drivers").child(driverID)
//
//        let randRef = Database.database().reference().child("Daily-Practice").child("rand_drivers").child(driverID)
//        randRef.observeSingleEvent(of: .value) { snapshot, error in
//            if let data = snapshot.value
//
//            if let error = error {
//                print("Error fetching driver data: \(error)")
//            }
//        }
//
//        //need to get SEATS and
//        thisDriver = Driver(id: driverID, name: userViewModel.userName, location: location, seats: 0, preference: String)
//    }
    
    var body: some View {
        VStack {
            // Title and Subtitle
            Text("Welcome, \(userViewModel.userName)").font(.headline)
            Text("Next Practice Date: \(dailyViewModel.date)").font(.subheadline)
                .padding(.bottom)
            
            VStack { // Wrap the specific lines in a VStack
                Text("**Picking up from: \(pickupLocation)**").font(.headline)
                Text("Your Seats: Please fill \(thisDriver.seats) seats before you leave!").font(.subheadline)
                Text("")
                HStack { // Use HStack here
                    Image(systemName: thisDriver.isFull() ? "car.side.fill" : "car.side")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .scaleEffect(x: -1, y: 1) // Mirroring the image horizontally
                    
                    Spacer()
                    
                    Button(action: {
                        // Implement the logic to clear filled seats
                        thisDriver.toggleSeat(at: -1)
                    }) {
                        Image(systemName: "clear.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    ForEach(0..<thisDriver.seats, id: \.self) { index in
                        Image(systemName: thisDriver.isSeatFilled(at: index) ? "person.fill" : "person")
                            .font(.system(size: 40)) // Adjust the size as needed
                            .foregroundColor(.black) // Change icon color if needed
                            .onTapGesture {
                                thisDriver.toggleSeat(at: index)
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
                
                Spacer()
                
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
                
                Group {
                    Spacer()
                    
                    Text("North Drivers").font(.subheadline)
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
                    
                    Spacer()
                    
                    Text("Rand Drivers").font(.subheadline)
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
            .padding(.top, 20)  // Adjusted padding for ScrollView
            .padding(.horizontal, 20) // Add horizontal padding to the ScrollView
            
//            ScrollView {
//
//            }
//            .padding(.top, 20)  // Adjusted padding for ScrollView
//            .padding(.horizontal, 20) // Add horizontal padding to the ScrollView
        }
        .padding()
        .onAppear {
            userViewModel.fetchUserFeatures()
            if !dailyViewModel.hasBeenAssigned {
                dailyViewModel.getRiderList(fromLocation: "north_riders")
                dailyViewModel.getRiderList(fromLocation: "rand_riders")
                dailyViewModel.getDriverList(fromLocation: "north_drivers")
                dailyViewModel.getDriverList(fromLocation: "rand_drivers")
            }
        }
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView()
    }
}

