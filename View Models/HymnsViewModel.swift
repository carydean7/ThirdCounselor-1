//
//  HymnsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/7/23.
//

import Foundation

class HymnsViewModel: BaseViewModel {
    @Published var hymns = [Hymn]()
    
    var hymnGroups = [[Hymn]]()
    var sectionSong = 0
    var sectionsNotFound = [String]()
    var hymn = (title: "", number: "")
    var selectedHymn = ""

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
                sortHymns(byNumber: false)
                for section in Constants.hymnsSectionTitles {
                    self.getHymnGroups(for: section, byNumber: false)
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
                    if let songTitle = hymn["title"] as? String, let number = hymn["number"] as? String, let id = (hymn["number"] as? NSString)?.integerValue {
                        hymns.append(Hymn(id: id, title: songTitle, number: number))
                    }
                }
            }
        }
        
        return hymns
    }
    
    func getHymnGroups(for section: String, byNumber: Bool) {
        var group = [Hymn]()
        var sectionFound = false
        
        if !byNumber {
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

        } else {
            var startValue = 0
            
            for _ in 0...35 {
                hymnGroups.append(buildGroups(startValue: startValue, hymns: hymns))
    }
    
            print("hymnGroups : \(hymnGroups)")
    }
}
    
    func buildGroups(startValue: Int, hymns: [Hymn]) -> [Hymn] {
        var group = [Hymn]()
        
        for i in stride(from: startValue, to: startValue + 10, by: 1) {
            if i < hymns.count {
                group.append(hymns[i])
            }
        }
        
        return group
    }
    
    func sortHymns(byNumber: Bool) {
        if !byNumber {
            print("sorting by title")
            hymns = hymns.sorted(by: {$0.title < $1.title})
        } else {
            print("sorting by number")
            hymns = hymns.sorted(by: {$0.id < $1.id})
        }
    }
}
