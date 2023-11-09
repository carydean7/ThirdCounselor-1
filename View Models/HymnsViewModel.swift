//
//  HymnsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/7/23.
//

import Foundation
//import CoreData
//import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift

class HymnsViewModel: BaseViewModel {
    @Published var hymns = [Hymn]()
    
    var hymnGroups = [[Hymn]]()
    var sectionSong = 0
    var sectionsNotFound = [String]()
    var hymn = (title: "", number: "")

    static let shared = HymnsViewModel()

    public init(hymns: [Hymn] = [Hymn]()) {
        super.init()
        
        fetchData {
            
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        if hymns.isEmpty {
            NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.showDownloadDataProgressNotification.stringValue), object: nil)
            
            let jsonData = getDataFromJSON(fileName: "Hymns")
            hymns = getHymns(from: jsonData)
                        
            if !hymns.isEmpty {
                let sortedHymns = sortHymns()
                for section in Constants.hymnsSectionTitles {
                    self.getHymnGroups(for: section, in: sortedHymns)
                }
            }
        }
        
        completion()
    }
    
    func getHymns(from data: Any) -> [Hymn] {
        if data is JSONDictionary {
            let json: JSONDictionary = data as! JSONDictionary
            if let hymnsArray = json["hymns"] as? [[String: Any]] {
                for hymn in hymnsArray {
                    if let songTitle = hymn["title"] as? String, let number = hymn["number"] as? String {
                        hymns.append(Hymn(uid: UUID().uuidString, title: songTitle, number: number))
                    }
                }
            }
        }
        
        return hymns
    }
    
    func getHymnGroups(for section: String, in hymns: [Hymn]) {
        var group = [Hymn]()
        var sectionFound = false
        
        for hymn in hymns {
            if section == "I" {
                print()
            }
            if hymn.title.prefix(1) == section {
                sectionFound = true
                group.append(hymn)
            }
        }
        
        if group.count > 0 {
            hymnGroups.append(group)
        }
    }
    
    func sortHymns() -> [Hymn] {
        hymns.sorted(by: {$0.number < $1.number})
    }
}
