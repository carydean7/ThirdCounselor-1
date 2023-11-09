//
//  MbrOrgCallingViewModel.swift
//  LMC_Tracker
//
//  Created by Dean Wagstaff on 12/10/21.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class OrgMbrCallingViewModel: BaseViewModel {
    // MARK: - Properties
    @Published var orgMbrCallings = [OrgMbrCalling]()
    @Published var selectedCallingInOrganization: OrgMbrCalling
    @Published var recommendationsForApproval = [RecommendedCallingChanges]()
    @Published var callsToBeExtended = [OrgMbrCalling]()
    @Published var toBeSustained = [OrgMbrCalling]()
    @Published var settingAparts = [OrgMbrCalling]()
    @Published var membersNeedingToBeReleased = [OrgMbrCalling]()
    @Published var callingActionsInSelectedOrganization = [OrgMbrCalling]()
    @Published var orgMbrCallingActions = [(orgMbrCalling: OrgMbrCalling, callingAction: String)]()
    @Published var selectedOrgMbrCalling = OrgMbrCalling()
        
    var actionType = ""
    var outstandingCallingActions: [OrgMbrCalling] = [OrgMbrCalling]()
    var mbrCallingsInOrganization: [OrgMbrCalling]? = []
    var organizationsTableViewDataSource = [String]()
    var selectedOrganization: String?
    var noOutstandingActionsLabelIsHidden = false
    var actionsTableViewIsHidden = true
    var actionsTableViewAlphaOne = false
    var shouldAnimate = true
    var actionsTableViewReloadData = false
    var leaders = [String]()
    var selectedOrgMbrCallingUid = ""
    var changeInCalling = false
    var membersNeedingToBeReleasedCount = 0
    var membersNeedingToBeSustainedCount = 0
    var selectedMember = ""
    var membersAndTheirCallings = [[String: String]]()
    var selectedMemberAndCallings = [String: String]()
    var leadership = [String]()
    var recommendations = [Recommendation]()
    var membersSubmittedForRecommendation: [String] = [String]()

    var currentActionTypeModel = OrgMbrCalling()
    
    var nextActionTypeMessage = ""
    
    static let shared = OrgMbrCallingViewModel()
    static var hasInitialized = false
    
    let disclosureGroupHeader = ["Approved Calls to Extend", "Releases", "Setting Aparts", "Interviews"]
    let actionsDisclosureGroupHeader = ["Member", "Calling", "Action"]
    
    public init(currentActionTypeModel: OrgMbrCalling = OrgMbrCalling(),
                orgMbrCallings: [OrgMbrCalling] = [OrgMbrCalling](),
                selectedCallingInOrganization: OrgMbrCalling = OrgMbrCalling(),
                currentlySelectedMember: String = "") {
        self.orgMbrCallings = orgMbrCallings
        self.selectedCallingInOrganization = selectedCallingInOrganization
        
        super.init()

        self.selectedCallingInOrganization.memberName = currentlySelectedMember
        self.currentActionTypeModel = currentActionTypeModel
                
        NotificationCenter.default.addObserver(self, selector: #selector(fetchOrgMbrCalling), name: NSNotification.Name(NotificationNames.fetchOrganization.stringValue), object: nil)
        
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
        if !AppDelegate.unitNumber.isEmpty {
            fetchData {
                if self.orgMbrCallings.isEmpty {
                        if !OrgMbrCallingViewModel.hasInitialized {
                                self.createOrganizationMemberCalling(from: getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_OrgMbrCalling")) { results in
                                    self.getOrgMbrCallingActions(forMe: false,
                                                                 leader: "",
                                                                 byOrganization: false,
                                                                 organization: "") { results in
                                        
                                    }

                                    OrgMbrCallingViewModel.hasInitialized = true
                                }
                        }
                } else {
                    self.orgMbrCallings = self.sortOrgMbrCallings()
                }
                
                self.fetchStakePresidencyMembers()
            }
        }
    }
    
    func fetchOrgMbrCallings(completion: @escaping (Bool) -> Void) {
        fetchData {
            if self.orgMbrCallings.isEmpty {
                Task.init {
                    self.createOrganizationMemberCalling(from: getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_OrgMbrCalling")) { results in
                        self.getOrgMbrCallingActions(forMe: false,
                                                     leader: "",
                                                     byOrganization: false,
                                                     organization: "") { results in
                            if results {
                                OrgMbrCallingViewModel.hasInitialized = true
                                
                                completion(true)
                            }
                        }
                    }
                }
            } else {
                self.fetchStakePresidencyMembers()
                self.orgMbrCallings = self.sortOrgMbrCallings()
                
                completion(true)
            }
        }
        
        completion(false)
    }
    
    @objc func fetchOrgMbrCalling() {
        fetchOrgMbrCallings() { _ in
            
        }
    }
    
    func removeRecommendation(member: String) {
        for (index, recommendation) in recommendations.enumerated() {
            if recommendation.member == member {
                recommendations.remove(at: index)
            }
        }
    }
    
    func createOrganizationMemberCalling(from json: JSONDictionary, completion: (_ results: String) -> Void) {
        if let stakeNumber = json["stakeNumber"] as? String {
            defaults.set(stakeNumber, forKey: "stakeNumber")
            AppDelegate.stakeNumber = stakeNumber
        }

        if let organizations = json["organizations"] as? [[String: Any]] {
            for organization in organizations {
                if let callings = organization["callings"] as? [[String: Any]] {
                    for call in callings {
                        if organization[DictionaryKeys.organizationName.rawValue] as! String == Constants.stakePresidencyOrganizationIdentifier {
                            switch call[DictionaryKeys.callingName.rawValue] as! String {
                            case Constants.presidentIdentifier:
                                defaults.set(call[DictionaryKeys.memberName.rawValue], forKey: LeadersPresidingAtSacrament.stakePresident.stringValue)
                            case Constants.firstCounselorIdentifier:
                                defaults.set(call[DictionaryKeys.memberName.rawValue], forKey: LeadersPresidingAtSacrament.stakePresidencyFirstCounselor.stringValue)
                            case Constants.secondCounselorIdentifier:
                                defaults.set(call[DictionaryKeys.memberName.rawValue], forKey: LeadersPresidingAtSacrament.stakePresidencySecondCounselor.stringValue)
                            default:
                                break
                            }
                        }
                        
                        if organization[DictionaryKeys.organizationName.rawValue] as! String == Constants.bishopricOrganizationIdentifier {
                            switch call[DictionaryKeys.callingName.rawValue] as! String {
                            case Constants.bishopIdentifier:
                                defaults.set(call[DictionaryKeys.memberName.rawValue], forKey: LeadershipPositions.bishop.stringValue)
                            case Constants.firstCounselorIdentifier:
                                defaults.set(call[DictionaryKeys.memberName.rawValue], forKey: LeadershipPositions.bishopricFirstCounselor.stringValue)
                            case Constants.secondCounselorIdentifier:
                                defaults.set(call[DictionaryKeys.memberName.rawValue], forKey: LeadershipPositions.bishopricSecondCounselor.stringValue)
                            default:
                                break
                            }
                        }
                        
                        if !organizationsTableViewDataSource.isEmpty {
                            if !organizationExists(in: organizationsTableViewDataSource, organizationName: organization[DictionaryKeys.organizationName.rawValue] as! String) {
                                
                                organizationsTableViewDataSource.append(organization[DictionaryKeys.organizationName.rawValue] as! String)
                            }
                        } else {
                            organizationsTableViewDataSource.append(organization[DictionaryKeys.organizationName.rawValue] as! String)
                        }
                        
//                        var callingDisplayIndex = ""
                        
//                        if (call[DictionaryKeys.callingDisplayIndex.rawValue] as! String) == "" {
//                            if (call[DictionaryKeys.callingName.rawValue] as! String) == "President" {
//                                callingDisplayIndex = "1"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String) == "First Counselor" {
//                                callingDisplayIndex = "2"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String) == "Second Counselor" {
//                                callingDisplayIndex = "3"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String) == "Secretary" {
//                                callingDisplayIndex = "4"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Class President") {
//                                callingDisplayIndex = "5"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Class First Counselor") {
//                                callingDisplayIndex = "6"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Class Second Counselor") {
//                                callingDisplayIndex = "7"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Class Secretary") {
//                                callingDisplayIndex = "8"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Specialist Camp Director") {
//                                callingDisplayIndex = "9"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Specialist Assistant Camp Director 1") {
//                                callingDisplayIndex = "10"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Specialist Assistant Camp Director 2") {
//                                callingDisplayIndex = "11"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("First Assistant") {
//                                callingDisplayIndex = "1"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Second Assistant") {
//                                callingDisplayIndex = "2"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Priest Quorum Secretary") {
//                                callingDisplayIndex = "3"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Advisor 1") {
//                                callingDisplayIndex = "4"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Advisor 2") {
//                                callingDisplayIndex = "5"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Specialist") {
//                                callingDisplayIndex = "6"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Primary Pianist 1") {
//                                callingDisplayIndex = "5"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Primary Pianist 2") {
//                                callingDisplayIndex = "6"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Primary Music Leader") {
//                                callingDisplayIndex = "7"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Valiant 8 Teacher 1") {
//                                callingDisplayIndex = "8"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Valiant 8 Teacher 2") {
//                                callingDisplayIndex = "9"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 7 Teacher 2") {
//                                callingDisplayIndex = "10"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 6 Teacher 2") {
//                                callingDisplayIndex = "11"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 4 Teacher 3") {
//                                callingDisplayIndex = "12"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Valiant 10 Teacher 1") {
//                                callingDisplayIndex = "13"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Valiant 10 Teacher 2") {
//                                callingDisplayIndex = "14"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Sunbeam Teacher 2") {
//                                callingDisplayIndex = "15"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Sunbeam Teacher 1") {
//                                callingDisplayIndex = "16"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 7 Teacher 1") {
//                                callingDisplayIndex = "17"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 4 Teacher 2") {
//                                callingDisplayIndex = "18"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 4 Teacher 1") {
//                                callingDisplayIndex = "19"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("CTR 6 Teacher 1") {
//                                callingDisplayIndex = "20"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Worker 1") {
//                                callingDisplayIndex = "21"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Worker 2") {
//                                callingDisplayIndex = "22"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Worker 3") {
//                                callingDisplayIndex = "23"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Nursery Leader 1") {
//                                callingDisplayIndex = "24"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Nursery Leader 2") {
//                                callingDisplayIndex = "25"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Nursery Leader 3") {
//                                callingDisplayIndex = "26"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Nursery Leader 4") {
//                                callingDisplayIndex = "27"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Nursery Leader 5") {
//                                callingDisplayIndex = "28"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Girls 1") {
//                                callingDisplayIndex = "29"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Boys 1") {
//                                callingDisplayIndex = "30"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Girls 2") {
//                                callingDisplayIndex = "31"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Girls 3") {
//                                callingDisplayIndex = "33"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Boys 2") {
//                                callingDisplayIndex = "32"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Boys 3") {
//                                callingDisplayIndex = "34"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Activity Leader Girls 4") {
//                                callingDisplayIndex = "35"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Teacher 1") {
//                                callingDisplayIndex = "5"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Teacher 2") {
//                                callingDisplayIndex = "6"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Teacher 3") {
//                                callingDisplayIndex = "7"
//                            } else if (call[DictionaryKeys.callingName.rawValue] as! String).contains("Teacher 4") {
//                                callingDisplayIndex = "8"
//                            }
//                        }
                        
                        let uid = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                        let ldrAssignToCall = "Bishopric First Counselor"
                        let ldrAssignToSetApart = "Bishopric First Counselor"
                        
                        if let callingName = call[DictionaryKeys.callingName.rawValue] as? String, let memberName = call[DictionaryKeys.memberName.rawValue] as? String, let organizationName = organization[DictionaryKeys.organizationName.rawValue] as? String, let memberToBeReleased = call[DictionaryKeys.memberToBeReleased.rawValue] as? String, let approvedDate = call[DictionaryKeys.approvedDate.rawValue] as? String, let calledDate = call[DictionaryKeys.calledDate.rawValue] as? String, let sustainedDate = call[DictionaryKeys.sustainedDate.rawValue] as? String, let setApartDate = call[DictionaryKeys.setApartDate.rawValue] as? String, let releasedDate = call[DictionaryKeys.releasedDate.rawValue] as? String, let recommendedDate = call[DictionaryKeys.recommendedDate.rawValue] as? String, /*let ldrAssignToCall =  call[DictionaryKeys.ldrAssignToCall.rawValue] as? String, let ldrAssignToSetApart =  call[DictionaryKeys.ldrAssignToSetApart.rawValue] as? String,*/ let callingPreviouslyFilledDate = call[DictionaryKeys.callingPreviouslyFilledDate.rawValue] as? String, let callingDisplayIndex = call[DictionaryKeys.callingDisplayIndex.rawValue] as? String, let callingAction = call[DictionaryKeys.callingAction.rawValue] as? String, let recommendations = call[DictionaryKeys.recommendations.rawValue] as? String {
                            
                            var orgMbrCall = OrgMbrCalling(uid: uid, callingName: callingName, organizationName: organizationName, memberName: memberName, memberToBeReleased: memberToBeReleased, approvedDate: approvedDate, calledDate: calledDate, sustainedDate: sustainedDate, setApartDate: setApartDate, releasedDate: releasedDate, recommendedDate: recommendedDate, ldrAssignToCall: ldrAssignToCall, ldrAssignToSetApart: ldrAssignToSetApart, callingPreviouslyFilledDate: callingPreviouslyFilledDate, callingDisplayIndex: callingDisplayIndex, callingAction: callingAction, recommendations: recommendations)
                            
                            orgMbrCall.id = uid
                            
                            if !orgMbrCallingExists(orgMbrCalling: orgMbrCall) {
                                self.addOrgMbrCallingDocument(orgMbrCalling: orgMbrCall) { results in
                                    if results.contains("Success") {
                                        CoreDataManager.shared.addOrgMbrCalling(orgMbrCalling: orgMbrCall) { results in
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completion("Success")
        }
        completion("Error")
    }
    
    func orgMbrCallingExists(orgMbrCalling: OrgMbrCalling) -> Bool {
        var exists = false
        
        for omCallings in orgMbrCallings {
            if omCallings.organizationName == orgMbrCalling.organizationName && omCallings.callingName == orgMbrCalling.callingName {
                exists = true
            }
        }
        
        return exists
    }
    
    func resetRecommendedChanges(for model: OrgMbrCalling) {
        var elementIndexsForRemoval = [Int]()
        for (index, recommendations) in recommendationsForApproval.enumerated() {
            if recommendations.recommendations.isEmpty {
                recommendationsForApproval.remove(at: index)
            } else if recommendations.organizationName == model.organizationName && recommendations.callingName == model.callingName {
                elementIndexsForRemoval.append(index)
            }
        }
        
        if let firstElement = elementIndexsForRemoval.first, let lastElement = elementIndexsForRemoval.last {
            recommendationsForApproval.removeSubrange(firstElement...lastElement)
        }
    }
    
    func fetchStakePresidencyMembers() {
        for orgMbrCalling in orgMbrCallings {
            if orgMbrCalling.organizationName == "Stake Presidency" {
                switch orgMbrCalling.callingName {
                case Constants.presidentIdentifier:
                    defaults.set(orgMbrCalling.memberName, forKey: LeadersPresidingAtSacrament.stakePresident.stringValue)
                case Constants.firstCounselorIdentifier:
                    defaults.set(orgMbrCalling.memberName, forKey: LeadersPresidingAtSacrament.stakePresidencyFirstCounselor.stringValue)
                case Constants.secondCounselorIdentifier:
                    defaults.set(orgMbrCalling.memberName, forKey: LeadersPresidingAtSacrament.stakePresidencySecondCounselor.stringValue)
                default:
                    break
                }
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if Network.shared.hasConnection {
            let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.orgMbrCalling.rawValue)").order(by: "organizationName")

            ref?.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    completion()
                    return
                }
                
                self.orgMbrCallings = documents.compactMap {
                    (queryDocumentSnapshot) -> OrgMbrCalling? in
                    let data = queryDocumentSnapshot.data()
                    
                    let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                    let callingName = data[DictionaryKeys.callingName.rawValue] as? String ?? ""
                    let memberName = data[DictionaryKeys.memberName.rawValue] as? String ?? ""
                    let organizationName = data[DictionaryKeys.organizationName.rawValue] as? String ?? ""
                    let memberToBeReleased = data[DictionaryKeys.memberToBeReleased.rawValue] as? String ?? ""
                    let approvedDate = data[DictionaryKeys.approvedDate.rawValue] as? String ?? ""
                    let calledDate = data[DictionaryKeys.calledDate.rawValue] as? String ?? ""
                    let sustainedDate = data[DictionaryKeys.sustainedDate.rawValue] as? String ?? ""
                    let setApartDate = data[DictionaryKeys.setApartDate.rawValue] as? String ?? ""
                    let releasedDate = data[DictionaryKeys.releasedDate.rawValue] as? String ?? ""
                    let recommendedDate = data[DictionaryKeys.recommendedDate.rawValue] as? String ?? ""
                    let ldrAssignToCall = data[DictionaryKeys.ldrAssignToCall.rawValue] as? String ?? ""
                    let ldrAssignToSetApart = data[DictionaryKeys.ldrAssignToSetApart.rawValue] as? String ?? ""
                    let callingPreviouslyFilledDate = data[DictionaryKeys.callingPreviouslyFilledDate.rawValue] as? String ?? ""
                    let callingDisplayIndex = data[DictionaryKeys.callingDisplayIndex.rawValue] as? String ?? ""
                    let callingAction = data[DictionaryKeys.callingAction.rawValue] as? String ?? ""
                    let recommendations = data[DictionaryKeys.recommendations.rawValue] as? String ?? ""

                    var orgMbrCall = OrgMbrCalling(uid: uid, callingName: callingName, organizationName: organizationName, memberName: memberName, memberToBeReleased: memberToBeReleased, approvedDate: approvedDate, calledDate: calledDate, sustainedDate: sustainedDate, setApartDate: setApartDate, releasedDate: releasedDate, recommendedDate: recommendedDate, ldrAssignToCall: ldrAssignToCall, ldrAssignToSetApart: ldrAssignToSetApart, callingPreviouslyFilledDate: callingPreviouslyFilledDate, callingDisplayIndex: callingDisplayIndex, callingAction: callingAction, recommendations: recommendations)
                    
                    orgMbrCall.id = uid
                                    
                    return orgMbrCall
                }
                
                completion()
            }
        } else {
            if let orgMbrCallingEntities = CoreDataManager.shared.getOrgMbrCallings(with: nil) {
                orgMbrCallings = DataManager.shared.convertArrayOfOrgMbrCallingEntitiesToCallingModels(entities: orgMbrCallingEntities)
                completion()
            }
        }
    }
    
    func callingsForMember(name: String) -> [String: String] {
        var callings = ""
        for orgMbrCall in orgMbrCallings {
            if orgMbrCall.memberName == name {
                callings += orgMbrCall.callingName + " : " + orgMbrCall.organizationName
            }
        }
        
        if callings.isEmpty {
            callings = "Member without Calling"
        }
        
        return [DictionaryKeys.memberName.rawValue: name, DictionaryKeys.callingName.rawValue: callings]
    }
    
    func organizationExists(in data: [String], organizationName: String) -> Bool {
        for organization in data/*OrganizationsViewModel.shared.tableViewDataSource*/ {
            if organization == organizationName {
                return true
            }
        }
        
        return false
    }
    
    func addOrgMbrCallingDocument(orgMbrCalling: OrgMbrCalling, completion: @escaping ( _ results: String ) -> Void) {
        var ref: DocumentReference? = nil
        ref = self.db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.orgMbrCalling.rawValue)").document(orgMbrCalling.uid)
        
        ref?.setData([
            DictionaryKeys.uid.rawValue: ref!.documentID,
            DictionaryKeys.callingName.rawValue: orgMbrCalling.callingName,
            DictionaryKeys.memberName.rawValue: orgMbrCalling.memberName,
            DictionaryKeys.organizationName.rawValue: orgMbrCalling.organizationName,
            DictionaryKeys.memberToBeReleased.rawValue: orgMbrCalling.memberToBeReleased,
            DictionaryKeys.approvedDate.rawValue: orgMbrCalling.approvedDate,
            DictionaryKeys.calledDate.rawValue: orgMbrCalling.calledDate,
            DictionaryKeys.sustainedDate.rawValue: orgMbrCalling.sustainedDate,
            DictionaryKeys.setApartDate.rawValue: orgMbrCalling.setApartDate,
            DictionaryKeys.releasedDate.rawValue: orgMbrCalling.releasedDate,
            DictionaryKeys.recommendedDate.rawValue: orgMbrCalling.recommendedDate,
            DictionaryKeys.ldrAssignToCall.rawValue: orgMbrCalling.ldrAssignToCall,
            DictionaryKeys.ldrAssignToSetApart.rawValue: orgMbrCalling.ldrAssignToSetApart,
            DictionaryKeys.callingPreviouslyFilledDate.rawValue: orgMbrCalling.callingPreviouslyFilledDate,
            DictionaryKeys.callingDisplayIndex.rawValue: orgMbrCalling.callingDisplayIndex,
            DictionaryKeys.callingAction.rawValue: orgMbrCalling.callingAction,
            DictionaryKeys.recommendations.rawValue: orgMbrCalling.recommendations
        ]) { err in
            if let err = err {
                completion("Error adding orgMbrCalling document: \(err.localizedDescription)")
            } else {
                completion("Success adding orgMbrCalling document with ID: \(ref!.documentID)")
            }
        }
    }
        
    func updateCurrentOrgMbrCalling(model: OrgMbrCalling, completion: @escaping () -> Void) {
        updateOrgMbrCallingDocument(orgMbrCalling: model) {
            CoreDataManager.shared.updateCalling(model: model) {
                completion()
            }
        }
    }
    
    func updateOrgMbrCallingDocument(orgMbrCalling: OrgMbrCalling, completion: @escaping () -> Void) {
        let documentId = "\(orgMbrCalling.uid)"
        let orgMbrCallingDictionary = DataManager.shared.convertOrgMbrCallingModelToDictionary(model: orgMbrCalling)
        
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.orgMbrCalling.rawValue)").document(documentId).updateData(orgMbrCallingDictionary)
        
        completion()
    }
    
    func leaderExists(leader: String) -> Bool {
        for ldr in leadership {
            if ldr == leader {
                return true
            }
        }
        
        return false
    }
    
    func getLeadership(selectedModel: OrgMbrCalling, completion: @escaping ((_ name: [String]) -> Void)) {
        var bishopOrBranchPresidentOnly = false
        var stakePresidentOnly = false
        
        let unitType = defaults.string(forKey: UserDefaultKeys.unitType.stringValue)
        
        var bishopOrPresident = ""
        var firstCounselor = ""
        var secondCounselor = ""
        
        let fullCallingName = selectedModel.organizationName + " " + selectedModel.callingName
        
        if unitType == UnitTypes.ward.stringValue {
            if fullCallingName == "Relief Society President" || fullCallingName == "Young Women President" || fullCallingName == "Primary President" || fullCallingName == "Sunday School President" || fullCallingName == "Priest Quorum Assistant" {
                if !leaderExists(leader: LeadershipPositions.bishop.stringValue) {
                    leadership.append(LeadershipPositions.bishop.stringValue)
                    bishopOrBranchPresidentOnly = true
                }
                
                completion(leadership)
            }
            
            bishopOrPresident = LeadershipPositions.bishop.stringValue
        } else if unitType == UnitTypes.branch.stringValue {
            bishopOrPresident = LeadershipPositions.branchPresident.stringValue
        } else {
            if selectedModel.callingName == "Bishop" || selectedModel.callingName == "Elders Quorum President" || selectedModel.callingName == "Branch President" || selectedModel.callingName == "Stake Presidency First Counselor" || selectedModel.callingName == "Stake Presidency Second Counselor" || selectedModel.callingName == "Stake Patriarch" || selectedModel.callingName == "Stake Relief Society President" {
                if !leaderExists(leader: LeadershipPositions.stakePresident.stringValue) {
                    leadership.append(LeadershipPositions.stakePresident.stringValue)
                    stakePresidentOnly = true
                }
                
                completion(leadership)
            }
            
            bishopOrPresident = LeadershipPositions.stakePresident.stringValue
        }
        
        if !bishopOrBranchPresidentOnly && !stakePresidentOnly {
            if let unitType = unitType {
                getLeaders(for: unitType)
                completion(leadership)
            }
        }
    }
    
    func getLeaders(for unitType: String) {
        var bishopOrPresident = ""
        var firstCounselor = ""
        var secondCounselor = ""

        if unitType == UnitTypes.ward.stringValue {
            bishopOrPresident = LeadershipPositions.bishop.stringValue
        } else if unitType == UnitTypes.branch.stringValue {
            bishopOrPresident = LeadershipPositions.branchPresident.stringValue
        } else {
            bishopOrPresident = LeadershipPositions.stakePresident.stringValue
        }
        
        if unitType == UnitTypes.ward.stringValue {
            firstCounselor = LeadershipPositions.bishopricFirstCounselor.stringValue
        } else if unitType == UnitTypes.branch.stringValue {
            firstCounselor = LeadershipPositions.branchPresidencyFirstCounselor.stringValue
        } else {
            firstCounselor = LeadershipPositions.stakePresidencyFirstCounselor.stringValue
        }
        
        if unitType == UnitTypes.ward.stringValue {
            secondCounselor = LeadershipPositions.bishopricSecondCounselor.stringValue
        } else if unitType == UnitTypes.branch.stringValue {
            secondCounselor = LeadershipPositions.branchPresidencySecondCounselor.stringValue
        } else {
            secondCounselor = LeadershipPositions.stakePresidencySecondCounselor.stringValue
        }
        
        if !leaderExists(leader: bishopOrPresident) {
            leadership.append(bishopOrPresident)
        }
        
        if !leaderExists(leader: firstCounselor) {
            leadership.append(firstCounselor)
        }

        if !leaderExists(leader: secondCounselor) {
            leadership.append(secondCounselor)
        }
    }
    
    func updateCallingAction(actionType: ActionTypes, orgMbrCalling: OrgMbrCalling) {
        var recommendedDate = orgMbrCalling.recommendedDate
        var approvedDate = orgMbrCalling.approvedDate
        var calledDate = orgMbrCalling.calledDate
        var sustainedDate = orgMbrCalling.sustainedDate
        var setApartDate = orgMbrCalling.setApartDate
        var releasedDate = orgMbrCalling.releasedDate
        var callingAction = orgMbrCalling.callingAction
        var memberInCalling = ""
        
        switch actionType {
        case .recommendationsForApproval:
            break
        case .recommendationNotApproved:
            recommendedDate = ""
            callingAction = ""
            memberInCalling = orgMbrCalling.memberToBeReleased
        case .recommendationApproved:
            recommendedDate = convertToString(date: Date(), with: .medium)
            approvedDate = convertToString(date: Date(), with: .medium)
            callingAction = String(ActionTypes.extendCall.rawValue)
        case .callAccepted:
            calledDate = convertToString(date: Date(), with: .medium)
            callingAction = String(ActionTypes.toBeSustained.rawValue)
        case .callDeclined:
            recommendedDate = ""
            approvedDate = ""
            calledDate = ""
            callingAction = ""
            memberInCalling = orgMbrCalling.memberToBeReleased
        case .sustained, .toBeSustained:
            sustainedDate = convertToString(date: Date(), with: .medium)
            callingAction = String(ActionTypes.setApart.rawValue)
        case .setApart:
            setApartDate = convertToString(date: Date(), with: .medium)
            callingAction = String(ActionTypes.callingReadyForUpdateOnWeb.rawValue)
        case .released:
            releasedDate = convertToString(date: Date(), with: .medium)
            callingAction = String(ActionTypes.toBeSustained.rawValue)
        case .noFurtherActionRequired:
            releasedDate = convertToString(date: Date(), with: .medium)
        default:
            break
        }
        
        var omc = OrgMbrCalling(uid: orgMbrCalling.uid,
                                          callingName: orgMbrCalling.callingName,
                                          organizationName: orgMbrCalling.organizationName,
                                          memberName: memberInCalling.isEmpty ? orgMbrCalling.memberName : memberInCalling,
                                          memberToBeReleased: orgMbrCalling.memberToBeReleased,
                                          approvedDate: approvedDate,
                                          calledDate: calledDate,
                                          sustainedDate: sustainedDate,
                                          setApartDate: setApartDate,
                                          releasedDate: releasedDate,
                                          recommendedDate: recommendedDate,
                                          ldrAssignToCall: orgMbrCalling.ldrAssignToCall,
                                          ldrAssignToSetApart: orgMbrCalling.ldrAssignToSetApart,
                                          callingPreviouslyFilledDate: orgMbrCalling.callingPreviouslyFilledDate,
                                          callingDisplayIndex: orgMbrCalling.callingDisplayIndex,
                                callingAction: callingAction, recommendations: "")
        
        omc.id = orgMbrCalling.uid
        
        updateCurrentOrgMbrCalling(model: omc) {
            self.fetchData {
                self.getOrgMbrCallingActions(forMe: false,
                                             leader: "",
                                             byOrganization: false,
                                             organization: "") { results in }
            }
        }
    }
    
    func getOrgMbrCallings(for organization: String) -> [OrgMbrCalling]? {
        var organizationMemberCallings = [OrgMbrCalling]()
        
        for orgMbrCalling in orgMbrCallings {
            if orgMbrCalling.organizationName == organization {
                organizationMemberCallings.append(orgMbrCalling)
            }
        }
        
        return organizationMemberCallings
    }
    
    func getOrgMbrCallingActions(forMe: Bool,
                                 leader: String,
                                 byOrganization: Bool,
                                 organization: String,
                                 completion: @escaping (Bool) -> Void) {
        
        recommendationsForApproval.removeAll()
        callsToBeExtended.removeAll()
        toBeSustained.removeAll()
        settingAparts.removeAll()
        membersNeedingToBeReleased.removeAll()
        callingActionsInSelectedOrganization.removeAll()
        
        membersNeedingToBeReleasedCount = 0
        membersNeedingToBeSustainedCount = 0

        let orgMbrCalls = OrgMbrCallingViewModel.shared.orgMbrCallings

        for orgMbrCalling in orgMbrCalls {
            
            if byOrganization {
                if orgMbrCalling.organizationName != organization {
                    continue
                }
            }
            
            if orgMbrCalling.memberName == "" {
                continue
            }
            
            switch Int(orgMbrCalling.callingAction) {
            case ActionTypes.recommendationsForApproval.rawValue:
                let recommendations = DataManager.shared.convertRecommendationsStringToArrayOfRecommendations(recommendationsString: orgMbrCalling.recommendations)
                                
                if !recommendations.isEmpty  {
                    let recommendedCallingChanges = RecommendedCallingChanges(uid: orgMbrCalling.uid, organizationName: orgMbrCalling.organizationName, callingName: orgMbrCalling.callingName, memberName: orgMbrCalling.memberName, recommendations: recommendations)
                    
                    recommendationsForApproval.append(recommendedCallingChanges)
                }
            case ActionTypes.recommendationApproved.rawValue, ActionTypes.extendCall.rawValue:
                callsToBeExtended.append(orgMbrCalling)
            case ActionTypes.callAccepted.rawValue:
                toBeSustained.append(orgMbrCalling)
            case ActionTypes.toBeSustained.rawValue:
                toBeSustained.append(orgMbrCalling)
                if orgMbrCalling.releasedDate.isEmpty {
                    membersNeedingToBeReleased.append(orgMbrCalling)
                }
            case ActionTypes.setApart.rawValue:
                settingAparts.append(orgMbrCalling)
            case ActionTypes.needsToBeReleased.rawValue:
                membersNeedingToBeReleased.append(orgMbrCalling)
            default:
                break
            }
        }

        if self.recommendationsForApproval.isEmpty && self.callsToBeExtended.isEmpty && self.toBeSustained.isEmpty && self.settingAparts.isEmpty && self.membersNeedingToBeReleased.isEmpty {
            completion(false)
        }

        completion(true)
    }
    
    func findOrgMbrCalling(for selectedRecommendation: RecommendedCallingChanges) -> OrgMbrCalling? {
        for orgMbrCalling in orgMbrCallings {
            if selectedRecommendation.uid == orgMbrCalling.uid {
                return orgMbrCalling
            }
        }
        
        return nil
    }
    
    func getLeaderName() -> String {
        getMemberNamesForLeaders()
        
        var leaderName = ""
        
        if let signedInLeaderPosition = defaults.string(forKey: UserDefaultKeys.leaderPosition.stringValue) {
            leaderName = defaults.string(forKey: signedInLeaderPosition) ?? ""
            leaderName = formatFullName(name: leaderName)
        }
        
        return leaderName
    }
    
    func getMemberNamesForLeaders() {
        for orgMbrCalling in orgMbrCallings {
            if orgMbrCalling.organizationName == Constants.bishopricOrganizationIdentifier {
                var leaderTitle = ""
                var callingNameOnly = ""
                
                let defaults = UserDefaults.standard
                
                if let signedInLeaderPosition = defaults.string(forKey: UserDefaultKeys.leaderPosition.stringValue) {
                    if let startIndex = signedInLeaderPosition.index(of: " ") {
                        callingNameOnly = String(signedInLeaderPosition[signedInLeaderPosition.index(startIndex, offsetBy: 1)..<signedInLeaderPosition.endIndex])
                    }
                    
                    if callingNameOnly == orgMbrCalling.callingName {
                        switch signedInLeaderPosition /*leaderTitle*/ {
                        case LeadershipPositions.bishop.stringValue:
                            defaults.set(orgMbrCalling.memberName, forKey: LeadershipPositions.bishop.stringValue)
                        case LeadershipPositions.bishopricFirstCounselor.stringValue:
                            defaults.set(orgMbrCalling.memberName, forKey: LeadershipPositions.bishopricFirstCounselor.stringValue)
                        case LeadershipPositions.bishopricSecondCounselor.stringValue:
                            defaults.set(orgMbrCalling.memberName, forKey: LeadershipPositions.bishopricSecondCounselor.stringValue)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
@MainActor func getCallings(for member: String) -> [OrgMbrCalling]? {
    var memberCallings = [OrgMbrCalling]()
    
    let orgMbrCallings = OrgMbrCallingViewModel.shared.orgMbrCallings
    if orgMbrCallings.count == 0 {
        return nil
    }
    
    for orgMbrCalling in orgMbrCallings {
        if orgMbrCalling.memberName == member {
            memberCallings.append(orgMbrCalling)
        }
    }
    
    return memberCallings
}
    
    func sortOrgMbrCallings() -> [OrgMbrCalling] {
        orgMbrCallings.sorted { Double($0.callingDisplayIndex) ?? 0.0 > Double($1.callingDisplayIndex) ?? 0.0 }
    }
 }

