import SwiftUI

enum ContentItem {
    case text(String)
    case image(systemName: String)
    case combined(imageSystemName: String, value: Int)
}

enum Status {
    case extra, ok, warn, bad, fail
}

struct AdminView: View {
    @ObservedObject private var dailyViewModel = DailyViewModel.shared
    @State private var selectedRole = "Any"
    @State private var selectedLocation = "Any"
    @State private var isActive = "Any"
    @State private var isViewAppeared = false
    @State private var assignDriversSheet = false
    @ObservedObject private var userViewModel = UserViewModel() // Assuming you have a UserViewModel to fetch and filter users
    
    @StateObject private var practiceDateViewModel = PracticeDateViewModel(dateFetcher: FirebaseDateFetcher())

    @State private var textFieldsData: [[ContentItem]] = [
        [.text("North"), .combined(imageSystemName: "person.3.sequence.fill", value: 0), .combined(imageSystemName: "chair.lounge.fill", value: 0), .combined(imageSystemName: "figure.seated.seatbelt", value: 0)],
        [.text("Rand"), .combined(imageSystemName: "person.3.sequence.fill", value: 0), .combined(imageSystemName: "chair.lounge.fill", value: 0), .combined(imageSystemName: "figure.seated.seatbelt", value: 0)],
    ]
    
    @State public var randStatus: Status = Status.ok
    @State public var northStatus: Status = Status.ok
    
    var body: some View {
        ScrollView {
            // Title and Subtitle
            Text("Welcome, \(userViewModel.userName)").font(.headline)
            Text("Next Practice Date: \(dailyViewModel.date)").font(.subheadline)
                .padding(.bottom)
            
            VStack(spacing: 20) {
                ForEach(0..<2) { boxIndex in
                    BoxWithTexts(contents: textFieldsData[boxIndex])
//                        .frame(width: 150, height: 200)
                }
            }
            .padding()
            
            // Add the new subtitle here
            Text("Quick Actions")
                .font(.subheadline)
                .padding(.bottom, 3.0)

            HStack(spacing: 20) {

                ButtonShroud(title: "Assign Drivers", action: {
                    print("assigning drivers!")
                    assignDriversSheet.toggle()
//                    dailyViewModel.assignDrivers()
                })
                .sheet(isPresented: $assignDriversSheet) {
                    ListDriversView()
                }
                
                ButtonShroud(title: "Send Practice Reminder", action: {
                    //button action goes here
                })
                
                ButtonShroud(title: "Confirm Attendance", action: {
                    //button action goes here
                })
            }
            .padding(.horizontal, 20)

            
            
            ButtonShroud(title: "Update Daily Practice", action: {
                print("updating daily practice!")
                practiceDateViewModel.transferPracticeDates()
            })
            .padding(.horizontal, 20)
        }
            .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)) // Add margins on the sides
            .onAppear {
        }
        .onAppear {
            userViewModel.fetchUserFeatures()
            if !isViewAppeared {
                dailyViewModel.assignDrivers() // TODO: CHECK THIS IF SHOULD BE MOVED
                isViewAppeared = true
            }
            updateTextFieldsData()
        }
        .onChange(of: [
            dailyViewModel.numNorthRequested,
            dailyViewModel.numNorthOffered,
            dailyViewModel.numRandRequested,
            dailyViewModel.numRandOffered,
            dailyViewModel.numNorthFilled,
            dailyViewModel.numRandFilled
        ]) { _ in
            // Update textFieldsData when any of the observed properties change
            updateTextFieldsData()
        }
    }
    
    private func updateTextFieldsData() {
        textFieldsData = [
            [.text("North"), .combined(imageSystemName: "person.3.sequence.fill", value: dailyViewModel.numNorthRequested), .combined(imageSystemName: "chair.lounge.fill", value: dailyViewModel.numNorthOffered), .combined(imageSystemName: "figure.seated.seatbelt", value: dailyViewModel.numNorthFilled)],
            [.text("Rand"), .combined(imageSystemName: "person.3.sequence.fill", value: dailyViewModel.numRandRequested), .combined(imageSystemName: "chair.lounge.fill", value: dailyViewModel.numRandOffered), .combined(imageSystemName: "figure.seated.seatbelt", value: dailyViewModel.numRandFilled)],
        ]
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
    let dailyViewModel = DailyViewModel.shared
    
    var boxColor: Color {
        // Check the first content item if it's "North" or "Branscomb"
        if case .text(let location) = contents[0] {
            switch location {
                case "North":
                    return dailyViewModel.numNorthRequested > dailyViewModel.numNorthOffered ? Color.red.opacity(0.5) : Color.green.opacity(0.5)
                case "Rand":
                    return dailyViewModel.numRandRequested > dailyViewModel.numRandOffered ? Color.red.opacity(0.5) : Color.green.opacity(0.5)
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
