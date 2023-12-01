import SwiftUI
import Firebase

struct LoadDriverView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var isLoaded = false
    @ObservedObject private var userViewModel = UserViewModel()
    
    var body: some View {
        Group {
            if (dailyViewModel.practiceToday) {
                if let driverID = dailyViewModel.drivers.keys.first(where: { $0 == userViewModel.userID }),
                   let driverObj = dailyViewModel.drivers[driverID] {
                    DriverView(thisDriver: Driver(id: userViewModel.userID,
                                                      name: driverObj["name"] as! String,
                                                      location: driverObj["location"] as! String,
                                                      seats: driverObj["seats"] as! Int,
                                                      filledSeats: driverObj["filled_seats"] as! Int,
                                                      preference: driverObj["preference"] as! String,
                                                      isDeparted: driverObj["isDeparted"] as! Bool))
                } else {
                    DriverFormView()
                }
            } else {
                NoPracticeView()
            }
        }
        .task {
            dailyViewModel.adjustSeats()
            if (!isLoaded) {
                userViewModel.fetchUserFeatures()
                isLoaded = true
                print(dailyViewModel.drivers, userViewModel.userID)
            }
        }
    }
}

struct DriverView: View {
    
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State public var thisDriver: Driver
    
    @State private var carOffset: CGSize = .zero
    @State private var isDeparted: Bool = false
    
    @State private var isReturning: Bool = false
    @State private var availableSeatsInput: Int = 0
    
    @State private var squishScale: CGFloat = 1
    @State private var squishOffset: CGFloat = .zero
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            // Title and Subtitle
            Text("Welcome, \(thisDriver.name)").font(.headline)
            if (isDeparted) {
                Text("Enjoy practice!").font(.subheadline)
            }
            
            if (!isDeparted) {
                VStack { // Wrap the specific lines in a VStack
                    Text("**Picking up from: \(thisDriver.location)**").font(.headline)
                    Text("Your Seats: Please fill \(thisDriver.seats) seats before you leave!").font(.subheadline)
                    Text("")
                
                    HStack { // Use HStack here
                        Image(systemName: thisDriver.isFull() ? "car.side.fill" : "car.side")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .scaleEffect(x: -1, y: 1) // Mirroring the image horizontally
                            .offset(carOffset)
                            .gesture(DragGesture()
                                .onChanged { value in
                                    // Update the car's offset based on the drag gesture
                                    carOffset.width = max(value.translation.width, 0)
                                }
                                .onEnded { value in
                                    if value.translation.width > 250 && thisDriver.isFull() && !isDeparted {
                                        // Call your departure function here
                                        withAnimation {
                                            squishScale = 0
                                            squishOffset = 10
                                            carOffset.width = UIScreen.main.bounds.width
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust the delay if needed
                                            handleDeparture()
                                            isDeparted = true
                                        }
                                    } else if value.translation.width > 250 { //?? TODO: fix hard coding of 250?
                                        carOffset = .zero
                                        showAlert = true
                                    } else {
                                        carOffset = .zero
                                    }
                                }
                            )
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Are you sure?"),
                                    message: Text("The car is not full. Do you still want to depart?"),
                                    primaryButton: .default(Text("Depart")) {
                                        withAnimation {
                                            squishScale = 0
                                            squishOffset = 10
                                            carOffset.width = UIScreen.main.bounds.width
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust the delay if needed
                                            handleDeparture()
                                            isDeparted = true
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        
                        if thisDriver.isFull() {
                            ArrowView()
                                .padding(.trailing, 10) // Adjust as needed
                                .scaleEffect(x: 1, y: squishScale)
                                .offset(x: 0, y: squishOffset)
                                .animation(.easeIn, value: squishScale)
                                .animation(.easeIn, value: squishOffset)
                        } else {
                            Spacer()
                        }
                        
                        Button(action: {
                            let change: Int = thisDriver.toggleSeat(at: -1)
                            dailyViewModel.updateFilledSeats(forLocation: thisDriver.location, change: change)
                        }) {
                            Image(systemName: "clear.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .scaleEffect(x: 1, y: squishScale)
                                .offset(x: 0, y: squishOffset)
                                .animation(.easeIn, value: squishScale)
                                .animation(.easeIn, value: squishOffset)

                        }
                        ForEach(0..<thisDriver.seats, id: \.self) { index in
                            Image(systemName: thisDriver.isSeatFilled(at: index) ? "person.fill" : "person")
                                .font(.system(size: 40)) // Adjust the size as needed
                                .foregroundColor(.black) // Change icon color if needed
                                .scaleEffect(x: 1, y: squishScale)
                                .offset(x: 0, y: squishOffset)
                                .animation(.easeIn, value: squishScale)
                                .animation(.easeIn, value: squishOffset)
                                .onTapGesture {
                                    let change: Int = thisDriver.toggleSeat(at: index)
                                    dailyViewModel.updateFilledSeats(forLocation: thisDriver.location, change: change)
                                    
                                }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3)))
            } else {
                HStack(spacing: 5) {
                    ForEach(0..<12) { _ in
                        SmokeParticle()
                    }
                }
                if (!isReturning) {
                    VStack {
                        Text("Departed.")
                        Button(action: {
                            isReturning = true
                        }) {
                            Text("Return")
                        }
                    }
                } else {
                    VStack {
                        Stepper("Available Seats: \(availableSeatsInput)", value: $availableSeatsInput, in: 0...6)
                                            .padding()

                        HStack {
                            Button(action: {
                                isReturning = false
                                
                            }) {
                                Text("Cancel")
                                    .padding()
                                    .background(Color.gray) // Set your desired background color
                                    .foregroundColor(.white) // Set text color for better contrast
                                    .cornerRadius(10) // Apply corner radius for rounded corners
                            }
                            
                            Button(action: {
                                // Handle the return and available seats input here
                                handleReturn(availableSeats: availableSeatsInput)
                            }) {
                                Text("Confirm Return")
                                    .padding()
                                    .background(Color.green) // Set your desired background color
                                    .foregroundColor(.white) // Set text color for better contrast
                                    .cornerRadius(10) // Apply corner radius for rounded corners
                            }

                        }
                    }
                    .padding()
                }
            }
            
            ScrollView {
                Text("North Rider Manifest").font(.subheadline)
                ForEach(Array(dailyViewModel.filterRiders(locationFilter: "north")), id: \.key) { (userID, userData) in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(userData["name"] as? String ?? "?")")
                        Text("Location: \(userData["location"] as? String ?? "?")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                Text("Rand Rider Manifest").font(.subheadline)
                ForEach(Array(dailyViewModel.filterRiders(locationFilter: "rand")), id: \.key) { (userID, userData) in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(userData["name"] as? String ?? "?")")
                        Text("Location: \(userData["location"] as? String ?? "?")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                    .cornerRadius(10)
                }
                
                Group {
                    Spacer()
                    
                    Text("North Drivers").font(.subheadline)
                    ForEach(Array(dailyViewModel.filterDrivers(locationFilter: "north")), id: \.key) { (userID, userData) in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(userData["name"] as? String ?? "?")")
                            Text("Location: \(userData["location"] as? String ?? "?")")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Text("Rand Drivers").font(.subheadline)
                    ForEach(Array(dailyViewModel.filterDrivers(locationFilter: "rand")), id: \.key) { (userID, userData) in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(userData["name"] as? String ?? "?")")
                            Text("Location: \(userData["location"] as? String ?? "?")")
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
    }
    
    private func handleReturn(availableSeats: Int) {
        print("returning!")
        carOffset = .zero
        isReturning = false
        isDeparted = false
        squishScale = 1
        squishOffset = .zero
        
        let leftRef = Database.database().reference().child("Daily-Practice").child(thisDriver.location)
            .child(thisDriver.id).child("isDeparted")
        leftRef.setValue(false)
    }
    
    private func handleDeparture() {
        print("leaving!")
        let leftRef = Database.database().reference().child("Daily-Practice").child(thisDriver.location)
            .child(thisDriver.id).child("isDeparted")
        leftRef.setValue(true)
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView(thisDriver: Driver(id: "tmp", name: "tmp", location: "tmp", seats: 4,
                                      filledSeats: 0, preference: "tmp", isDeparted: false))
    }
}

struct ArrowView: View {
    @State private var swipeOffset: CGFloat = .zero

    var body: some View {
        Image(systemName: "arrow.right.circle.fill")
            .font(.system(size: 20))
            .foregroundColor(.green)
            .opacity(0.8)
            .offset(x: swipeOffset)
            .onAppear {
                withAnimation(Animation.easeIn(duration: 0.4).repeatForever(autoreverses: true).delay(2)) {
                    swipeOffset = -6
                }
            }
    }
}

struct SmokeParticle: View {
    @State private var opacity: Double = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        Circle()
            .foregroundColor(Color.gray.opacity(opacity))
            .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
            .offset(offset)
            .onAppear {
                withAnimation(Animation.easeOut(duration: 0.5)) {
                    opacity = 0
                    offset = CGSize(width: CGFloat.random(in: -50...50), height: CGFloat.random(in: -50...50))
                }
            }
    }
}

