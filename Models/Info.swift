//
//  Info.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/28/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Info: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var screen: String
    var instructions: String
    var functions: [Function]

    enum CodingKeys: String, CodingKey {
        case uid
        case screen
        case instructions
        case functions
    }
}

struct Function: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    var topic: String
    var steps: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case topic
        case steps
    }
}
