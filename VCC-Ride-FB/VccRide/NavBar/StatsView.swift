//
//  StatsView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI
import Firebase

struct StatsView: View {
    @ObservedObject private var statsViewModel = StatsViewModel()

    var body: some View {
        VStack(spacing: 80) {
            DriverStatsSection(driverStats: statsViewModel.driverStats)
            RiderStatsSection(riderStats: statsViewModel.riderStats)
        }
        .onAppear {
            statsViewModel.fetchStats()
        }
    }
}

struct DriverStatsSection: View {
    let driverStats: [String: Int]?

    var body: some View {
        Group {
            if let driverStats = driverStats, !driverStats.isEmpty {
                VStack {
                    Text("Driver Stats").font(.title)
                    ForEach(driverStats.sorted(by: { $0.value > $1.value }), id: \.key) { (userID, count) in
                        Text("Driver: \(userID), Practices Attended: \(count)")
                    }
                }
            } else {
                Text("No Driver Stats Available")
            }
        }
    }
}

struct RiderStatsSection: View {
    let riderStats: [String: Int]?

    var body: some View {
        Group {
            if let riderStats = riderStats, !riderStats.isEmpty {
                VStack {
                    Text("Rider Stats").font(.title)
                    ForEach(riderStats.sorted(by: { $0.value > $1.value }), id: \.key) { (userID, count) in
                        Text("Rider: \(userID), Practices Attended: \(count)")
                    }
                }
            } else {
                Text("No Rider Stats Available")
            }
        }
    }
}


class StatsViewModel: ObservableObject {
    @Published var driverStats: [String: Int]?
    @Published var riderStats: [String: Int]?

    func fetchStats() {
        let ref = Database.database().reference().child("Fall23-Stats")

        // Fetch driver-stats
        ref.child("driver-stats").observeSingleEvent(of: .value) { snapshot in
            if let driverStatsDict = snapshot.value as? [String: Int] {
                self.driverStats = driverStatsDict
            } else {
                self.driverStats = [:] // Set to an empty dictionary if no data or incorrect format
            }
        }

        // Fetch rider-stats
        ref.child("rider-stats").observeSingleEvent(of: .value) { snapshot in
            if let riderStatsDict = snapshot.value as? [String: Int] {
                self.riderStats = riderStatsDict
            } else {
                self.riderStats = [:] // Set to an empty dictionary if no data or incorrect format
            }
        }
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
