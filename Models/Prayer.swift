//
//  Prayer.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/24/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Prayer: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    var date: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case date
        case type
    }
}
