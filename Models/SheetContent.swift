//
//  SheetContent.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 11/14/23.
//

import Foundation
import FirebaseFirestoreSwift

struct SheetContent: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var presiding: String
    var conductor: String
    var accompanist: String
    var openingHymn: String
    var closingHymn: String
    var sacramentHymn: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case presiding
        case conductor
        case accompanist
        case openingHymn
        case closingHymn
        case sacramentHymn
    }
}
