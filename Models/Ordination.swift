//
//  Ordination.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/30/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Ordination: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    var ordinationOffice: String
    var status: String
    var datePerformed: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case ordinationOffice
        case status
        case datePerformed
    }
}
