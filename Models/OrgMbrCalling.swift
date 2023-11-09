//
//  MbrOrgCalling.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import FirebaseFirestoreSwift

struct OrgMbrCalling: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    
    var uid: String = ""
    var callingName: String = ""
    var organizationName: String = ""
    var memberName: String = ""
    var memberToBeReleased: String = ""
    var approvedDate: String = ""
    var calledDate: String = ""
    var sustainedDate: String = ""
    var setApartDate: String = ""
    var releasedDate: String = ""
    var recommendedDate: String = ""
    var ldrAssignToCall: String = ""
    var ldrAssignToSetApart: String = ""
    var callingPreviouslyFilledDate: String = ""
    var callingDisplayIndex: String = ""
    var callingAction: String = ""
    var recommendations: String = ""
    
    enum CodingKeys: String, CodingKey {
        case uid
        case callingName
        case organizationName
        case memberName
        case memberToBeReleased
        case approvedDate
        case calledDate
        case sustainedDate
        case setApartDate
        case releasedDate
        case recommendedDate
        case ldrAssignToCall
        case ldrAssignToSetApart
        case callingPreviouslyFilledDate
        case callingDisplayIndex
        case callingAction
        case recommendations
    }
}
