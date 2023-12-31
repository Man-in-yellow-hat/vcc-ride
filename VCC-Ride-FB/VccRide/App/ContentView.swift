import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = MainViewModel.shared

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
            
            // DASHBOARD with swipeable views
            if viewModel.userRole == "admin" {
                AdminDashboardView()
                    .tabItem {
                        Label("DASHBOARD", systemImage: "house")
                    }
                    .tag("DASHBOARD")
            } else if viewModel.userRole == "driver" {
                LoadDriverView()
                    .tabItem {
                        Label("DASHBOARD", systemImage: "house")
                    }
                    .tag("DASHBOARD")
            } else {
                LoadRiderView()
                    .tabItem {
                        Label("DASHBOARD", systemImage: "house")
                    }
                    .tag("DASHBOARD")
            }
            
            
            // Settings View
            SettingsView(role: viewModel.userRole ?? "rider")
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


struct AdminDashboardView: View {
    @State private var selectedTabIndex = 1 // Start with the Admin dashboard

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            LoadDriverView()
                .tag(0)
            
            LoadAdminView()
                .tag(1) // Admin dashboard comes second and is selected by default
            
            RiderView() // Let's just look at all drivers, if we are an admin we are also a driver but can't be a rider.
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}


// Other views like DriverDashboardView, RiderDashboardView, etc. can be similar with navigation links/buttons.

// Define SettingsView, CalendarView, PeopleView, StatsView, AdminDashboardView, etc. based on your requirements.




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
