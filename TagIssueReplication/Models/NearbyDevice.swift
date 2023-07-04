//
//  NearbyDevice.swift
//  TagIssueReplication
//
//  Created by Saroj Maharjan on 02/07/2023.
//

import Foundation

struct NearbyDevice: Codable, Identifiable {
    let id: UUID
    let fullName: String
    let lattitude, longitude: Double
    let profilePicture: String?
}
