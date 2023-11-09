//
//  Stake.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/14/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Stake: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var stakeName: String
    var stakeUnitNumber: String
    var units: [Unit]

    enum CodingKeys: String, CodingKey {
        case uid
        case stakeName
        case stakeUnitNumber
        case units
    }
}

struct Unit: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var stakeUnitNumber: String
    var unitName: String
    var unitNumber: String

    enum CodingKeys: String, CodingKey {
        case uid
        case stakeUnitNumber
        case unitName
        case unitNumber
    }
}
