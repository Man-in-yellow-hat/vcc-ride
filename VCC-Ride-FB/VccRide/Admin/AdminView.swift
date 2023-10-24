import SwiftUI

enum ContentItem {
    case text(String)
    case image(systemName: String)
    case combined(imageSystemName: String, value: Int)
}

//TEMP DATA TO BE REFERENCED BY DB
let name = "[Admin Name]"
let nextPracticeDate = "December 25th"
let ridersConfirmedNorth = 15
let ridersDeclinedNorth = 17
let ridersUnknownNorth = 9
let seatsNorth = 14
let ridersConfirmedBranscomb = 10
let ridersDeclinedBranscomb = 9
let ridersUnknownBranscomb = 10
let seatsBranscomb = 13

enum Status {
    case extra, ok, warn, bad, fail
}

struct AdminView: View {
    
    @State private var assignDrivers = AssignDrivers() // Create an instance of AssignDrivers
    @State private var selectedRole = "Any"
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State private var filteredUsers: [String: [String: Any]] = [:] // Replace with appropriate data structure
    @State private var isViewAppeared = false
    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users

    @State private var textFieldsData: [[ContentItem]] = [
        [.text("North"), .combined(imageSystemName: "person.fill.checkmark", value: ridersConfirmedNorth), .combined(imageSystemName: "person.fill.xmark", value: ridersDeclinedNorth), .combined(imageSystemName: "person.fill.questionmark", value: ridersUnknownNorth), .combined(imageSystemName: "figure.seated.side", value: seatsNorth)],
        [.text("Branscomb"), .combined(imageSystemName: "person.fill.checkmark", value: ridersConfirmedBranscomb), .combined(imageSystemName: "person.fill.xmark", value: ridersDeclinedBranscomb), .combined(imageSystemName: "person.fill.questionmark", value: ridersUnknownBranscomb), .combined(imageSystemName: "figure.seated.side", value: seatsBranscomb)],
    ]
    
    
    @State public var randStatus: Status = Status.ok
    @State public var northStatus: Status = Status.ok
    
    var body: some View {
        VStack {
            // Title and Subtitle
            Text("Welcome, \(name)").font(.headline)
            Text("Next Practice Date: \(nextPracticeDate)").font(.subheadline)
                .padding(.bottom)
            
            HStack(spacing: 20) {
                ForEach(0..<2) { boxIndex in
                    BoxWithTexts(contents: textFieldsData[boxIndex])
                        .frame(width: 150, height: 200)
                }
            }
            .padding()
            
            // Add the new subtitle here
            Text("Quick Actions")
                .font(.subheadline)
                .padding(.bottom, 3.0)
            
            GeometryReader { geometry in
                let totalHorizontalPadding: CGFloat = 40.0
                let availableWidth = geometry.size.width - totalHorizontalPadding - 40.0
                let buttonWidth = availableWidth / 3
                
                HStack(spacing: 20) {
                    ButtonShroud(title: "Assign Drivers", action: {
                        print("assigning drivers!")
                        assignDrivers.assignNoPrefDrivers()
                    })
                    .frame(width: buttonWidth, height: 70)
                    
                    ButtonShroud(title: "Send Practice Reminder", action: {
                        //button action goes here
                    })
                    .frame(width: buttonWidth, height: 70)
                    
                    ButtonShroud(title: "Confirm Attendance", action: {
                        //button action goes here
                    })
                    .frame(width: buttonWidth, height: 70)
                }
                .padding(.horizontal, 20)
            }
            
            // Role Picker
            HStack {
                Text("Quick User View:")
                    .font(.subheadline)
                    .padding(.top, -105)
                Spacer()
                Picker("", selection: $selectedRole) {
                    Text("Any").tag("Any")
                    Text("Rider").tag("rider")
                    Text("Driver").tag("driver")
                    Text("Admin").tag("admin")
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedRole) { _ in
                    applyFilters()
                }
                .padding(.top, -115)
            }
            .padding(.horizontal)

            .padding(.bottom, 2)
            
            ScrollView {
                            ForEach(Array(filteredUsers), id: \.key) { (userID, userData) in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Email: \(userData["email"] as? String ?? "")")
                                    Text("Role: \(userData["role"] as? String ?? "")")

                                    Text("Location: \(userData["default_location"] as? String ?? "")")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.4))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, -85)  // Adjusted padding for ScrollView
                        .padding(.horizontal, 20) // Add horizontal padding to the ScrollView
                    }
                    .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)) // Add margins on the sides
                    .onAppear {
        }
        .onAppear {
            if !isViewAppeared {
                isViewAppeared = true
                userViewModel.fetchUsers {
                    applyFilters() // Apply filters once data is fetched
                }
            }
        }
    }

    
    private func applyFilters() {
        filteredUsers = userViewModel.filterUsers(
            roleFilter: selectedRole,
            activeFilter: isActive,
            locationFilter: selectedLocation
        )
    }
}



struct ButtonShroud: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20))
                .minimumScaleFactor(0.5)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 70) // Ensure a minimum and maximum height
                .background(Color(red: 1.0, green: 0.84, blue: 0.3).opacity(0.5))
                .cornerRadius(10)
        }
    }
}




struct BoxWithTexts: View {
    var contents: [ContentItem]
    
    var boxColor: Color {
        // Check the first content item if it's "North" or "Branscomb"
        if case .text(let location) = contents[0] {
            switch location {
                case "North":
                    return ridersConfirmedNorth > seatsNorth ? Color.red.opacity(0.5) : Color.green.opacity(0.5)
                case "Branscomb":
                    return ridersConfirmedBranscomb > seatsBranscomb ? Color.red.opacity(0.5) : Color.green.opacity(0.5)
                default:
                    return Color.gray.opacity(0.2) // Default color
            }
        } else {
            return Color.gray.opacity(0.2) // Default color
        }
    }


    var body: some View {
        ZStack {
            Rectangle()
                .fill(boxColor)
                .cornerRadius(10)

            VStack {
                ForEach(0..<contents.count) { idx in
                    switch contents[idx] {
                    case .text(let textString):
                        Text(textString)
                            .padding(5)
                            .background(idx == 0 ? Color.clear : Color.gray.opacity(0.05))
                            .cornerRadius(5)
                            .bold(if: idx == 0)
                            
                    case .image(let systemName):
                        Image(systemName: systemName)
                            .padding(5)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            
                    case .combined(let systemName, let value):
                        HStack {
                            Image(systemName: systemName)
                            Text("\(value)")
                        }
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    }
                }
            }
            .padding()
        }
    }
}




extension View {
    @ViewBuilder
    func bold(if condition: Bool) -> some View {
        if condition {
            self.bold()
        } else {
            self
        }
    }
}
    
struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
