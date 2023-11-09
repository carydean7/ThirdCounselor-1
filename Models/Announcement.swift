//
//  Announcement.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 11/3/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Announcement: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var fyi: String
    var announced: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case fyi
        case announced
    }
}
