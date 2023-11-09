//
//  RecommendedCallingChanges.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/22/23.
//

import Foundation

struct RecommendedCallingChanges: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var organizationName: String
    var callingName: String
    var memberName: String
    var recommendations: [Recommendation]

    enum CodingKeys: String, CodingKey {
        case uid
        case organizationName
        case callingName
        case memberName
        case recommendations
    }
}

struct Recommendation: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString

    var uid: String
    var selectionIndex: Int
    var member: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case selectionIndex
        case member
    }
}

