//
//  Organization.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Organization: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
    }
}
