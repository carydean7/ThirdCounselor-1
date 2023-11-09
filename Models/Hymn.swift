//
//  Hymn.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/7/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Hymn: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var title: String
    var number: String

    enum CodingKeys: String, CodingKey {
        case uid
        case title
        case number
    }
}
