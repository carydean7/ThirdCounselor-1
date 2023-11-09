//
//  OrganizationsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class OrganizationsViewModel: BaseViewModel {
    @Published var organizations = [Organization]()
    @Published var currentlySelectedOrganization: Organization = Organization(uid: "", name: "")

    var organizationName: String = ""
    var tableViewDataSource: [Organization]? = []
        
    static let shared = OrganizationsViewModel()
    static var hasInitialized = false
    
    public init(organizations: [Organization] = [Organization]()) {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchOrganizations), name: NSNotification.Name(NotificationNames.fetchOrganization.stringValue), object: nil)
        
        self.organizations = organizations
        
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
            if self.organizations.isEmpty {
                Task.init {
                    if !OrganizationsViewModel.hasInitialized {
                        await self.createOrganization(from: getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_Organizations"))
                        
                        OrganizationsViewModel.hasInitialized = true
                    }
                }
            }
        }
    }
    
    @objc func fetchOrganizations() {
        fetchData {
            if self.organizations.isEmpty {
                Task.init {
                    await self.createOrganization(from: getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_Organizations"))
                }
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if Network.shared.hasConnection {
            let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.organizations.rawValue)").order(by: "name", descending: false)
            
            ref?.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                            
                self.organizations = documents.compactMap { (queryDocumentSnapshot) -> Organization? in
                    let data = queryDocumentSnapshot.data()
                    
                    let name = data["name"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""

                    return Organization(uid: uid, name: name)
                }
                
                completion()
            }
        } else {
            if let organizationEntities = CoreDataManager.shared.getAllOrganizations() {
                organizations = DataManager.shared.convertArrayOfOrganizationEntitiesToOrganizationModels(entities: organizationEntities)
                completion()
            }
        }
    }
    
    func createOrganization(from json: JSONDictionary) async {
        if let orgs = json["organizations"] as? [[String: Any]] {
            for aOrg in orgs {
                if let organizationName: String = aOrg[DictionaryKeys.name.rawValue] as? String {
                    self.organizationExistsInOrganizations(name: organizationName) { exists in
                        if !exists {

                            let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                            let organization = Organization(id: id, uid: id, name: organizationName)

                            self.addOrganizationDocument(organization: organization) { results in
                                if results.contains("Success") {

                                    CoreDataManager.shared.addOrganization(organization: organization) { results in
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func organizationExistsInOrganizations(name: String, completion: @escaping (Bool) -> Void) {
        for organization in self.organizations {
            if organization.name == name {
                completion(true)
            }
        }
        
        completion(false)
    }

    func addOrganizationDocument(organization: Organization, completion: @escaping (_ results: String ) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.organizations.rawValue)").document(organization.uid)
        
        ref?.setData([DictionaryKeys.uid.rawValue: organization.uid, DictionaryKeys.name.rawValue: organization.name]) { err in
            if let err = err {
                completion("Error adding organization document: \(err.localizedDescription)")
            } else {
                completion("Success adding organization document with ID: \(ref!.documentID)")
            }
        }
    }
    
    func deleteOrganization(organization: Organization) {
        deleteOrganizationDocument(organization: organization) {
            CoreDataManager.shared.deleteOrganization(uid: organization.uid) {
                self.fetchData {
                    
                }
            }
        }
    }
    
    func deleteOrganizationDocument(organization: Organization, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.organizations.rawValue)").document(organization.uid).delete() { err in
            if let err = err {
                print("Error removing organization document: \(err)")
                completion()
            } else {
                print("Organization document successfully removed!")
                completion()
            }
        }
    }

}
