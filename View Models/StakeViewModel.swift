//
//  StakeViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class StakeViewModel: BaseViewModel {
    @Published var stakes = [Stake]()
    @Published var unitsInStake = [Unit]()

    static let shared = StakeViewModel()
    static var hasInitialized = false
    
    public init(units: [Stake] = [Stake]()) {
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
        
        AppDelegate.stakeNumber = "2224580"
        
        fetchData {
            if self.stakes.isEmpty {
                if !StakeViewModel.hasInitialized {
                    Task.init {
                        self.createStake(from: getDataFromJSON(fileName: "\(AppDelegate.stakeNumber)_UnitsInStake")) { results in
                            StakeViewModel.hasInitialized = true
                        }
                    }
                }
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if Network.shared.hasConnection {
            if stakes.isEmpty {
                let ref = db?.collection("\(AppDelegate.stakeNumber)_\(CollectionEntities.stake.rawValue)").order(by: DictionaryKeys.stakeName.rawValue, descending: false)
                
                ref?.addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("No Documents")
                        return
                    }
                                
                    self.stakes = documents.compactMap { (queryDocumentSnapshot) -> Stake? in
                        let data = queryDocumentSnapshot.data()
                        
                        let units = data[DictionaryKeys.units.rawValue] as? String ?? ""
                        let stakeName = data[DictionaryKeys.stakeName.rawValue] as? String ?? ""
                        let stakeUnitNumber = data[DictionaryKeys.stakeUnitNumber.rawValue] as? String ?? ""
                        let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""

                        return Stake(uid: uid, stakeName: stakeName, stakeUnitNumber: stakeUnitNumber, units: DataManager.shared.convertUnitsStringToArrayOfUnits(unitsString: units, for: AppDelegate.stakeNumber))
                    }
                    
                    completion()
                }
            } else {
                if let stakeEntities = CoreDataManager.shared.getStakes() {
                    stakes = DataManager.shared.convertArrayOfStakeEntitiesToStakeModels(entities: stakeEntities)
                    completion()
                }
            }
        } else {
            if let stakeEntities = CoreDataManager.shared.getStakes() {
                stakes = DataManager.shared.convertArrayOfStakeEntitiesToStakeModels(entities: stakeEntities)
                completion()
            }
        }
    }
    
    func createStake(from json: JSONDictionary, completion: (_ results: String) -> Void) {
        var stakeUnits: [Unit] = [Unit]()
                
        if let units = json["unitsInStake"] as? [[String: Any]] {
            if let stkUnitNumber = json["unitNumber"] as? String, let stkUnitName = json["unitName"] as? String {
                AppDelegate.stakeNumber = stkUnitNumber
                defaults.set(AppDelegate.stakeNumber, forKey: UserDefaultKeys.stakeNumber.stringValue)
                let id = "\(stkUnitNumber)_\(UUID().uuidString)"
                for unit in units {
                    if let unitName: String = unit["unitName"] as? String, let unitNumber: String = unit["unitNumber"] as? String {
                        stakeUnits.append(Unit(uid: id, stakeUnitNumber: stkUnitNumber, unitName: unitName, unitNumber: unitNumber))
                    }
                }
                
                stakes.append(Stake(uid: id, stakeName: stkUnitName, stakeUnitNumber: stkUnitNumber, units: stakeUnits))
                
                if !stakes.isEmpty {
                    completion("Success")
                }
//                self.addStakeDocument(stake: stake) { results in
//                    if results.contains("Success") {
//                        StakeViewModel.hasInitialized = true
//                        CoreDataManager.shared.addStake(stake: stake) { results in
//                        }
//                    }
//                }
//                completion("Success")
            }
        }
      //  completion("Error")
    }

    func addStakeDocument(stake: Stake, completion: @escaping (_ results: String ) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.stakeNumber)_\(CollectionEntities.stake.rawValue)").document(stake.uid)
        
        ref?.setData([DictionaryKeys.uid.rawValue: stake.uid,
                      DictionaryKeys.stakeName.rawValue: stake.stakeName,
                      DictionaryKeys.stakeUnitNumber.rawValue: stake.stakeUnitNumber,
                      DictionaryKeys.units.rawValue: DataManager.shared.convertArrayOfUnitsToDeliniatedString(units: stake.units)]) { err in
            if let err = err {
                completion("Error adding unit in stake document: \(err.localizedDescription)")
            } else {
                completion("Success adding unit in stake document with ID: \(ref!.documentID)")
            }
        }
    }
    
//    func deleteUnitInStake(unit: UnitInStake) {
//        deleteUnitInStakeDocument(unit: unit) {
//            CoreDataManager.shared.deleteUnitInStake(uid: unit.uid) {
//                self.fetchData {
//
//                }
//            }
//        }
//    }
    
//    func deleteUnitInStakeDocument(unit: UnitInStake, completion: @escaping () -> Void) {
//        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.unitsInStake.rawValue)").document(unit.uid).delete() { err in
//            if let err = err {
//                print("Error removing unit in stake document: \(err)")
//                completion()
//            } else {
//                print("Unit in stake document successfully removed!")
//                completion()
//            }
//        }
//    }
}
