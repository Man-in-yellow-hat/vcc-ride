import SwiftUI
import Firebase

struct LoadDriverView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            if let driver = dailyViewModel.northDrivers.first(where: { $0.id == userViewModel.userID }) ?? dailyViewModel.randDrivers.first(where: { $0.id == userViewModel.userID }) {
                DriverView(thisDriver: driver)
            } else {
                NextPracticeScreenView()
            }
        }
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

struct DriverView: View {
    
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users
    @State public var thisDriver: Driver // Make it an optional
    
    var body: some View {
        VStack {
            // Title and Subtitle
            Text("Welcome, \(userViewModel.userName)").font(.headline)
            Text("Next Practice Date: \(dailyViewModel.date)").font(.subheadline)
                .padding(.bottom)
            
            VStack { // Wrap the specific lines in a VStack
                Text("**Picking up from: \(thisDriver.location)**").font(.headline)
                Text("Your Seats: Please fill \(thisDriver.seats) seats before you leave!").font(.subheadline)
                Text("")
                HStack { // Use HStack here
                    Image(systemName: thisDriver.isFull() ? "car.side.fill" : "car.side")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .scaleEffect(x: -1, y: 1) // Mirroring the image horizontally
                        .gesture(DragGesture()
                            .onEnded { value in
                                if value.translation.width > 100 && thisDriver.isFull() {
                                    // Call your departure function here
                                    handleDeparture()
                                }
                            }
                        )
                    
                    if thisDriver.isFull() {
                        ArrowView()
                            .padding(.trailing, 10) // Adjust as needed
                    } else {
                        Spacer()
                    }
                    
                    Button(action: {
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
        }
        .padding()
//        .onAppear {
//            userViewModel.fetchUserFeatures()
//            if !dailyViewModel.hasBeenAssigned {
//                dailyViewModel.getRiderList(fromLocation: "north_riders")
//                dailyViewModel.getRiderList(fromLocation: "rand_riders")
//                dailyViewModel.getDriverList(fromLocation: "north_drivers")
//                dailyViewModel.getDriverList(fromLocation: "rand_drivers")
//
//            } else {
//                // TODO: go to nextPractice screen?
//                print("here")
//            }
//        }
    }
    
    private func handleDeparture() {
        print("leaving!")
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView(thisDriver: Driver(id: "tmp", name: "tmp", location: "tmp", seats: 4, preference: "tmp"))
    }
}

struct ArrowView: View {
    var body: some View {
        Image(systemName: "arrow.right.circle.fill")
            .font(.system(size: 30))
            .foregroundColor(.green)
            .opacity(0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
    }
}


struct NextPracticeScreenView: View {
    var body: some View {
        Text("NEXT PRACTICE SCREEN")
    }
}


