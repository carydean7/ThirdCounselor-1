//
//  MembersViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class MembersViewModel: BaseViewModel {
    // MARK: - Properties
    @Published var members = [Member]()
    @Published var alphaToMember = [String]()
    @Published var newMemberAdded: Bool = false
    @Published var newMemberLastNameBeginsWithLetter: String = ""

    var membersName: String = ""
    var callings = [String]()
    var currentlySelectedMember = Member(id: "", uid: "", name: "", welcomed: "")
    var shouldShowCloseButon = false

    static let shared = MembersViewModel()
    static var hasInitialized = false
        
    public init(members: [Member] = [Member](), currentlySelectedMember: Member = Member(id: "", uid: "", name: "", welcomed: "")) {
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
            if self.members.isEmpty {
                if !MembersViewModel.hasInitialized {
                    Task.init {
                        self.createMember(from: getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_Members")) { results in
                            MembersViewModel.hasInitialized = true
                            
                            Task.init {
                                await self.sortMembers()
                                self.indexForName()
                            }
                        }
                    }
                }
            } else {
                Task.init {
                    await self.sortMembers()
                    self.indexForName()
                }
            }
        }
    }
    
    func getMemberModel(for memberName: String) -> Member? {
        for member in members {
            if member.name == memberName {
                return member
            }
        }
        
        return nil
    }
    
    func updateMember(model: Member, completion: @escaping () -> Void) {
        updateMemberDocument(member: model) {
            CoreDataManager.shared.updateMember(model: model) {
                completion()
            }
        }
    }
    
    func updateMemberDocument(member: Member, completion: @escaping () -> Void) {
        let documentId = "\(member.uid)"
        let memberDictionary = DataManager.shared.convertMemberModelToDictionary(model: member)
        
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.members.rawValue)").document(documentId).updateData(memberDictionary)
        
        completion()
    }
    
    func findAllCallingsFor(member: Member, orgMbrCallings: [OrgMbrCalling]) -> String {
        var callings = ""
        
        for (index, call) in orgMbrCallings.enumerated() {
            if call.memberName == member.name {
                if (Int(call.callingName.suffix(1)) != nil) {
                    let calling = call.callingName.dropLast()
                    if orgMbrCallings.count == 1 || index == (orgMbrCallings.count - 1) {
                        callings += "\(call.organizationName): \(calling)"
                    } else {
                        callings += "\(call.organizationName): \(calling) // "
                    }
                } else {
                    callings += "\(call.organizationName): \(call.callingName) // "
                }
            }
        }
        for _ in 0...2 {
            if !callings.isEmpty {
                callings.removeLast()
            }
        }
        
        return callings
    }
    
    func memberExistsInMembers(name: String, completion: @escaping (Bool) -> Void) {
        for mbr in self.members {
            if mbr.name == name {
                completion(true)
            }
        }
        
        completion(false)
    }
    
    func addMemberDocument(member: Member, completion: @escaping ( _ results: String ) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.members.rawValue)").document("\(member.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: member.uid, DictionaryKeys.name.rawValue: member.name, DictionaryKeys.welcomed.rawValue: member.welcomed]) { err in
            if let err = err {
                print("Error adding member document: \(err.localizedDescription)")
                completion("Error adding member document: \(err.localizedDescription)")
            } else {
                print("Success adding member with ID: \(ref!.documentID)")
                completion("Success adding member with ID: \(ref!.documentID)")
            }
        }
    }
    
    func deleteMember(member: Member) {
        deleteMemberDocument(member: member) {
            CoreDataManager.shared.deleteMember(uid: member.uid) {
                self.fetchData {
                    Task.init {
                        await self.sortMembers()
                        self.removeAnyEmptySectionLetters()
                    }
                }
            }
        }
    }
    
    func deleteMemberDocument(member: Member, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.members.rawValue)").document(member.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion()
            } else {
                print("Document successfully removed!")
                completion()
            }
        }
    }
    
    func removeAnyEmptySectionLetters() {
        // check for any index remain after the only member in the section is deleted
        
        for (index, alphabet) in alphaToMember.enumerated() {
            var matchingAlpha = false

            for member in members {
                if member.name.prefix(1) == alphabet {
                    matchingAlpha = true
                    break
                }
            }
            
            if !matchingAlpha {
                alphaToMember.remove(at: index)
                
                removeAnyEmptySectionLetters()
            }
        }
    }
    
    func indexForName() {
        for alphabet in fullAlphabet {
            for member in members {
                if member.name.prefix(1) == alphabet {
                    if !alphaCharacterExists(letter: alphabet) {
                        alphaToMember.append(alphabet)
                    }
                    
                    break
                }
            }
        }
    }
    
    func alphaCharacterExists(letter: String) -> Bool {
        for alpha in alphaToMember {
            if alpha == letter {
                return true
            }
        }
        
        return false
    }

    func fetchData(completion: @escaping () -> Void) {
        if Network.shared.hasConnection {
            let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.members.rawValue)").order(by: DictionaryKeys.name.rawValue, descending: false)

            ref?.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                           
                 self.members = documents.compactMap { (queryDocumentSnapshot) -> Member? in
                    let data = queryDocumentSnapshot.data()
                    
                    let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                    let name = data[DictionaryKeys.name.rawValue] as? String ?? ""
                    let welcomed = data[DictionaryKeys.welcomed.rawValue] as? String ?? ""

                    return Member(uid: uid, name: name, welcomed: welcomed)
                }
                
                completion()
            }
        } else {
            if let memberEntities = CoreDataManager.shared.getAllMembers() {
                members = DataManager.shared.convertArrayOfMemberEntitiesToMemberModels(entities: memberEntities)

                completion()
            }
        }
    }
    
    func createMember(from json: JSONDictionary, completion: (_ results: String) -> Void) {
        if let mbrs = json["members"] as? [[String: Any]] {
            for aMbr in mbrs {
                if let name: String = aMbr[DictionaryKeys.name.rawValue] as? String, let welcomed: String = aMbr[DictionaryKeys.welcomed.rawValue] as? String {
                    self.memberExistsInMembers(name: name) { exists in
                        if !exists {
                            let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                            let member = Member(id: id, uid: id, name: name, welcomed: welcomed)
                            self.addMemberDocument(member: member) { results in
                                if results.contains("Success") {
                                    CoreDataManager.shared.addMember(member: member) { results in

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
    
    func sortMembers() async {
        if !members.isEmpty {
            members = members.sorted { member, member in
                member.name < member.name
            }
        }
    }
}
