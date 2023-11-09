//
//  AnnouncementsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 11/3/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class AnnouncementsViewModel: BaseViewModel {
    @Published var announcements = [Announcement]()
    
    static let shared = AnnouncementsViewModel()
    
    public init(announcements: [Announcement] = [Announcement]()) {
        super.init()
        
        fetchData {
            
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if Network.shared.hasConnection {
            let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.announcements.rawValue)").order(by: DictionaryKeys.fyi.rawValue, descending: false)

            ref?.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                           
                 self.announcements = documents.compactMap { (queryDocumentSnapshot) -> Announcement? in
                    let data = queryDocumentSnapshot.data()
                    
                    let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                    let fyi = data[DictionaryKeys.fyi.rawValue] as? String ?? ""
                    let announced = data[DictionaryKeys.announced.rawValue] as? String ?? ""

                     if announced == "N" {
                         return Announcement(uid: uid, fyi: fyi, announced: announced)
                     } else {
                         return Announcement(uid: "", fyi: "", announced: "")
                     }
                }
                
                completion()
            }
        } else {
            if let announcementsEntities = CoreDataManager.shared.getAnnouncements() {
                announcements = DataManager.shared.convertArrayOfAnnouncementsEntitiesToAnnouncementModels(entities: announcementsEntities)

                completion()
            }
        }
    }
    
    func updateAnnouncement(model: Announcement, completion: @escaping () -> Void) {
        updateAnnouncementDocument(announcement: model) {
            CoreDataManager.shared.updateAnnouncement(model: model) {
                completion()
            }
        }
    }
    
    func updateAnnouncementDocument(announcement: Announcement, completion: @escaping () -> Void) {
        let documentId = "\(announcement.uid)"
        let announcementDictionary = DataManager.shared.convertAnnouncementModelToDictionary(model: announcement)
        
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.announcements.rawValue)").document(documentId).updateData(announcementDictionary)
        
        completion()
    }
    
    func addAnnouncement(announcement: Announcement, completion: @escaping (_ results: String) -> Void) {
        addAnnouncementDocument(announcement: announcement) { results in
            if results.contains("Success") {
                CoreDataManager.shared.addAnnouncement(announcement: announcement) { results in
                    completion("Announcement Added Successfully")
                }
            }
        }
    }
    
    func addAnnouncementDocument(announcement: Announcement, completion: @escaping (_ results: String) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.announcements.rawValue)").document("\(announcement.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: announcement.uid, DictionaryKeys.fyi.rawValue: announcement.fyi,
                      DictionaryKeys.announced.rawValue: announcement.announced]) { err in
            if let err = err {
                print("Error adding announcement document: \(err)")
                completion(err.localizedDescription)
            } else {
                print("Success adding announcement with ID: \(ref!.documentID)")
                completion("Success")
            }
        }
    }
    
    func deleteAnnouncementDocument(announcement: Announcement, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.announcements.rawValue)").document(announcement.uid).delete() { err in
            if let err = err {
                print("Error removing announcement document: \(err)")
                completion()
            } else {
                print("Announcement document successfully removed!")
                completion()
            }
        }
    }
    
    func deleteAnnouncement(announcement: Announcement, completion: @escaping () -> Void) {
        deleteAnnouncementDocument(announcement: announcement) {
            CoreDataManager.shared.deleteAnnouncement(uid: announcement.uid) {
                
            }
        }
    }

}
