//
//  AssignmentsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 5/11/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class AssignmentsViewModel: BaseViewModel {
    @Published var assignments = [Assignment]()
    @Published var assignmentSnapshotSectionTitles: [String] = [AssignmentSnapshotDisclosureGroups.approvedCallsToExtend.rawValue,AssignmentSnapshotDisclosureGroups.releases.rawValue,AssignmentSnapshotDisclosureGroups.settingAparts.rawValue,AssignmentSnapshotDisclosureGroups.interviews.rawValue]

    static let shared = AssignmentsViewModel()
    static var hasInitialized = false
    
    public init(assignments: [Assignment] = [Assignment]()) {
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
        }
    }
    
    func addAssignmentDocument(assignment: Assignment, completion: @escaping () -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.assignments.rawValue)").document("\(assignment.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: assignment.uid, DictionaryKeys.organizationName.rawValue: assignment.organizationName,
                      DictionaryKeys.callingName.rawValue: assignment.callingName,
                      DictionaryKeys.memberName.rawValue: assignment.memberName,
                      DictionaryKeys.actionType.rawValue: assignment.actionType]) { err in
            if let err = err {
                print("Error adding assignment document: \(err)")
                completion()
            } else {
                print("collection Document added with ID: \(ref!.documentID)")
                completion()
            }
        }
    }
    
    func deleteSnapshot(assignment: Assignment, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.assignments.rawValue)").document(assignment.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion()
            } else {
                print("Document successfully removed!")
                completion()
            }
        }
    }

    
    func fetchData(completion: @escaping () -> Void) {
        
        let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.assignments.rawValue)") //.order(by: DictionaryKeys.name.rawValue, descending: false)
        
        ref?.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.assignments = documents.compactMap { (queryDocumentSnapshot) -> Assignment? in
                let data = queryDocumentSnapshot.data()
                
                let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                let organization = data[DictionaryKeys.organizationName.rawValue] as? String ?? ""
                let calling = data[DictionaryKeys.callingName.rawValue] as? String ?? ""
                let member = data[DictionaryKeys.memberName.rawValue] as? String ?? ""
                let actionType = data[DictionaryKeys.actionType.rawValue] as? Int ?? 0
                
                return Assignment(uid: uid, organizationName: organization, callingName: calling, memberName: member, actionType: actionType)
            }
            
            completion()
        }
    }
}
