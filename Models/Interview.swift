//
//  InterviewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/13/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Interview: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var name: String
    var ldrAssignToDoInterview: String
    var scheduledInterviewDate: String
    var scheduledInterviewTime: String
    var notes: String
    var details: String
    var ordination: String
    var status: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case ldrAssignToDoInterview
        case scheduledInterviewDate
        case scheduledInterviewTime
        case notes
        case details
        case ordination
        case status
        case category
    }
}

struct InterviewDetails: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String
    var parsedInterviewType: String
    var description: String
    var category: String
    var authorizedLeader: String
    var showOffice: Bool
    var priesthood: String
    var office: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case parsedInterviewType
        case description
        case category
        case authorizedLeader
        case showOffice
        case priesthood
        case office
    }
}
