//
//  Notes.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 5/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Note: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    
    var uid: String
    var content: String
    var leader: String

    enum CodingKeys: String, CodingKey {
        case uid
        case content
        case leader
    }
}
