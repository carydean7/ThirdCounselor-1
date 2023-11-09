//
//  OrdinationsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/30/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class OrdinationsViewModel: BaseViewModel {
    @Published var wardBranchOrdinationSectionTitles: [String] = [
        OrdinationOfficeCategories.deacon.rawValue,
        OrdinationOfficeCategories.teacher.rawValue,
        OrdinationOfficeCategories.priest.rawValue,
        OrdinationOfficeCategories.elder.rawValue,
        OrdinationOfficeCategories.highPriest.rawValue
   ]
    
    @Published var stakeOrdinationSectionTitles: [String] = [
        OrdinationOfficeCategories.bishop.rawValue,
        OrdinationOfficeCategories.elder.rawValue,
        OrdinationOfficeCategories.highPriest.rawValue,
        OrdinationOfficeCategories.patriarch.rawValue
   ]


    @Published var ordinations: [Ordination] = [Ordination]()
    
    static let shared = OrdinationsViewModel()
    
    let disclosureGroupHeaders = ["Member", "Ordination/Office", "Status", "Ordination Date"]
    
    public init(ordinations: [Ordination] = [Ordination]()) {
        super.init()
        
        fetchData {
            if ordinations.isEmpty {
                if !InterviewsViewModel.shared.interviews.isEmpty {
                    for interview in InterviewsViewModel.shared.interviews {
                        if !interview.ordination.isEmpty {
                            if AppDelegate.unitType == UnitTypes.ward.stringValue || AppDelegate.unitType == UnitTypes.branch.stringValue {
                                if interview.ordination == OrdinationOfficeCategories.deacon.rawValue || interview.ordination == OrdinationOfficeCategories.teacher.rawValue || interview.ordination == OrdinationOfficeCategories.priest.rawValue || interview.ordination == OrdinationOfficeCategories.elder.rawValue || interview.ordination == OrdinationOfficeCategories.highPriest.rawValue {
                                    let ordination = Ordination(uid: interview.uid, name: interview.name, ordinationOffice: interview.ordination, status: interview.status, datePerformed: interview.scheduledInterviewDate)
                                    self.addOrdination(ordination: ordination)
                                }
                            } else {
                                if interview.ordination == OrdinationOfficeCategories.patriarch.rawValue || interview.ordination == OrdinationOfficeCategories.bishop.rawValue || interview.ordination == OrdinationOfficeCategories.elder.rawValue || interview.ordination == OrdinationOfficeCategories.highPriest.rawValue {
                                    let ordination = Ordination(uid: interview.uid, name: interview.name, ordinationOffice: interview.ordination, status: interview.status, datePerformed: interview.scheduledInterviewDate)
                                    self.addOrdination(ordination: ordination)
                                }
                            }
                        }
                    }
                    
                    self.ordinations = self.sortOrdinations()
                }
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.ordinations.rawValue)").order(by: DictionaryKeys.name.rawValue, descending: false)
        
        ref?.addSnapshotListener { querySnapshnot, error in
            guard let documents = querySnapshnot?.documents else {
                print("No Ordination Documents")
                return
            }
            
            self.ordinations = documents.compactMap {
                (queryDocumentSnapshot) -> Ordination? in
                let data = queryDocumentSnapshot.data()
                
                let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                let name = data[DictionaryKeys.name.rawValue] as? String ?? ""
                let ordinationOffice = data[DictionaryKeys.ordinationOffice.rawValue] as? String ?? ""
                let status = data[DictionaryKeys.status.rawValue] as? String ?? ""
                let datePerformed = data[DictionaryKeys.datePerformed.rawValue] as? String ?? ""
                
                return Ordination(uid: uid, name: name, ordinationOffice: ordinationOffice, status: status, datePerformed: datePerformed)
            }
            
            completion()
        }
    }
    
    func addOrdination(ordination: Ordination) {
        addOrdinationDocument(ordination: ordination) { results in
            CoreDataManager.shared.addOrdination(ordination: ordination) { results in
                self.ordinations.append(ordination)
            }
        }
    }
    
    func addOrdinationDocument(ordination: Ordination, completion: @escaping (_ results: String) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.ordinations.rawValue)").document("\(ordination.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: ordination.uid, DictionaryKeys.name.rawValue: ordination.name,
                      DictionaryKeys.ordinationOffice.rawValue: ordination.ordinationOffice, DictionaryKeys.status.rawValue: ordination.status,
                      DictionaryKeys.datePerformed.rawValue: ordination.datePerformed]) { err in
            if let err = err {
                print("Error adding ordination document: \(err)")
                completion(err.localizedDescription)
            } else {
                print("Success adding ordination with ID: \(ref!.documentID)")
                completion("Success")
            }
        }
    }
    
    func deleteOrdination(ordination: Ordination) {
        for (index, ordinance) in ordinations.enumerated() {
            if ordinance.uid == ordination.uid {
                ordinations.remove(at: index)
            }
        }
        deleteOrdinationDocument(ordination: ordination) {
            CoreDataManager.shared.deleteOrdination(uid: ordination.uid) {
                self.fetchData {
                    
                }
            }
        }
    }
    
    func deleteOrdinationDocument(ordination: Ordination, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.ordinations.rawValue)").document(ordination.uid).delete() { err in
            if let err = err {
                print("Error removing ordination document: \(err)")
                completion()
            } else {
                print("Ordination document successfully removed!")
                completion()
            }
        }
    }
    
    func sortOrdinations() -> [Ordination] {
        ordinations.sorted { $0.ordinationOffice > $1.ordinationOffice }
    }

}
