//
//  Assignments.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 5/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Assignment: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var organizationName: String
    var callingName: String
    var memberName: String
    var actionType: Int

    enum CodingKeys: String, CodingKey {
        case uid
        case organizationName
        case callingName
        case memberName
        case actionType
    }
}
