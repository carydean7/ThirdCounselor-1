//
//  Member.swift
//  LMC_Tracker
//
//  Created by Dean Wagstaff on 12/8/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Member: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    var welcomed: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case welcomed
    }
}
