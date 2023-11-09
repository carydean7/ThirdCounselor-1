//
//  InterviewsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/13/22.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension String: Identifiable {
    public var id: String? {
        return UUID().uuidString
    }
}

@MainActor class InterviewsViewModel: BaseViewModel {
    @Published var recommendInterviewDetails: [InterviewDetails] = [
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.ownEndowmentOrSealedToSpouse.stringValue), description: InterviewTypeDetails.ownEndowmentOrSealedToSpouse.stringValue, category: InterviewCategories.recommend.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.newConvert.stringValue),description: InterviewTypeDetails.newConvert.stringValue, category: InterviewCategories.recommend.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.renewTempleRecommend.stringValue),description: InterviewTypeDetails.renewTempleRecommend.stringValue, category: InterviewCategories.recommend.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.issueProxyBaptismConfirmationTempleRecommend.stringValue),description: InterviewTypeDetails.issueProxyBaptismConfirmationTempleRecommend.stringValue, category: InterviewCategories.recommend.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.issueTempleRecommendForParentOrSiblingSealing.stringValue),description: InterviewTypeDetails.issueTempleRecommendForParentOrSiblingSealing.stringValue, category: InterviewCategories.recommend.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: false, priesthood: "", office: "")
   ]
    
    @Published var ordinanceInterviewDetails: [InterviewDetails] = [
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.ordainNewMaleConvertToAPH.stringValue),description: InterviewTypeDetails.ordainNewMaleConvertToAPH.stringValue, category: InterviewCategories.ordinations.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: true, priesthood: "A", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.ordainMaleToPriestOffice.stringValue),description: InterviewTypeDetails.ordainMaleToPriestOffice.stringValue, category: InterviewCategories.ordinations.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.recommendManToBeOrdainedElderOrHighPriest.stringValue),description: InterviewTypeDetails.recommendManToBeOrdainedElderOrHighPriest.stringValue, category: InterviewCategories.ordinations.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: true, priesthood: "M", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.authorizeOfficeOfDeaconTeacherOrdination.stringValue),description: InterviewTypeDetails.authorizeOfficeOfDeaconTeacherOrdination.stringValue, category: InterviewCategories.ordinations.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: true, priesthood: "A", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.authorizePriesthoodHolderToPerformPriesthoodOrdinanceInAnotherWard.stringValue),description: InterviewTypeDetails.authorizePriesthoodHolderToPerformPriesthoodOrdinanceInAnotherWard.stringValue, category: InterviewCategories.ordinations.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.authorizeOfficeOfElderOrHighPriestOrdination.stringValue),description: InterviewTypeDetails.authorizeOfficeOfElderOrHighPriestOrdination.stringValue, category: InterviewCategories.ordinations.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.stakePresidentOrCounselor, showOffice: true, priesthood: "M", office: "")
   ]
    
    @Published var callingInterviewDetails: [InterviewDetails] = [
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.callMemberToServeAsWardOrganizationPresident.stringValue),description: InterviewTypeDetails.callMemberToServeAsWardOrganizationPresident.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.callPriestToServeAsPriestQuorumAssistant.stringValue),description: InterviewTypeDetails.callPriestToServeAsPriestQuorumAssistant.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.callMemberToServeInWardCalling.stringValue),description: InterviewTypeDetails.callMemberToServeInWardCalling.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.releaseReturnedHomeFullTimeMissionary.stringValue),description: InterviewTypeDetails.releaseReturnedHomeFullTimeMissionary.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.stakePresidentOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.callCounselorInStakePresidencyPatriarchOrBishop.stringValue),description: InterviewTypeDetails.callCounselorInStakePresidencyPatriarchOrBishop.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.stakePresidentOnly, showOffice: false, priesthood: "", office: "S"),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.callEldersQuorumOrReliefSocietyPresident.stringValue),description: InterviewTypeDetails.callEldersQuorumOrReliefSocietyPresident.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.stakePresidentOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.callMemberToServeInCalling.stringValue),description: InterviewTypeDetails.callMemberToServeInCalling.stringValue, category: InterviewCategories.calling.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor, showOffice: false, priesthood: "", office: "")
   ]
    
    @Published var bishopBranchStakePresidentOnlyInterviewDetails: [InterviewDetails] = [
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.helpMemberToRepentOfSeriousSin.stringValue),description: InterviewTypeDetails.helpMemberToRepentOfSeriousSin.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.endorseMemberForChurchUniversityOrCollegeEnrollment.stringValue),description: InterviewTypeDetails.endorseMemberForChurchUniversityOrCollegeEnrollment.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrStakePresidentOrStakePresidencyCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.endorseMemberToReceivePerpetualEducationFundLoan.stringValue),description: InterviewTypeDetails.endorseMemberToReceivePerpetualEducationFundLoan.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.tithingSettlement.stringValue),description: InterviewTypeDetails.tithingSettlement.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.authorizeUseOfFastOfferingFunds.stringValue),description: InterviewTypeDetails.authorizeUseOfFastOfferingFunds.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.recommendMemeberToServeAsFullTimeMissionary.stringValue),description: InterviewTypeDetails.recommendMemeberToServeAsFullTimeMissionary.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.issuePatriarchalBlessingRecommend.stringValue),description: InterviewTypeDetails.issuePatriarchalBlessingRecommend.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.verifyDepartingMissionaryHealthWorthiness.stringValue),description: InterviewTypeDetails.verifyDepartingMissionaryHealthWorthiness.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.stakePresidentOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.annualYouth.stringValue),description: InterviewTypeDetails.annualYouth.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.membershipCouncil.stringValue),description: InterviewTypeDetails.membershipCouncil.stringValue, category: InterviewCategories.bishopBranchStakePresidentOnly.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly, showOffice: false, priesthood: "", office: "")
   ]
    
    @Published var otherInterviewDetails: [InterviewDetails] = [
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.semiAnnualYouth.stringValue),description: InterviewTypeDetails.semiAnnualYouth.stringValue, category: InterviewCategories.other.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOrCounselor, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.bishopYoungWomenPresident.stringValue),description: InterviewTypeDetails.bishopYoungWomenPresident.stringValue, category: InterviewCategories.other.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.bishopReliefSocietyPresident.stringValue),description: InterviewTypeDetails.bishopReliefSocietyPresident.stringValue, category: InterviewCategories.other.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.bishopElderQuorumPresident.stringValue),description: InterviewTypeDetails.bishopElderQuorumPresident.stringValue, category: InterviewCategories.other.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopOnly, showOffice: false, priesthood: "", office: ""),
        InterviewDetails(uid: "", parsedInterviewType: InterviewsViewModel.parseInterviewTypeDetails(type: InterviewTypeDetails.ministering.stringValue),description: InterviewTypeDetails.ministering.stringValue, category: InterviewCategories.other.rawValue, authorizedLeader: InterviewTypeLeaderIdentifier.bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor, showOffice: false, priesthood: "", office: "")
   ]
    
    @Published var interviews = [Interview]()
    @Published var showTextField = false
    @Published var isShowingAddInterviewView = false
    @Published var showAddInterviewView = false

    let disclosureGroupColumnHeadings = ["Member", "Interview", "Scheduled Date & Time", "Ordination/Office"]
    let disclosureGroupSectionTitles: [String] = [
        InterviewCategories.recommend.rawValue,
        InterviewCategories.ordinations.rawValue,
        InterviewCategories.calling.rawValue,
        InterviewCategories.bishopBranchStakePresidentOnly.rawValue,
        InterviewCategories.other.rawValue
   ]

    var id = UUID()
    var interviewTypes = [String]()
    var leadership = [String]()
    var authorizedLeaderAssociatedWithSelectedInterviewType = ""
    var addButtonDelegate: AddButtonDelegate?
    
    static let shared = InterviewsViewModel()
    static var hasInitialized = false
    
    static func parseInterviewTypeDetails(type: String) -> String {
        if let startIndex = type.firstIndex(of: ":") {
            let offsetIndex = type.index(startIndex, offsetBy: 1)
            let subString = type[offsetIndex..<type.endIndex]
            return String(subString)
        }
        
        return ""
    }
    
    public init(interviews: [Interview] = [Interview]()) {
        super.init()
        /* Rules:
                Initial launch
                    Nothing to fetch so create default data from json file is file found
                    Create data for cloud (Firestore)
                    Create data for Coredata
                Subsequent runs
                    Fetch data from cloud (Firestore)
                    if no data return - connectivity issue etc...
                        fetch data from core data
                    else use cloud data.
         
         Note: any updates to cloud (Firestore) persist changes to Coredata
         */

        fetchData {
            self.getLeadershipForUnit()
        }
    }
    
    func setInterviewDetailsData(for interviewCategory: String) -> [InterviewDetails] {
        switch interviewCategory {
        case InterviewCategories.recommend.rawValue:
            return recommendInterviewDetails
        case InterviewCategories.ordinations.rawValue:
            return ordinanceInterviewDetails
        case InterviewCategories.calling.rawValue:
            return callingInterviewDetails
        case InterviewCategories.bishopBranchStakePresidentOnly.rawValue:
            return bishopBranchStakePresidentOnlyInterviewDetails
        case InterviewCategories.other.rawValue:
            return otherInterviewDetails
        default:
            return []
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if Network.shared.hasConnection {
            let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.interviews.rawValue)").order(by: DictionaryKeys.category.rawValue, descending: false)
            
            ref?.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Interview Documents")
                    return
                }
                
                self.interviews = documents.compactMap { (queryDocumentSnapshot) -> Interview? in
                    let data = queryDocumentSnapshot.data()
                    
                    let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                    let name = data[DictionaryKeys.name.rawValue] as? String ?? ""
                    let ldrAssignToDoInterview = data[DictionaryKeys.ldrAssignToDoInterview.rawValue] as? String ?? ""
                    let scheduledInterviewDate = data[DictionaryKeys.scheduledInterviewDate.rawValue] as? String ?? ""
                    let scheduledInterviewTime = data[DictionaryKeys.scheduledInterviewTime.rawValue] as? String ?? ""
                    let notes = data[DictionaryKeys.notes.rawValue] as? String ?? ""
                    let details = data[DictionaryKeys.details.rawValue] as? String ?? ""
                    let ordination = data[DictionaryKeys.ordination.rawValue] as? String ?? ""
                    let status = data[DictionaryKeys.status.rawValue] as? String ?? ""
                    let category = data[DictionaryKeys.category.rawValue] as? String ?? ""
                    
                    return Interview(uid: uid, name: name, ldrAssignToDoInterview: ldrAssignToDoInterview, scheduledInterviewDate: scheduledInterviewDate, scheduledInterviewTime: scheduledInterviewTime, notes: notes, details: details, ordination: ordination, status: status, category: category)
                }
                
                completion()
            }
        } else {
            if let interviewsEntities = CoreDataManager.shared.getAllInterviews() {
                interviews = DataManager.shared.convertArrayOfInterviewEntityToInterviewModel(entities: interviewsEntities)
                completion()
            }
        }
    }
    
    func updateInterviewDocument(interview: Interview, completion: @escaping () -> Void) {
        let interviewDictionary = DataManager.shared.convertInterviewModelToDictionary(model: interview)
        let documentId = "\(interview.uid)"
        
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.interviews.rawValue)").document(documentId).updateData(interviewDictionary)


//        do {
//            try db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.interviews.rawValue)").document(documentId).setData(interviewDictionary)
//
//            CoreDataManager.shared.updateInterview(model: interview, completion: {
//                completion()
//            })
//        }
//        catch let error {
//            completion()
//            print(error)
//        }

    }
    
    func addInterviewDocument(interview: Interview, completion: @escaping () -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.interviews.rawValue)").document("\(interview.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: interview.uid, DictionaryKeys.name.rawValue: interview.name, DictionaryKeys.ldrAssignToDoInterview.rawValue: interview.ldrAssignToDoInterview, DictionaryKeys.scheduledInterviewDate.rawValue: interview.scheduledInterviewDate, DictionaryKeys.scheduledInterviewTime.rawValue: interview.scheduledInterviewTime, DictionaryKeys.notes.rawValue: interview.notes,
                      DictionaryKeys.details.rawValue: interview.details,
                      DictionaryKeys.status.rawValue: interview.status,
                      DictionaryKeys.ordination.rawValue: interview.ordination,
                      DictionaryKeys.category.rawValue: interview.category]) { err in
            if let err = err {
                print("Error adding interview document: \(err)")
                completion()
            } else {
                print("collection Document added interview with ID: \(ref!.documentID)")
                completion()
            }
        }
    }
    
    func deleteInterviewDocument(interview: Interview, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.interviews.rawValue)").document(interview.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion()
            } else {
                print("Document successfully removed!")
                completion()
            }
        }
    }
    
    func updateInterview(interview: Interview, completion: @escaping () -> Void) {
        for _interview in interviews {
            if _interview.uid == interview.uid {
                updateInterviewDocument(interview: _interview) {
                    completion()
                }
            }
        }
    }
    
    func getAuthorizedLeader(for selectedInterviewType: String, in section: String) -> String {
        var interviewData = [InterviewDetails]()
        
        switch section {
        case InterviewCategories.recommend.rawValue:
            interviewData = recommendInterviewDetails
        case InterviewCategories.ordinations.rawValue:
            interviewData = ordinanceInterviewDetails
        case InterviewCategories.calling.rawValue:
            interviewData = callingInterviewDetails
        case InterviewCategories.bishopBranchStakePresidentOnly.rawValue:
            interviewData = bishopBranchStakePresidentOnlyInterviewDetails
        case InterviewCategories.other.rawValue:
            interviewData = otherInterviewDetails
        default:
            break
        }
        
        for data in interviewData {
            if data.parsedInterviewType == selectedInterviewType {
                return data.authorizedLeader
            }
        }
        
        return "No Authorized Leader Found"
    }
    
    func getOrdinances() -> [Interview] {
        var ordinances = [Interview]()
        
        fetchData {
            if self.interviews.isEmpty {
                let predicate = NSPredicate(format: "category = ordination")
                
                let interviewsEntity = CoreDataManager.shared.getInterviews(with: predicate)
                
                if !(interviewsEntity?.isEmpty ?? false) {
                    if let interviewsEntity = interviewsEntity {
                        ordinances = DataManager.shared.convertArrayOfInterviewEntityToInterviewModel(entities: interviewsEntity)
                    }
                }
            } else {
                for interview in self.interviews {
                    if interview.category == "Ordinances" {
                        ordinances.append(interview)
                    }
                }
            }
        }
        
        return ordinances
    }
    
    func getCachedInterviews(for member: String) -> [Interview]? {
        let predicate = NSPredicate(format: "ldrAssignToDoInterview = %@", member)
        
     //   let interviewsEntities = CoreDataManager.shared.getInterviews(with: predicate)
        
        return nil//DataManager.convertArrayOfInterviewEntityToInterviewModel(data: interviewsEntities ?? [Interviews]())
    }
    
    func deleteInterview(interview: Interview) {
        for (index, enterview) in interviews.enumerated() {
            if enterview.uid == interview.uid {
                interviews.remove(at: index)
            }
        }
        
        deleteInterviewDocument(interview: interview) {
            CoreDataManager.shared.deleteInterview(uid: interview.uid) {
                self.fetchData {
                    
                }
            }
        }
    }
    
    func getInterviewsActions(for leader: String) -> [Interview]? {
        let predicate = NSPredicate(format: "ldrAssignToDoInterview = %@", leader)
        
      //  let interviewsEntities = CoreDataManager.shared.getInterviews(with: predicate)
        
        return nil//DataManager.convertArrayOfInterviewEntityToInterviewModel(data: interviewsEntities ?? [Interviews]())
    }
    
    func interviewIsBishopOrBranchPresidentOrStakePresidentOnly(interviewType: String) -> Bool {
        if interviewType.hasPrefix(InterviewTypeLeaderIdentifier.bishopOnly) || interviewType.hasPrefix(InterviewTypeLeaderIdentifier.stakePresidentOnly) || interviewType.hasPrefix(InterviewTypeLeaderIdentifier.branchPresidentOnly) {
            return true
        }
        
        return false
    }
    
    func getUnitType() -> String {
        AppDelegate.unitType
    }
    
    func sortInterviews() -> [Interview] {
        interviews.sorted { $0.category > $1.category }
    }
    
    func getLeadershipForUnit() {
        switch AppDelegate.unitType {
        case UnitTypes.stake.stringValue:
            leadership = [LeadershipPositions.stakePresident.stringValue, LeadershipPositions.stakePresidencyFirstCounselor.stringValue, LeadershipPositions.stakePresidencySecondCounselor.stringValue]
        case UnitTypes.ward.stringValue:
            leadership = [LeadershipPositions.bishop.stringValue, LeadershipPositions.bishopricFirstCounselor.stringValue, LeadershipPositions.bishopricSecondCounselor.stringValue]
        case UnitTypes.branch.stringValue:
            leadership = [LeadershipPositions.branchPresident.stringValue, LeadershipPositions.branchPresidencyFirstCounselor.stringValue, LeadershipPositions.branchPresidencySecondCounselor.stringValue]
        default:
            break
        }
    }
    
    func leaderAuthorizedForInterview(type: String, leader: String) -> Bool {
        // get prefix from interview type
        if type.contains(InterviewTypeLeaderIdentifier.bishopOnly) || type.contains(InterviewTypeLeaderIdentifier.stakePresidentOnly) && leader.contains("Counselor") {
            return false
        }
        
        if type.hasPrefix(InterviewTypeLeaderIdentifier.bishopOnly) && leader == LeadershipPositions.bishop.stringValue || leader == LeadershipPositions.branchPresident.stringValue {
            return true
        } else if type.hasPrefix(InterviewTypeLeaderIdentifier.bishopOrCounselor) {
            if leader == LeadershipPositions.bishop.stringValue || leader == LeadershipPositions.bishopricFirstCounselor.stringValue || leader == LeadershipPositions.bishopricSecondCounselor.stringValue || leader == LeadershipPositions.branchPresident.stringValue || leader == LeadershipPositions.branchPresidencyFirstCounselor.stringValue || leader == LeadershipPositions.branchPresidencySecondCounselor.stringValue{
                return true
            }
        } else if type.hasPrefix(InterviewTypeLeaderIdentifier.stakePresidentOnly) && leader == LeadershipPositions.stakePresident.stringValue {
            return true
        } else if type.hasPrefix(InterviewTypeLeaderIdentifier.stakePresidentOrCounselor) {
            if leader == LeadershipPositions.stakePresidencyFirstCounselor.stringValue || leader == LeadershipPositions.stakePresidencySecondCounselor.stringValue {
                return true
            }
        } else if type.hasPrefix(InterviewTypeLeaderIdentifier.bishopOrStakePresidentOnly) {
            if leader == LeadershipPositions.stakePresident.stringValue || leader == LeadershipPositions.bishop.stringValue || leader == LeadershipPositions.branchPresident.stringValue {
                return true
            }
        } else if type.hasPrefix(InterviewTypeLeaderIdentifier.bishopricOrStakePresidencyBishopOrStakePresidentOrACounselor) {
            if leader == LeadershipPositions.bishop.stringValue || leader == LeadershipPositions.bishopricFirstCounselor.stringValue || leader == LeadershipPositions.bishopricSecondCounselor.stringValue || leader == LeadershipPositions.stakePresident.stringValue || leader == LeadershipPositions.stakePresidencySecondCounselor.stringValue || leader == LeadershipPositions.stakePresidencyFirstCounselor.stringValue || leader == LeadershipPositions.branchPresident.stringValue || leader == LeadershipPositions.branchPresidencyFirstCounselor.stringValue || leader == LeadershipPositions.branchPresidencySecondCounselor.stringValue {
                return true
            }
        } else if type.hasPrefix(InterviewTypeLeaderIdentifier.bishopOrStakePresidentOrStakePresidencyCounselor) {
            if leader == LeadershipPositions.bishop.stringValue || leader == LeadershipPositions.branchPresident.stringValue || leader == LeadershipPositions.stakePresident.stringValue || leader == LeadershipPositions.stakePresidencyFirstCounselor.stringValue || leader == LeadershipPositions.stakePresidencySecondCounselor.stringValue {
                return true
            }
        }
        
        return false
    }
}
