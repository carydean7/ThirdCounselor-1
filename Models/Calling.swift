//
//  Calling.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Calling: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var callingName: String
    var memberName: String
    var callIsFilled: Bool

    enum CodingKeys: String, CodingKey {
        case uid
        case callingName
        case memberName
        case callIsFilled
    }
}
