//
//  Item.swift
//  VCC Ride
//
//  Created by Aman Momin on 10/3/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
