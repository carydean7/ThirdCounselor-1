//
//  DataManager.swift
//  LMC_Tracker
//
//  Created by Dean Wagstaff on 12/8/21.
//

import Foundation
import CoreData
import FirebaseCore
import FirebaseFirestore
import UIKit

typealias JSONDictionary = [String: Any]

class DataManager: NSObject, ObservableObject {
    var recommendationsForApproval = [OrgMbrCalling]()
    var callsToBeExtended = [OrgMbrCalling]()
    var toBeSustained = [OrgMbrCalling]()
    var settingAparts = [OrgMbrCalling]()
    var membersNeedingToBeReleased = [OrgMbrCalling]()
    var noOutstandingActionsLabelIsHidden = false
    var actionsTableViewIsHidden = true
    var actionsTableViewAlphaOne = false
    var shouldAnimate = true
    var actionsTableViewReloadData = false
    var sectionsNotFound = [String]()
    
    // MARK: - Properties
    private(set) var membersEntity: [MembersEntity] = []
    
    static let shared = DataManager()
    
    func formatDateString(date: String) -> String {
        let year = date.suffix(2)
        let dayMonth = date.prefix(6)
        
        let formattedDate = String(dayMonth) + String(year)
        
        return formattedDate
    }
    
    // MARK: - Data Type Conversion Functions - Entities -> Models
    
    func convertArrayOfMemberEntitiesToMemberModels(entities: [MembersEntity]) -> [Member] {
        var memberModels = [Member]()
        
        for entity in entities {
            memberModels.append(Member(id: UUID().uuidString, uid: entity.uid ?? "", name: entity.name ?? "", welcomed: entity.welcomed ?? ""))
        }
        
        return memberModels
    }
    
    func convertArrayOfAnnouncementsEntitiesToAnnouncementModels(entities: [AnnouncementsEntity]) -> [Announcement] {
        var announcementModels = [Announcement]()
        
        for entity in entities {
            announcementModels.append(Announcement(id: UUID().uuidString, uid: entity.uid ?? "", fyi: entity.fyi ?? "", announced: entity.announced ?? ""))
        }
        
        return announcementModels
    }
    
    func convertArrayOfOrganizationEntitiesToOrganizationModels(entities: [OrganizationsEntity]) -> [Organization] {
        var organizationModels = [Organization]()
        
        for entity in entities {
            organizationModels.append(Organization(id: UUID().uuidString, uid: entity.uid ?? "", name: entity.name ?? ""))
        }
        
        return organizationModels
    }
    
    @MainActor func convertArrayOfStakeEntitiesToStakeModels(entities: [StakeEntity]) -> [Stake] {
        var stakeModels = [Stake]()
        
        for entity in entities {
            if let uid = entity.uid, let stakeName = entity.stakeName, let stakeUnitNumber = entity.stakeUnitNumber, let units = entity.units {
                stakeModels.append(Stake(uid: uid,
                                        stakeName: stakeName,
                                        stakeUnitNumber: stakeUnitNumber,
                                        units: convertUnitsStringToArrayOfUnits(unitsString: units, for: stakeUnitNumber)))
            }
        }
        
        return stakeModels
    }
    
    func convertArrayOfSpeakingAssignmentsEntityToSpeakingAssignmentsModels(entities: [SpeakingAssignmentsEntity]) -> [SpeakingAssignment] {
        var speakingAssignmentModels = [SpeakingAssignment]()
        
        for entity in entities {
            if let name = entity.name, let topic = entity.topic, let askToSpeakOnDate = entity.askToSpeakOnDate, let weekOfYear = entity.weekOfYear, let weekNumberInMonthForSunday = entity.weekNumberInMonthForSunday {
                let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                speakingAssignmentModels.append(SpeakingAssignment(id: id, uid: id, name: name, topic: topic, askToSpeakOnDate: askToSpeakOnDate, weekOfYear: weekOfYear, weekNumberInMonthForSunday: weekNumberInMonthForSunday))
            }
        }
        
        return speakingAssignmentModels
    }
    
    func convertArrayOfCallingEntitiesToCallingModels(entities: [CallingsEntity]) -> [Calling] {
        var callingModels = [Calling]()
        
        for entity in entities {
            callingModels.append(Calling(id: UUID().uuidString, uid: entity.uid ?? "", callingName: entity.callingName ?? "", memberName: entity.memberName ?? "", callIsFilled: entity.callIsFilled))
        }
        
        return callingModels
    }
    
    func convertArrayOfInterviewEntityToInterviewModel(entities: [InterviewsEntity]) -> [Interview] {
        var models = [Interview]()
        
        for entity in entities {
            if let uid = entity.uid,
               let name = entity.name,
               let ldrAssignToDoInterview = entity.ldrAssignToDoInterview,
               let scheduledInterviewDate = entity.scheduledInterviewDate,
               let scheduledInterviewTime = entity.scheduledInterviewTime,
               let notes = entity.notes,
               let details = entity.details,
               let ordination = entity.ordination,
               let status = entity.status,
               let category = entity.category {
                models.append(Interview(id: uid,
                                        uid: uid,
                                        name: name,
                                        ldrAssignToDoInterview: ldrAssignToDoInterview,
                                        scheduledInterviewDate: scheduledInterviewDate,
                                        scheduledInterviewTime: scheduledInterviewTime,
                                        notes: notes,
                                        details: details,
                                        ordination: ordination,
                                        status: status,
                                        category: category))
            }
        }
        
        return models
    }
    
    func convertArrayOfOrgMbrCallingEntitiesToCallingModels(entities: [OrgMbrCallingEntity]) -> [OrgMbrCalling] {
        var orgMbrCallings = [OrgMbrCalling]()
        
        for entity in entities {
            orgMbrCallings.append(OrgMbrCalling(uid: entity.uid ?? "",
                                                callingName: entity.callingName ?? "",
                                                organizationName: entity.organizationName ?? "",
                                                memberName: entity.memberName ?? "",
                                                memberToBeReleased: entity.memberToBeReleased ?? "",
                                                approvedDate: entity.approvedDate ?? "",
                                                calledDate: entity.calledDate ?? "",
                                                sustainedDate: entity.sustainedDate ?? "",
                                                setApartDate: entity.setApartDate ?? "",
                                                releasedDate: entity.releasedDate ?? "",
                                                recommendedDate: entity.recommendedDate ?? "",
                                                ldrAssignToCall: entity.ldrAssignToCall ?? "",
                                                ldrAssignToSetApart: entity.ldrAssignToSetApart ?? "",
                                                callingPreviouslyFilledDate: entity.callingPreviouslyFilledDate ?? "",
                                                callingDisplayIndex: entity.callingDisplayIndex ?? "",
                                                callingAction: entity.callingAction ?? "",
                                                recommendations: entity.recommendations ?? ""))
        }
        
        return orgMbrCallings
    }
    
    
    func countOf(char: Character, in str: String) -> Int {
        var count = 0
        
        for charInStr in str {
            if charInStr == char {
                count += 1
            }
        }
        
        return count
    }
    
    @MainActor func convertArrayOfUnitsToDeliniatedString(units: [Unit]) -> String {
        var unitsString = ""
        
        for (index, unit) in units.enumerated() {
                if index == (units.count - 1) {
                    unitsString += unit.unitName + ":" + unit.unitNumber + "|"
                } else {
                    unitsString += unit.unitName + ":" + unit.unitNumber + "|"
                }
        }
        
        return unitsString
    }
    
    @MainActor func convertUnitsStringToArrayOfUnits(unitsString: String, for stkUnitNumber: String) -> [Unit] {
        let count = countOf(char: ":", in: unitsString)
        var units = [Unit]()
        var unitNumber = ""
        var unitName = ""
        
        var str = unitsString
        
        for _ in 0..<count {
            if let index = str.firstIndex(of: ":") {
                if let pipeIndex = str.firstIndex(of: "|") {
                    unitName = String(str[..<index])
                    
                    let indexOffset = str.index(index, offsetBy: 1)

                    unitNumber = String(str[indexOffset..<pipeIndex])
                    
                    units.append(Unit(uid: UUID().uuidString, stakeUnitNumber: stkUnitNumber, unitName: unitName, unitNumber: unitNumber))
                    
                    let nxtIdx = str.index(pipeIndex, offsetBy: 1)
                    
                    if nxtIdx < str.index(before: str.endIndex) {
                        let range = nxtIdx...str.index(before: str.endIndex)
                        
                        let subStr = str[range]
                        
                        str = String(subStr)
                    }
                }
            }
        }
        
        return  units
    }
    
    @MainActor func convertRecommendationsStringToArrayOfRecommendations(recommendationsString: String) -> [Recommendation] {
        let count = countOf(char: ":", in: recommendationsString)
        var recommendations = [Recommendation]()
        
        var str = recommendationsString
        
        for i in 0..<count {
            if let index = str.firstIndex(of: ":") {
                recommendations.append(Recommendation(uid: UUID().uuidString, selectionIndex: i, member: String(str[..<index])))
                
                let nxtIdx = str.index(index, offsetBy: 1)
                let range = nxtIdx..<str.index(before: str.endIndex)
                
                let subStr = str[range]
                
                str = String(subStr)
                
                if let index = str.firstIndex(of: ":") {}
                else {
                    if String(str).count > 3 {
                        recommendations.append(Recommendation(uid: UUID().uuidString, selectionIndex: i, member: String(str)))
                    }
                }
            }
        }
        
        if !OrgMbrCallingViewModel.shared.recommendations.isEmpty {
            OrgMbrCallingViewModel.shared.recommendations.removeAll()
        }
        
        OrgMbrCallingViewModel.shared.recommendations = recommendations
        
        return  recommendations
    }
    
    // MARK: - Data Type Conversion Functions - Models -> Coredata Dictionaries
    
    func convertMemberModelToDictionary(model: Member) -> [String: Any] {
        [DictionaryKeys.uid.rawValue: model.id ?? "",
         DictionaryKeys.name.rawValue: model.name,
         DictionaryKeys.welcomed.rawValue: model.welcomed
        ]
    }
    
    func convertAnnouncementModelToDictionary(model: Announcement) -> [String: Any] {
        [DictionaryKeys.uid.rawValue: model.id ?? "",
         DictionaryKeys.fyi.rawValue: model.fyi,
         DictionaryKeys.announced.rawValue: model.announced
        ]
    }

    func convertArrayOfOrgMbrCallingsToDictionary(models: [OrgMbrCalling]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id ?? "",
                                 DictionaryKeys.callingName.rawValue: model.callingName,
                                 DictionaryKeys.organizationName.rawValue: model.organizationName,
                                 DictionaryKeys.memberName.rawValue: model.memberName,
                                 DictionaryKeys.memberToBeReleased.rawValue: model.memberToBeReleased,
                                 DictionaryKeys.approvedDate.rawValue: model.approvedDate,
                                 DictionaryKeys.calledDate.rawValue: model.calledDate,
                                 DictionaryKeys.sustainedDate.rawValue: model.sustainedDate,
                                 DictionaryKeys.setApartDate.rawValue: model.setApartDate,
                                 DictionaryKeys.releasedDate.rawValue: model.releasedDate,
                                 DictionaryKeys.recommendedDate.rawValue: model.recommendedDate,
                                 DictionaryKeys.ldrAssignToCall.rawValue: model.ldrAssignToCall,
                                 DictionaryKeys.ldrAssignToSetApart.rawValue: model.ldrAssignToSetApart,
                                 DictionaryKeys.callingPreviouslyFilledDate.rawValue: model.callingPreviouslyFilledDate,
                                 DictionaryKeys.callingDisplayIndex.rawValue: model.callingDisplayIndex,
                                 DictionaryKeys.callingAction.rawValue: model.callingAction,
                                 DictionaryKeys.recommendations.rawValue: model.recommendations])
        }
        
        return dictionaries
    }
    
    func convertInterviewModelToDictionary(model: Interview) -> [String: Any] {
        [DictionaryKeys.uid.rawValue: model.id ?? "",
         DictionaryKeys.name.rawValue: model.name,
         DictionaryKeys.notes.rawValue: model.notes,
         DictionaryKeys.ldrAssignToDoInterview.rawValue: model.ldrAssignToDoInterview,
         DictionaryKeys.details.rawValue: model.details,
         DictionaryKeys.scheduledInterviewDate.rawValue: model.scheduledInterviewDate,
         DictionaryKeys.scheduledInterviewTime.rawValue: model.scheduledInterviewTime,
         DictionaryKeys.status.rawValue: model.status,
         DictionaryKeys.ordination.rawValue: model.ordination]
    }
    
    
    func convertArrayOfMembersModelsToDictionaries(models: [Member]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id ?? "", DictionaryKeys.name.rawValue: model.name])
        }
        
        return dictionaries
    }
    
    func convertArrayOfOrganizationsModelsToDictionaries(models: [Organization]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id ?? "", DictionaryKeys.name.rawValue: model.name])
        }
        
        return dictionaries
    }
    
    func convertArrayOfAssignmentsModelsToDictionaries(models: [Assignment]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id ?? "", DictionaryKeys.callingName.rawValue: model.callingName, DictionaryKeys.memberName.rawValue: model.memberName, DictionaryKeys.organizationName.rawValue: model.organizationName, DictionaryKeys.actionType.rawValue: model.actionType])
        }
        
        return dictionaries
    }
    
    func convertOrgMbrCallingModelToDictionary(model: OrgMbrCalling) -> [String: Any] {
        [DictionaryKeys.uid.rawValue: model.id ?? "",
         DictionaryKeys.callingName.rawValue: model.callingName,
         DictionaryKeys.organizationName.rawValue: model.organizationName,
         DictionaryKeys.memberName.rawValue: model.memberName,
         DictionaryKeys.memberToBeReleased.rawValue: model.memberToBeReleased,
         DictionaryKeys.approvedDate.rawValue: model.approvedDate,
         DictionaryKeys.calledDate.rawValue: model.calledDate,
         DictionaryKeys.sustainedDate.rawValue: model.sustainedDate,
         DictionaryKeys.setApartDate.rawValue: model.setApartDate,
         DictionaryKeys.releasedDate.rawValue: model.releasedDate,
         DictionaryKeys.recommendedDate.rawValue: model.recommendedDate,
         DictionaryKeys.ldrAssignToCall.rawValue: model.ldrAssignToCall,
         DictionaryKeys.ldrAssignToSetApart.rawValue: model.ldrAssignToSetApart,
         DictionaryKeys.callingPreviouslyFilledDate.rawValue: model.callingPreviouslyFilledDate,
         DictionaryKeys.callingDisplayIndex.rawValue: model.callingDisplayIndex,
         DictionaryKeys.callingAction.rawValue: model.callingAction,
         DictionaryKeys.recommendations.rawValue: model.recommendations]
    }
    
    func convertArrayOfInterviewsModelsToDictionaries(models: [Interview]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id ?? "",
                                 DictionaryKeys.name.rawValue: model.name,
                                 DictionaryKeys.notes.rawValue: model.notes,
                                 DictionaryKeys.ldrAssignToDoInterview.rawValue: model.ldrAssignToDoInterview,
                                 DictionaryKeys.details.rawValue: model.details,
                                 DictionaryKeys.scheduledInterviewDate.rawValue: model.scheduledInterviewDate,
                                 DictionaryKeys.scheduledInterviewTime.rawValue: model.scheduledInterviewTime,
                                 DictionaryKeys.status.rawValue: model.status,
                                 DictionaryKeys.ordination.rawValue: model.ordination])
        }
        
        return dictionaries
    }
    
    func convertArrayOfNotesModelsToDictionaries(models: [ Note]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id, DictionaryKeys.leader.rawValue: model.leader, DictionaryKeys.content.rawValue: model.content])
        }
        
        return dictionaries
    }
    
    func convertArrayOfSpeakingAssignmentsModelsToDictionaries(models: [SpeakingAssignment]) -> [[String: Any]] {
        var dictionaries = [[String: Any]]()
        
        for model in models {
            dictionaries.append([DictionaryKeys.uid.rawValue: model.id ?? "", DictionaryKeys.name.rawValue: model.name, DictionaryKeys.topic.rawValue: model.topic, DictionaryKeys.askToSpeakOnDate.rawValue: model.askToSpeakOnDate, DictionaryKeys.weekOfYear.rawValue: model.weekOfYear])
        }
        
        return dictionaries
    }
    
    func convertSpeakingAssignmentsModelToDictionary(model: SpeakingAssignment) -> [String: Any] {
        [DictionaryKeys.uid.rawValue: model.id ?? "", DictionaryKeys.name.rawValue: model.name, DictionaryKeys.topic.rawValue: model.topic, DictionaryKeys.askToSpeakOnDate.rawValue: model.askToSpeakOnDate, DictionaryKeys.weekOfYear.rawValue: model.weekOfYear]
    }
    
    func convertArrayOfRecommendationsToDeliniatedString(recommendations: [Recommendation]) -> String {
        var recommendationString = ""
        
        if recommendations.count == 1 {
            if let member = recommendations.first?.member {
                recommendationString = member + " : "
            }
        } else {
            for (index, recommendation) in recommendations.enumerated() {
                if index == (recommendations.count - 1) {
                    recommendationString += recommendation.member
                } else {
                    recommendationString += recommendation.member + " : "
                }
            }
        }
        
        return recommendationString
    }
    
    //        func convertRecommendationsStringToArrayOfStrings(recommendationsString: String) -> [String] {
    //            var recommendations = [String]()
    //
    //            for char in recommendationsString {
    //                if char == (recommendations.count - 1) {
    //                    recommendationString += recommendation
    //                } else {
    //                    recommendationString += recommendation + " : "
    //                }
    //            }
    //
    //            return recommendationString
    //        }
    
    // MARK: - Utility Functions
    
    @objc func delayedFunction() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.hideDownloadDataProgressNotification.stringValue), object: nil)
    }
    
    func organizationExists(in data: [String], name: String) -> Bool {
        for organization in data/*OrganizationsViewModel.shared.tableViewDataSource*/ {
            if organization == name {
                return true
            }
        }
        
        return false
    }
    
    func updateCalling(uid: String,
                       memberName: String,
                       callingName: String,
                       organizationName: String,
                       approvedDate: String,
                       calledDate: String,
                       sustainedDate: String,
                       setApartDate: String,
                       releaseDate: String,
                       recommendedDate: String,
                       memberToBeReleased: String,
                       ldrAssignToCall: String,
                       ldrAssignToSetApart: String,
                       callingPreviouslyFilledDate: String,
                       callingDisplayIndex: String,
                       callingAction: String, recommendations: [Recommendation]) {
        let orgMbrCalling = OrgMbrCalling(uid: uid, callingName: callingName, organizationName: organizationName, memberName: memberName, memberToBeReleased: memberToBeReleased, approvedDate: approvedDate, calledDate: calledDate, sustainedDate: sustainedDate, setApartDate: setApartDate, releasedDate: releaseDate, recommendedDate: recommendedDate, ldrAssignToCall: ldrAssignToCall, ldrAssignToSetApart: ldrAssignToSetApart, callingPreviouslyFilledDate: callingPreviouslyFilledDate, callingDisplayIndex: callingDisplayIndex, callingAction: callingAction, recommendations: convertArrayOfRecommendationsToDeliniatedString(recommendations: recommendations))
        
        CoreDataManager.shared.updateCalling(model: orgMbrCalling) {
            
        }
    }
    
    func updateSectionTitles() {
        for (idx, sectionNotFound) in sectionsNotFound.enumerated() {
            for (index, section) in Constants.sectionTitles.enumerated() {
                if sectionNotFound == section {
                    Constants.sectionTitles.remove(at: index)
                    sectionsNotFound.remove(at: idx)
                    break
                }
            }
            
            break
        }
        
        if sectionsNotFound.count > 0 {
            //  self.updateSectionTitles()
        }
    }
}
