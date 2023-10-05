//
//  User.swift
//  VCC Ride
//
//  Created by Karen Pu on 10/4/23.
//

import Foundation

struct User: Identifiable, Codable {
    var id: UUID
    var active: Bool
    var admin: Bool
    var default_location: String
    var email: String
    var role: String
}
