//
//  NotesViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 5/11/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class NotesViewModel: BaseViewModel {
    @Published var notes = [Note]()
    
    static let shared = NotesViewModel()
    static var hasInitialized = false
    
    public init(notes: [Note] = [Note]()) {
        super.init()
        let defaults = UserDefaults.standard
        let leader = defaults.string(forKey: UserDefaultKeys.leaderPosition.stringValue) ?? ""

        fetchData(for: leader) {}
    }
    
    func addNoteDocument(note: Note, completion: @escaping () -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.notes.rawValue)").document("\(note.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: note.uid, DictionaryKeys.content.rawValue: note.content, DictionaryKeys.leader.rawValue: note.leader]) { err in
            if let err = err {
                print("Error adding notes document: \(err)")
                completion()
            } else {
                print("collection Document added note with ID: \(ref!.documentID)")
                completion()
            }
        }
    }
    
    func deleteNote(note: Note, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.notes.rawValue)").document(note.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion()
            } else {
                print("Document successfully removed!")
                completion()
            }
        }
    }
    
    func fetchData(for leader: String, completion: @escaping () -> Void) {

        let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.notes.rawValue)").whereField(DictionaryKeys.leader.rawValue, isEqualTo: leader)
        ref?.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
                       
             self.notes = documents.compactMap { (queryDocumentSnapshot) -> Note? in
                let data = queryDocumentSnapshot.data()
                
                let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                let content = data[DictionaryKeys.content.rawValue] as? String ?? ""
                 let leader = data[DictionaryKeys.leader.rawValue] as? String ?? ""
                
                return Note(uid: uid, content: content, leader: leader)
            }
            
            completion()
        }
    }

}
