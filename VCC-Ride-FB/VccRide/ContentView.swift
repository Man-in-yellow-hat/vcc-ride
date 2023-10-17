import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var selectedNavBarTab = "DASHBOARD" // Start with the "DASHBOARD" tab selected

    var body: some View {
        TabView(selection: $selectedNavBarTab) {
            // People view based on user role
            if viewModel.userRole == "admin" {
                AdminPeopleView()
                    .tabItem {
                        Label("People", systemImage: "person.2")
                    }
                    .tag("People")
            }
            
            if viewModel.userRole == "admin" {
                AdminCalendar()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag("AdminCalendar")
            } else {
                // Calendar view
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag("Calendar")
            }
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag("Stats")
            
            
//            if viewModel.userRole == "rider" {
//                RiderSettingsView()
//                    .tabItem {
//                        Label("Calendar", systemImage: "calendar")
//                    }
//                    .tag("AdminCalendar")
//            } else {
//                // Calendar view
//                CalendarView()
//                    .tabItem {
//                        Label("Calendar", systemImage: "calendar")
//                    }
//                    .tag("Calendar")
//            }
            
            // DASHBOARD with swipeable views
            DashboardView()
                .tabItem {
                    Label("DASHBOARD", systemImage: "house")
                }
                .tag("DASHBOARD")
            
            PeopleView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Users", systemImage: "person.3")
                }
                .tag("Users")
            
            // Settings View
            SettingsMainView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag("Settings")
            
            
            
            // Stats view based on user role
            if viewModel.userRole == "admin" {
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.doc.horizontal")
                    }
                    .tag("Stats")
            }
        }
        .onAppear {
            selectedNavBarTab = "DASHBOARD" // Set the initial selection to "DASHBOARD"
        }
    }
}


struct DashboardView: View {
    @State private var selectedTabIndex = 1 // Start with the Admin dashboard

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            DriverView()
                .tag(0)
            
            AdminView()
                .tag(1) // Admin dashboard comes second and is selected by default
            
            RiderView()
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

// Other views like DriverDashboardView, RiderDashboardView, etc. can be similar with navigation links/buttons.

// Define SettingsView, CalendarView, PeopleView, StatsView, AdminDashboardView, etc. based on your requirements.




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MainViewModel())
    }
}
