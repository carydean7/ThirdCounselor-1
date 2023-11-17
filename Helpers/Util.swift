//
//  Util.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 1/6/22.
//

import Foundation
import UIKit
import Network
import SwiftUI

enum HymnTypes: Int {
    case open = 0
    case sacrament = 1
    case intermediate = 2
    case closing = 3
}

enum ActionTypes: Int, CaseIterable {
    case noFurtherActionRequired
    case recommendationsForApproval
    case recommendationApproved
    case recommendationNotApproved
    case extendCall
    case callAccepted
    case callDeclined
    case toBeSustained
    case sustained
    case needsSettingApart
    case setApart
    case needsToBeReleased
    case released
    case interviewed
    case ordained
    case callingReadyForUpdateOnWeb
    case callingUpdatedOnWeb
}

enum CallingActionTypeButtonTitles: String {
    case approved
    case notApproved
    case extendCall
    case accepted
    case declined
    case released
    case sustained
    case setApart
    case noFurtherAction
    case welcomed
    case announced
    
    var stringValue: String {
        switch self {
        case .approved:
            return "Approved"
        case .notApproved:
            return "Not Approved"
        case .extendCall:
            return "Extend Call"
        case .accepted:
            return "Accepted"
        case .declined:
            return "Declined"
        case .released:
            return "Released"
        case .sustained:
            return "Sustained"
        case .setApart:
            return "Set Apart"
        case .noFurtherAction:
            return ""
        case .welcomed:
            return "Welcomed"
        case .announced:
            return "Announced"
        }
    }
}

enum ActionTypeSectionTitles: String {
    case recommended
    case called
    case sustained
    case setApart
    case released
    case interviews
    case callingsToUpdateOnWeb
    
    var stringValue: String {
        switch self {
        case .recommended:
            return "Recommended"
        case .called:
            return "Calls to Extend"
        case .sustained:
            return "To Be Sustained"
        case .setApart:
            return "Setting Aparts"
        case .released:
            return "Releases"
        case .interviews:
            return "Interviews"
        case .callingsToUpdateOnWeb:
            return "Callings to update on web"
        }
    }
}

enum OrdinationOfficeCategories: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    case deacon = "Deacon"
    case teacher = "Teacher"
    case priest = "Priest"
    case bishop = "Bishop"
    case elder = "Elder"
    case highPriest = "High Priest"
    case patriarch = "Patriarch"
}

enum InterviewCategories: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    case recommend = "Recommends"
    case ordinations = "Ordinations"
    case calling = "Callings"
    case bishopBranchStakePresidentOnly = "Bishop/Branch or Stake President"
    case stakePresidentOnly = "Stake President"
    case other = "Other"
}

enum AssignmentSnapshotDisclosureGroups: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    case approvedCallsToExtend = "Approved Calls to Extend"
    case releases = "Releases"
    case settingAparts = "Setting Aparts"
    case interviews = "Interviews"
}

enum PrayersFilterGroups: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    case withInLast6Mos = "Members who prayed within last 6 months"
    case sixMosTo1Yr = "Members who prayed 6 months - 1 year"
    case moreThan1Yr = "Members who prayed more than 1 year"
    case membersNeverPrayed = "Members who have not prayed"
}

enum CustomDisclosureGroupViewContentTypes {
    case speakingAssignment
    case prayers
}

enum SpeakingAssignmentFilterGroups: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    case withInLast6Mos = "Speakers within last 6 months"
    case sixMosTo1Yr = "Speakers 6 months - 1 year"
    case moreThan1Yr = "Speakers who spoke more than 1 year"
    case membersNeverSpoke = "Members who have not spoken"
    case aSunday = "Sunday: "
}

enum InterviewTypeSectionTitles: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    case headerSpace = "Types"
    case ownEndowmentOrSealedToSpouse = "Own Endowment or Sealing to Spouse"
    case newConvert = "New Convert"
    case ordainNewMaleConvertToAPH = "Aaronic Priesthood Ordination - New Member"
    case ordainMaleToPriestOffice = "Priest Ordination"
    case recommendManToBeOrdainedElderOrHighPriest = "Elder or High Priest Ordination"
    case recommendMemeberToServeAsFullTimeMissionary = "Full Time Missionary"
    case callMemberToServeAsWardOrganizationPresident = "Calling Ward Organization President"
    case callPriestToServeAsPriestQuorumAssistant = "Calling Assistant in Priest Quorum"
    case helpMemberToRepentOfSeriousSin = "Bishop or Stake President Only"
    case endorseMemberForChurchUniversityOrCollegeEnrollment = "Ecclesiastical Education Endorsement"
    case endorseMemberToReceivePerpetualEducationFundLoan = "Perpetual Education Fund loan"
    case tithingDeclaration = "Tithing Declaration"
    case authorizeUseOfFastOfferingFunds = "Welfare or Self-reliance"
    case renewTempleRecommend = "Renew Recommend"
    case issueProxyBaptismConfirmationTempleRecommend = "Proxy Baptisms and Confirmations"
    case issueTempleRecommendForParentOrSiblingSealing = "Recommend sealing to parents or witness"
    case callMemberToServeInWardCalling = "Ward Calling"
    case authorizeBaptismConfirmationOf8YearOldWithMemberOfRecordParent = "8-yr old Baptism"
    case authorizeOfficeOfDeaconTeacherOrdination = "Ordination Deacon, Teacher, Priest"
    case issuePatriarchalBlessingRecommend = "Patriarchal Blessing"
    case authorizePriesthoodHolderToPerformPriesthoodOrdinanceInAnotherWard = "Priesthood ordinance in another ward"
    case releaseReturnedHomeFullTimeMissionary = "Release F/Time Missionary"
    case callCounselorInStakePresidencyPatriarchOrBishop = "Call counselor in stake presidency, a patriarch, or a bishop"
    case callEldersQuorumOrReliefSocietyPresident = "Call Elders Quorum or Stake Relief Society president."
    case authorizeOfficeOfElderOrHighPriestOrdination = "Ordination Elder or High Priest"
    case callMemberToServeInCalling = "Callings"
    case verifyDepartingMissionaryHealthWorthiness = "Missionary’s health and worthiness"
    case annualYouth = "Annual youth"
    case semiAnnualYouth = "Semi-Annual youth"
    case ministering = "Elders Quorum or Relief Society Presidency. Ministering"
    case bishopYoungWomenPresident = "Young Womens President Monthly"
    case bishopReliefSocietyPresident = "Relief Society President Monthly"
    case bishopElderQuorumPresident = "Elder Quorum President Monthly"
    case other = "Other"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum TabbarButtonTitles {
    case home
    case callings
    case members
    case reports
    case assignments
    case interviews
    
    var identifierString: String {
        switch self {
        case .home:
            return "Home"
        case .callings:
            return "Callings"
        case .members:
            return "Members"
        case .reports:
            return "Reports"
        case .assignments:
            return "Assignments"
        case .interviews:
            return "Interviews"
        }
    }
}

enum MembersAcceptedCallingResponse: Int {
    case yes
    case no
}

enum PushNotificationType {
    case member
    case calling
}

enum NextStepActions: String {
    case approve = "Bishopric Approved"
    case called = "Member Called"
    case released = "Member Released"
    case sustained = "Member Sustained"
    case setApart = "Member Set Apart"
    case recommended = "Member Recommended"
}

enum AssignmentActions: String {
    case extendCall = "Extend Call"
    case settingApart = "Setting Apart"
}

enum Identifiers {
    case callingsViewController
    case membersViewController
    case organizationalReportViewController
    case dashboardViewController
    case actionsReportViewController
    case orgMbrCallingsViewController
    case reportsPagesViewController
    case interviewsViewController
    case reportsViewController
    case conductingViewController
    case speakingAssignmentsViewController
    case speakingTopicConferenceTalksViewController
    case speakingTopicConferenceTalksRewind
    case wardBusinessSustainingsViewController
    case wardBusinessReleasesViewController
    case welcomeConductingPresidingViewController
    case announcementsViewController
    case openingHymnInvocationViewController
    case wardBusinessMoveInsViewController
    case speakersAndMusicViewController
    case closingHymnBenedictionViewController
    case wardBusinessOrdinationsViewController
    case sacramentMusicViewController
    case hymnsViewController
    case assignmentsViewController
    case prayersViewController
    case ordinationsViewController
    
    var identifierString: String {
        switch self {
        case .callingsViewController:
            return "callingsViewController"
        case .membersViewController:
            return "membersViewController"
        case .organizationalReportViewController:
            return "organizationalReportViewController"
        case .dashboardViewController:
            return "dashboardViewController"
        case .actionsReportViewController:
            return "actionsReportViewController"
        case .orgMbrCallingsViewController:
            return "orgMbrCallingsViewController"
        case .reportsPagesViewController:
            return "reportsPagesViewController"
        case .interviewsViewController:
            return "interviewsViewController"
        case .reportsViewController:
            return "reportsViewController"
        case .conductingViewController:
            return "conductingViewController"
        case .speakingAssignmentsViewController:
            return "speakingAssignmentsViewController"
        case .speakingTopicConferenceTalksViewController:
            return "speakingTopicConferenceTalksViewController"
        case .speakingTopicConferenceTalksRewind:
            return "speakingTopicConferenceTalksRewind"
        case .wardBusinessSustainingsViewController:
            return "wardBusinessSustainingsViewController"
        case .welcomeConductingPresidingViewController:
            return "welcomeConductingPresidingViewController"
        case .announcementsViewController:
            return "announcementsViewController"
        case .openingHymnInvocationViewController:
            return "openingHymnInvocationViewController"
        case .wardBusinessMoveInsViewController:
            return "wardBusinessMoveInsViewController"
        case .speakersAndMusicViewController:
            return "speakersAndMusicViewController"
        case .closingHymnBenedictionViewController:
            return "closingHymnBenedictionViewController"
        case .wardBusinessOrdinationsViewController:
            return "wardBusinessOrdinationsViewController"
        case .sacramentMusicViewController:
            return "sacramentMusicViewController"
        case .wardBusinessReleasesViewController:
            return "wardBusinessReleasesViewController"
        case .hymnsViewController:
            return "hymnsViewController"
        case .assignmentsViewController:
            return "assignmentsViewController"
        case .prayersViewController:
            return "prayersViewController"
        case .ordinationsViewController:
            return "ordinationsViewController"
        }
    }
}

enum DictionaryKeys: String {
    case uid
    case name
    case approvedDate
    case calledDate
    case callingName
    case memberName
    case recommendedDate
    case setApartDate
    case sustainedDate
    case releasedDate
    case memberToBeReleased
    case ldrAssignToCall
    case ldrAssignToSetApart
    case callingPreviouslyFilledDate
    case callingDisplayIndex
    case ldrAssignToDoInterview
    case scheduledInterviewDate
    case scheduledInterviewTime
    case details
    case notes
    case askToSpeakOnDate
    case topic
    case callIsFilled
    case weekOfYear
    case organizationName
    case actionType
    case content
    case leader
    case weekNumberInMonthForSunday
    case status
    case ordination
    case category
    case date
    case type
    case datePerformed
    case ordinationOffice
    case callingAction
    case stakeName
    case stakeUnitNumber
    case units
    case unitNumber
    case unitName
    case screen
    case instructions
    case functions
    case steps
    case contents
    case recommendations
    case welcomed
    case fyi
    case announced
    case songForSection
    case showList
    case showTextField
    case showAddButton
    case sheetSection
    case sectionTitle
    case upperSectionContent
    case lowerSectionContent
    case conducting
    case presiding
    case announcements
    case openingSong
    case invocation
    case wardBusinessMoveIns
    case wardBusinessReleases
    case wardBusinessSustainings
    case sacramentSong
    case musicProviders
    case speakers
    case intermediatMusic
    case ordinations
    case closingSong
    case benediction
    case textFieldPlaceholderText
    case upperSectionIsEditable
    case lowerSectionIsEditable
}

enum ApplySegmentControlActions: Int {
    case pending
    case done
}

enum ChangeApprovedSegmentControlValues: Int {
    case yes
    case no
}

enum ActionSectionsIdentifiers {
    case recommended
    case called
    case sustained
    case setApart
    case released
    
    var identifierIntValue: Int {
        switch self {
        case .recommended:
            return 100
        case .called:
            return 200
        case .sustained:
            return 300
        case .setApart:
            return 400
        case .released:
            return 500
        }
    }
}

enum LabelTypes {
    case title
    case message
}

enum SnapShotTitles: String {
    case callingActions = "CALLINGS"
    case interviewActions = "INTERVIEWS"
}

enum InterviewTypeDetails: String, CaseIterable, Identifiable, Equatable {
    typealias RawValue = String

    var id: String? {
        return UUID().uuidString
    }

    case headerSpace
    case ownEndowmentOrSealedToSpouse
    case newConvert
    case ordainNewMaleConvertToAPH
    case ordainMaleToPriestOffice
    case recommendManToBeOrdainedElderOrHighPriest
    case recommendMemeberToServeAsFullTimeMissionary
    case callMemberToServeAsWardOrganizationPresident
    case callPriestToServeAsPriestQuorumAssistant
    case helpMemberToRepentOfSeriousSin
    case endorseMemberForChurchUniversityOrCollegeEnrollment
    case endorseMemberToReceivePerpetualEducationFundLoan
    case tithingSettlement
    case authorizeUseOfFastOfferingFunds
    case renewTempleRecommend
    case issueProxyBaptismConfirmationTempleRecommend
    case issueTempleRecommendForParentOrSiblingSealing
    case callMemberToServeInWardCalling
    case authorizeBaptismConfirmationOf8YearOldWithMemberOfRecordParent
    case authorizeOfficeOfDeaconTeacherOrdination
    case issuePatriarchalBlessingRecommend
    case authorizePriesthoodHolderToPerformPriesthoodOrdinanceInAnotherWard
    case releaseReturnedHomeFullTimeMissionary
    case callCounselorInStakePresidencyPatriarchOrBishop
    case callEldersQuorumOrReliefSocietyPresident
    case authorizeOfficeOfElderOrHighPriestOrdination
    case callMemberToServeInCalling
    case verifyDepartingMissionaryHealthWorthiness
    case annualYouth
    case semiAnnualYouth
    case ministering
    case bishopYoungWomenPresident
    case bishopReliefSocietyPresident
    case bishopElderQuorumPresident
    case membershipCouncil

    var stringValue: String {
        switch self {
        case .headerSpace:
            return "Types"
        case .ownEndowmentOrSealedToSpouse:
            return "\(InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly)Issue a temple recommend for a member who is receiving his or her own endowment or being sealed to a spouse"
        case .newConvert:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Issue recommend to a new convert"
        case .ordainNewMaleConvertToAPH:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Ordain new male convert to Aaronic Priesthood"
        case .ordainMaleToPriestOffice:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Ordain young man or man to the office of priest"
        case .recommendManToBeOrdainedElderOrHighPriest:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Recommend man to be ordained an elder or high priest"
        case .recommendMemeberToServeAsFullTimeMissionary:
            return "\(InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly)Recommend member to serve as a full time missionary"
        case .callMemberToServeAsWardOrganizationPresident:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Call member to serve as a ward organization president"
        case .callPriestToServeAsPriestQuorumAssistant:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Call priest to serve as an assistant in the priest quorum"
        case .helpMemberToRepentOfSeriousSin:
            return "\(InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly)Help member to repent of a serious sin"
        case .endorseMemberForChurchUniversityOrCollegeEnrollment:
            return "\(InterviewTypeLeaderIdentifier.bishopOrStakePresidentOrStakePresidencyCounselor)Endorse a member to enroll or continue enrollment at a church university or college"
        case .endorseMemberToReceivePerpetualEducationFundLoan:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Endorse a member to receive a Perpetual Education Fund loan"
        case .tithingSettlement:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Tithing Declaration"
        case .authorizeUseOfFastOfferingFunds:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Authorize the use of fast offering funds"
        case .renewTempleRecommend:
            return "\(InterviewTypeLeaderIdentifier.bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor)Renew a temple recommend"
        case .issueProxyBaptismConfirmationTempleRecommend:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Issue a temple recommend to participate in proxy baptisms and confirmations"
        case .issueTempleRecommendForParentOrSiblingSealing:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Issue a temple recommend to be sealed to parents or to witness the sealing of siblings to parents"
        case .callMemberToServeInWardCalling:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Call a member to serve in a ward calling"
        case .authorizeBaptismConfirmationOf8YearOldWithMemberOfRecordParent:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Authorize the baptism and confirmation of an 8-year-old who is either a member of record or has a parent or guardian who is a member of the Church"
        case .authorizeOfficeOfDeaconTeacherOrdination:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Authorize ordination of a young man to the office of deacon, teacher or priest"
        case .issuePatriarchalBlessingRecommend:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Issue a Patriarchal Blessing Recommend"
        case .authorizePriesthoodHolderToPerformPriesthoodOrdinanceInAnotherWard:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Authorize a priesthood holder to perform a priesthood ordinance in another ward"
        case .releaseReturnedHomeFullTimeMissionary:
            return "\(InterviewTypeLeaderIdentifier.stakePresidentOnly)Release a full-time missionary who has returned home"
        case .callCounselorInStakePresidencyPatriarchOrBishop:
            return "\(InterviewTypeLeaderIdentifier.stakePresidentOnly)When authorized, call a member to serve as a counselor in the stake presidency, a patriarch, or a bishop"
        case .callEldersQuorumOrReliefSocietyPresident:
            return "\(InterviewTypeLeaderIdentifier.stakePresidentOrCounselor)Call a member to serve as an elders quorum president or stake Relief Society president."
        case .authorizeOfficeOfElderOrHighPriestOrdination:
            return "\(InterviewTypeLeaderIdentifier.stakePresidentOrCounselor)Authorize ordination of a man to the office of elder or high priest"
        case .callMemberToServeInCalling:
            return "\(InterviewTypeLeaderIdentifier.bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor)Call members to serve in callings"
        case .verifyDepartingMissionaryHealthWorthiness:
            return "\(InterviewTypeLeaderIdentifier.stakePresidentOrCounselor)Verify a departing missionary’s health and worthiness shortly before he or she is set apart"
        case .annualYouth:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Annual youth"
        case .semiAnnualYouth:
            return "\(InterviewTypeLeaderIdentifier.bishopOrCounselor)Semi-Annual youth"
        case .ministering:
            return "Elders Quorum or Relief Society Presidency. Ministering"
        case .bishopYoungWomenPresident:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Young Womens President Monthly"
        case .bishopReliefSocietyPresident:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Relief Society President Monthly"
        case .bishopElderQuorumPresident:
            return "\(InterviewTypeLeaderIdentifier.bishopOnly)Elder Quorum President Monthly"
        case .membershipCouncil:
            return "Ward or Stake Membership Council"
        }
    }
}

enum InterviewTypeLeaderIdentifier: CaseIterable, Identifiable, Equatable {
    typealias RawValue = String
    
    var id: String? {
        return UUID().uuidString
    }
    
    static let branchPresidentOnly = "Branch President:"
    static let bishopOnly = "Bishop:"
    static let bishopOrCounselor = "Bishop or Counselor:"
    static let stakePresidentOnly = "Stake President:"
    static let stakePresidentOrCounselor = "Stake President or Counselor:"
    static let bishopOrStakePresidentOnly = "Bishop or Stake President:"
    static let bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor = "Bishopric or Stake Presidency:"
    static let bishopOrStakePresidentOrStakePresidencyCounselor = "Bishop or Stake Presidency or Counsleor in Stake Presidency:"
}

enum NotificationNames {
    case deleteMemberNotification
    case showDownloadDataProgressNotification
    case tableViewNeedsUpdateNotification
    case hideDownloadDataProgressNotification
    case snapshotViewClosedNotification
    case didSaveNotification
    case fetchOrganization
    case fetchOrgMbrCalling
    
    var stringValue: String {
        switch self {
        case .deleteMemberNotification:
            return "deleteMemberNotification"
        case .showDownloadDataProgressNotification:
            return "showDownloadDataProgressNotification"
        case .tableViewNeedsUpdateNotification:
            return "tableViewNeedsUpdateNotification"
        case .hideDownloadDataProgressNotification:
            return "hideDownloadDataProgressNotification"
        case .snapshotViewClosedNotification:
            return "snapshotViewClosedNotification"
        case .didSaveNotification:
            return "didSaveNotification"
        case .fetchOrganization:
            return "fetchOrganizations"
        case .fetchOrgMbrCalling:
            return "fetchOrgMbrCalling"
        }
    }
}

enum CallSetApartBishopBranchPresidentOnly: String {
    case president = "President"
    case firstAssistant = "First Assistant"
    case secondAssistant = "Second Assistant"
}

enum ReportTypes: String, CaseIterable {
    case callingByActionType
    case callingByOrganization
    case conducting
    case ordinations
    case prayers
    case speakingAssignmentsAndTopics
    case assignments
    case announcements
    
    var stringValue: String {
        switch self {
        case .callingByActionType:
            return "Callings By Action"
        case .callingByOrganization:
            return "Callings By Organization"
        case .conducting:
            return "Conducting"
        case .ordinations:
            return "Ordinations"
        case .prayers:
            return "Prayers"
        case .speakingAssignmentsAndTopics:
            return "Speaking Assignments & Topics"
        case .assignments:
            return "My Assignments"
        case .announcements:
            return "Announcements"
        }
    }
}

enum LeadershipPositions: String, CaseIterable {
    case stakePresident
    case stakePresidencyFirstCounselor
    case stakePresidencySecondCounselor
    case stakeExecutiveSecretary
    case bishop
    case bishopricFirstCounselor
    case bishopricSecondCounselor
    case wardExecutiveSecretary
    case branchPresident
    case branchPresidencyFirstCounselor
    case branchPresidencySecondCounselor
    case branchExecutiveSecretary

    var stringValue: String {
        switch self {
        case .stakePresident:
            return "Stake President"
        case .stakePresidencyFirstCounselor:
            return "Stake Presidency First Counselor"
        case .stakePresidencySecondCounselor:
            return "Stake Presidency Second Counselor"
        case .stakeExecutiveSecretary:
            return "Stake Executive Secretary"
        case .bishop:
            return "Bishop"
        case .bishopricFirstCounselor:
            return "Bishopric First Counselor"
        case .bishopricSecondCounselor:
            return "Bishopric Second Counselor"
        case .wardExecutiveSecretary:
            return "Ward Executive Secretary"
        case .branchPresident:
            return "Branch President"
        case .branchPresidencyFirstCounselor:
            return "Branch Presidency First Counselor"
        case .branchPresidencySecondCounselor:
            return "Branch Presidency Second Counselor"
        case .branchExecutiveSecretary:
            return "Branch Executive Secretary"
        }
    }
}

enum LeadersThatConductSacrament: String, CaseIterable {
    case bishop
    case bishopricFirstCounselor
    case bishopricSecondCounselor
    case branchPresident
    case branchPresidencyFirstCounselor
    case branchPresidencySecondCounselor

    var stringValue: String {
        switch self {
        case .bishop:
            return "Bishop"
        case .bishopricFirstCounselor:
            return "Bishopric First Counselor"
        case .bishopricSecondCounselor:
            return "Bishopric Second Counselor"
        case .branchPresident:
            return "Branch President"
        case .branchPresidencyFirstCounselor:
            return "Branch Presidency First Counselor"
        case .branchPresidencySecondCounselor:
            return "Branch Presidency Second Counselor"
        }
    }
}

enum LeadersPresidingAtSacrament: String, CaseIterable, Identifiable {
    
    var id: String { UUID().uuidString }
    
    case apostle
    case generalAuthority
    case areaAuthority
    case stakePresident
    case stakePresidencyFirstCounselor
    case stakePresidencySecondCounselor
    case bishop
    case branchPresident

    var stringValue: String {
        switch self {
        case .apostle:
            return "Apostle"
        case .generalAuthority:
            return "General Authority"
        case .areaAuthority:
            return "Area Authority"
        case .stakePresident:
            return "Stake President"
        case .stakePresidencyFirstCounselor:
            return "Stake Presidency First Counselor"
        case .stakePresidencySecondCounselor:
            return "Stake Presidency Second Counselor"
        case .bishop:
            return "Bishop"
        case .branchPresident:
            return "Branch President"
        }
    }
}

enum TabBarTagIdentifiers: Int {
    case callings = 1
    case members
    case interviews
    case reports
    case settings
}

enum UnitTypes: String, CaseIterable {
    case stake
    case ward
    case branch
    
    var stringValue: String {
        switch self {
        case .stake:
            return "Stake"
        case .ward:
            return "Ward"
        case .branch:
            return "Branch"
        }
    }
}

enum UserDefaultKeys: String {
    case leaderPosition
    case unitType
    case unitNumber
    case stakeNumber
    
    var stringValue: String {
        switch self {
        case .leaderPosition:
            return "leaderPosition"
        case .unitType:
            return "unitType"
        case .unitNumber:
            return "unitNumber"
        case .stakeNumber:
            return "stakeNumber"
        }
    }
}

enum ReportsPageNames: String {
    case organizational
    case actions
}

enum MemberCellContentStates {
    case expand
    case collapse
}

enum MemberCellLabelTypes: String {
    case calling
    case member
}

enum CustomCellIdentifiers: String {
    case memberCell
    case interviewTypesCell
    case callingCell
    case actionsCell
    case reportCell
    case assignedInterviewsCell
    case speakingAssignmentCell
    case conductingWelcomeSectionCell
    case conductingAnnouncementsSectionCell
    case defaultCell = "cell"
}

enum SelectionAlertTitles: String {
    case interviewTypes = "Interview Types"
    case selectMember = "Members"
    case leaderPosition = "Leader Positions"
    case assignedInterviews = "Assigned Interviews"
}

enum SelectionAlertMessages: String {
    case interviewTypes = "Choose type of interview for: "
    case selectMember = "Select a member"
    case selectLeader = "Select leader"
}

enum CustomTableViewCellsNibName: String {
    case reportTableViewCell = "ReportTableViewCell"
}

enum CollectionEntities: String {
    case members = "Members"
    case callings = "Callings"
    case interviews = "Interviews"
    case organizations = "Organizations"
    case orgMbrCalling = "OrgMbrCalling"
    case speakingAssignments = "SpeakingAssignments"
    case assignments = "Assignments"
    case notes = "Notes"
    case prayers = "Prayers"
    case ordinations = "Ordinations"
    case stake = "Stake"
    case announcements = "Announcements"
    case conductingSheets = "ConductingSheets"
}

enum ListHeadingTitles: String {
    case members = "MEMBERS"
    case organizations = "ORGANIZATIONS"
    case callings = "CALLINGS"
    case calling = "CALLING"
    case callingActions = "CALLING ACTIONS"
    case actionItems = "ACTION ITEMS"
    case hymns = "HYMNS            "
    case assignments = "ASSIGNMENTS"
    case notes = "NOTES"
    case speakers = "SPEAKERS"
    case conductingSheet = "CONDUCTING SHEET"
    case speakingAssignment = "SPEAKING ASSIGNMENT"
    case presidingAuthorities = "PRESIDING AUTHORITIES"
    case interviews = "INTERVIEWS"
    case prayers = "PRAYERS & HYMNS"
    case addPrayer = "ADD PRAYER"
    case ordinations = "ORDINATIONS"
    case scheduleNewInterview = "SCHEDULE NEW INTERVIEW"
    case interviewTypes = "INTERVIEW TYPES"
    case leaders = "LEADERS"
    case addSpeakingAssignment = "ADD SPEAKING ASSIGNMENT"
    case settings = "SETTINGS"
    case help = "HELP TOPICS AND INSTRUCTIONS"
    case selectLeader = "SELECT A LEADER"
    case announcements = "ANNOUNCEMENTS"
}

enum ConductingSectionsIndexes: Int {
    case welcome = 0
    case announcements = 1
    case openingHymn = 2
    case wardBusinessMoveIns = 3
    case wardBusinessReleases = 4
    case wardBusinessSustainings = 5
    case wardBusinessOrdinations = 6
    case sacramentMusic = 7
    case speakersAndMusic = 8
    case closingHymn = 9
}

enum ConductingSectionsTitles: String, CaseIterable {
    case welcome
    case announcements
    case openingHymnInvocation
    case wardBusinessMoveIns
    case wardBusinessReleases
    case wardBusinessSustainings
    case wardBusinessOrdinations
    case sacramentMusic
    case speakersAndMusic
    case closingHymnBenediction
    
    var stringValue: String {
        switch self {
        case .welcome:
            return "Welcome"
        case .announcements:
            return "Announcements"
        case .openingHymnInvocation:
            return "Opening Hymn & Invocation"
        case .wardBusinessMoveIns:
            return "Ward Business Move-ins"
        case .wardBusinessReleases:
            return "Ward Business Releases"
        case .wardBusinessSustainings:
            return "Ward Business Sustainings"
        case .wardBusinessOrdinations:
            return "Ward Business Ordinations"
        case .sacramentMusic:
            return "Sacrament Music"
        case .speakersAndMusic:
            return "Speakers & Music"
        case .closingHymnBenediction:
            return "Closing Hymn & Benediction"
        }
    }
}

enum FontTextStylesTypes {
    case tableSectionTitleFontTextStyle
    case upperLowerLabelFontTextStyle
    case tableCellLabelFontTextStyle
    case pickerLabelFontTextStyle
    case carouselSectionViewTitleFontTextStyle
    case buttonTitleLabelFontTextStyle
}

enum ConductingSectionsTableViewHeaderTitles: String {
    case moveIns
    case releases
    case sustainings
    case members
    case hymns
    case announcements
    
    var stringValue: String {
        switch self {
        case .moveIns:
            return "Move-Ins"
        case .releases:
            return "Releases"
        case .sustainings:
            return "Sustainings"
        case .members:
            return "Members"
        case .hymns:
            return "Hymns"
        case .announcements:
            return "Announcements"
        }
    }
}

enum ReplaceOccurancesOfKeys: String {
    case member
    case conductor
    case accompanist
    case leader
    case hymn
    
    var stringValue: String {
        switch self {
        case .member:
            return "<Member>"
        case .conductor:
            return "<Conductor>"
        case .accompanist:
            return "<Accompanist>"
        case .leader:
            return "<Leader>"
        case .hymn:
            return "<Hymn>"
        }
    }
}

enum SpeakingAssignmentFilter: String {
    case allAssignments
    case last6Months
    case within6MonthsToAYear
    case moreThanAYear
    case neverHaveSpoken
    
    var stringValue: String {
        switch self {
        case .allAssignments:
            return "All Speaking Assignments"
        case .last6Months:
            return "Speakers within last 6 months"
        case .within6MonthsToAYear:
            return "Speakers 6 mos - 1 yr"
        case .moreThanAYear:
            return "Speakers > 1 year"
        case .neverHaveSpoken:
            return "Member who have not spoken"
        }
    }
    
}

func convertToString(date: Date, with style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style //.medium
    
    return dateFormatter.string(from: date)
}

func getWeekOfYear(date: Date) -> Int {
    let calendar = NSCalendar.current

    if calendar.component(.year, from: date) < calendar.component(.year, from: Date()) {
        var weekOfYear = (calendar.component(.weekOfYear, from: date))
        weekOfYear *= -1
        return weekOfYear
    }
    
    return calendar.component(.weekOfYear, from: date)
}

func convertToDate(stringDate: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    if let someDateTime = formatter.date(from: stringDate) {
        return someDateTime
    }
    
    return Date()
}

func getMonthYear(from date: Date) -> (month: Int?, year: Int?) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month, .year], from: date)
    
    return (month: components.month, year: components.year)
}

func showAlertController(title: String, message: String, style: UIAlertController.Style, hasTableView: Bool, actionTitle1: String, actionStyle1: UIAlertAction.Style, actionTitle2: String, actionStyle2: UIAlertAction.Style, sender: UIView, addActionAction: ()?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    
    alert.overrideUserInterfaceStyle = .light
    
    if actionTitle1 != "" {
        alert.addAction(UIAlertAction(title: actionTitle1, style: actionStyle1, handler: { _ in
            // do some action
            addActionAction
        }))
    }
    
    return alert
}

func shouldRotate() -> Bool {
    switch (Constants.deviceIdiom) {
    case .pad:
        return true
    case .phone:
        return false
    default:
        print("Unspecified UI idiom")
    }
    
    return false
}

func supportedInterfaceOrientation() -> UIInterfaceOrientationMask {
    switch (Constants.deviceIdiom) {
    case .pad:
        return .all
    case .phone:
        return .portrait
    default:
        print("Unspecified UI idiom")
    }

    return .portrait
}

func underline<T: UIView>(obj: T, color: UIColor) -> UIView {
    let yPosOffset = Constants.deviceIdiom == .pad ? (obj.frame.size.height - 3) : (obj.frame.size.height - 3)

    let lineView = UIView(frame: CGRect(x: 10, y: yPosOffset, width: obj.frame.size.width - 20, height: 2))
    lineView.backgroundColor = color // #colorLiteral(red: 0.5114337802, green: 0.6318830252, blue: 1, alpha: 1)
    
    return lineView
}

func hasNetworkConnection() -> Bool {
    var status = true

    let monitor = NWPathMonitor()
    
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            status = true
        } else {
            status = false
        }
    }
    
    let queue = DispatchQueue(label: "Network")
    monitor.start(queue: queue)
    
    return status
}

func formatFullName(name: String) -> String {
    var firstName = ""
    
    if let startIndex = name.firstIndex(of: ",") {
        let firstNameOffsetIndex = name.index(startIndex, offsetBy: 2)
        let firstNameSubString = name[firstNameOffsetIndex..<name.endIndex]
        
        let firstAndMiddleName = String(firstNameSubString)
        
        if let spaceIndex = firstAndMiddleName.firstIndex(of: " ") {
            let firstNameSubString = firstAndMiddleName[firstAndMiddleName.startIndex..<spaceIndex]
            
            firstName = String(firstNameSubString)
        } else {
            firstName = String(name[firstNameOffsetIndex..<name.endIndex])
        }
        
        let lastNameOffsetIndex = name.index(startIndex, offsetBy: 0)
        let lastNameSubString = name[name.startIndex..<lastNameOffsetIndex]
        
        let lastName = String(lastNameSubString)
        
        return firstName + " " + lastName
    }
    
    return ""
}

func parseSelectedLeaderPosition(leaderPosition: String) -> (organization: String, position: String) {
    if leaderPosition == Constants.bishopIdentifier {
        return (Constants.bishopricOrganizationIdentifier, leaderPosition)
    }

    guard let firstSpaceIndex = leaderPosition.firstIndex(of: " ") else {
        return ("","")
    }
    
    var position = ""
    
    let subStringOrganization = leaderPosition[leaderPosition.startIndex..<firstSpaceIndex]
    
    var organization = String(subStringOrganization)
            
    if organization == "Bishop" {
        position = organization
        organization += "ric"
    } else {
        let subStringPosition = leaderPosition[firstSpaceIndex..<leaderPosition.endIndex]
        position = String(subStringPosition)
    }
    
    return (organization: organization, position: position)
}

struct Constants {
    static let alphaIndex = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map(String.init)
    static var sectionTitles = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map(String.init)
    static var hymnsSectionTitles = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map(String.init)
    static let organizationsKeyIdentifier = "organizations"
    static let stakePresidencyOrganizationIdentifier = "Stake Presidency"
    static let presidentIdentifier = "President"
    static let bishopricOrganizationIdentifier = "Bishopric"
    static let bishopIdentifier = "Bishop"
    static let firstCounselorIdentifier = "First Counselor"
    static let secondCounselorIdentifier = "Second Counselor"
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    struct ConductingSheetContents {
        struct Upper {
            static let welcome = "Brothers and Sisters I would like to welcome you to Sacrament Services this morning.  I am Brother <Leader> and I will be conducting today."
            static let announcement =  "I would like to bring to your attention the following announcements..."
            static let openHymnInvocation = "✏️ Edit       Our Opening Hymn will be page # <Hymn>                                                                                               "
            static let moveIns = "Would the following new members please stand as their names are read..."
            static let releases = "The following individuals have been released"
            static let sustainings = "The following individuals have been called and if they are present would they please stand: "
            static let ordinations = "I would like to invite <Member(s)> to come up to the stand.  We propose that..."
            static let sacrament = "We would like to now prepare for the partaking of the Sacrament by singing Hymn # <Hymn>"
            static let sacramentProgram = "I would like to thank the Aaronic Priesthood for the reverent manner in which they blessed and passed the sacrament, and thank Bro./Sis. <Conductor> and Bro./Sis. <Accompanist> for providing our music.\n\nWe will now go into our sacrament program.  Today we are pleased to hear from:"
            static let closeHymnBenediction = "✏️ Edit       Our closing Hymn will be Hymn # <Hymn>"
        }
        
        struct Lower {
            static let welcome = "✏️ Edit       I would like to acknowledge the presence of President <Leader> \n\t\t\tfrom the Stake Presidency today, he will be Presiding at this meeting.                                                                                                   "
            static let announcement =  ""
            static let openHymnInvocation = "✏️ Edit       Following the Hymn the invocation will be offered by <Member>                                                       "
            static let moveIns = "Those that would like to welcome them and accept these members in full fellowship in the ward, please indicate by the uplifted hand."
            static let releases = "We propose the they be given a vote of thanks for their service.  Those who wish to express their appreciation may do so by the uplifted hand."
            static let sustainings = "We propose they be sustained.  Those in favor may manifest it by the uplifted hand... Those opposed, if any, may manifest it.  Thank you.  Please be seated."
            static let ordinations = "receive the Aaronic Priesthood and be ordained a (Deacon, Teacher, Priest).  Those in favor may manifest by the uplifted hand.  Those opposed, if any, may manifest it.  "
            static let sacrament = "Following the hymn the Sacrament will be blessed and passed by those holding the Aaronic Priesthood."
            static let sacramentProgram = ""
            static let closeHymnBenediction = "✏️ Edit       Following the closing hymn the benediction will be offered by <Member>"
        }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

func getDataFromJSON(fileName: String) -> JSONDictionary {
    do {
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json:JSONDictionary = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) as! JSONDictionary
            
            return json
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    
    return [:]
}

let fullAlphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

let headers = ["Recommended", "Approved Calls to Extend", "To Be Sustained", "Setting Aparts", "Releases"]

var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!

func formatDate(currentTime: Date) -> (date: String, time: String) {
    var isAm = true
    
    var amPmStr = "AM"
    var minutePrefix = ""
    
    let components = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year], from: currentTime)
    var hour = components.hour ?? 0
    
    if hour > 12 {
        isAm = false
        hour = hour - 12
    }
    
    let minute = components.minute ?? 0
    
    if minute < 10 {
        minutePrefix = "0"
    }
    
    let day = components.day ?? 0
    let month = components.month ?? 0
    let year = components.year ?? 0
    print("Date ::: \(month)-\(day)-\(year) (\(hour):\(minute)")
    
    if !isAm {
        amPmStr = "PM"
    }
    
    let date = "\(month)-\(day)-\(year)"
    let time = "(\(hour):\(minutePrefix)\(minute) \(amPmStr))"
    
    return (date: date, time: time)
}

func getSundays(for range: Int, date: Date, completion: @escaping ([String]) -> Void) {
    var index = 0
    var monthIndex = 1
    var monthWeekIndex = 1
    var sundays = [String]()
    
    let calendar = Calendar.current
    var currentDay = calendar.component(.day, from: date)
    
    let nextFollowingSundays = date.nextFollowingSundays(range)
    nextFollowingSundays.forEach { sunday in
        var currentSunday = sunday.description(with: .current)
        
        currentSunday = currentSunday.replacingOccurrences(of: "Sunday, ", with: "")
        
        if currentSunday.contains("Daylight") {
            currentSunday = currentSunday.replacingOccurrences(of: " at 12:00:00 AM Mountain Daylight Time", with: "")
        } else {
            currentSunday = currentSunday.replacingOccurrences(of: " at 12:00:00 AM Mountain Standard Time", with: "")
        }
        
        let currentSundayDate = convertToDate(stringDate: currentSunday)
        
        let currentMonth = calendar.component(.month, from: currentSundayDate)
        let currentYear = calendar.component(.year, from: currentSundayDate)

        let currentSundayDay = calendar.component(.day, from: currentSundayDate)
        
        if currentSundayDay < currentDay {
            monthIndex += 1
            monthWeekIndex = 1
            currentDay = currentSundayDay
        }
        
        if monthWeekIndex == 4 {
            monthWeekIndex = 1
        }
        
        monthWeekIndex += 1
        
        if range == 4 {
            // month worth only
            sundays.append(currentSunday)
            
            index += 1
        } else if range == 12 {
            // 3 months or 12 weeks worth
            sundays.append(currentSunday)
        } else {
            sundays.append(currentSunday)
        }
    }
    
    sundays = sundays.sorted {sunday, sunday in
        sunday > sunday
    }
    
    completion(sundays)
}

//func determineTheLanguageToUse() {
//    for each user's preferredLanguages
//      if app supports the language
//        return the language
//      if app supports a more generic dialect
//        return the generic language
//
//     // Exhausted preferredLanguages and still cannot determine..
//     return CFBundleDevelopmentRegion
//}

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
