//
//  SpeakingAssignmentModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/27/22.
//

import Foundation
import FirebaseFirestoreSwift

struct SpeakingAssignment: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    var topic: String
    var askToSpeakOnDate: String
    var weekOfYear: String
    var weekNumberInMonthForSunday: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case topic
        case askToSpeakOnDate
        case weekOfYear
        case weekNumberInMonthForSunday
    }
}
