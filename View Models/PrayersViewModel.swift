//
//  PrayersViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/24/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class PrayersViewModel: BaseViewModel {
    @Published var prayers: [Prayer] = [Prayer(uid: "", name: "", date: "", type: "")]
    @Published var memberListInAddPrayersSheet = false
    @Published var invocation = ""
    @Published var benediction = ""
    @Published var lastSixMonths = [Prayer]()
    @Published var sixMonthsToAYear = [Prayer]()
    @Published var moreThanAYear = [Prayer]()
    @Published var hasNeverPrayed = [Prayer]()
    
    @Published var showAddPrayerView = false

    static let shared = PrayersViewModel()
    
    var addButtonDelegate: AddButtonDelegate?
    
    let disclosureGroupColumnHeadings = ["Member", "Date", "Prayer"]
    
    let disclosureGroupSectionTitles: [String] = [
        PrayersFilterGroups.withInLast6Mos.rawValue,
        PrayersFilterGroups.sixMosTo1Yr.rawValue,
        PrayersFilterGroups.moreThan1Yr.rawValue,
        PrayersFilterGroups.membersNeverPrayed.rawValue,
    ]
    
    var currentWeeksPrayers = [Prayer]()

    public init(prayers: [Prayer] = [Prayer]()) {
        super.init()
        
        fetchData {
            if self.prayers.isEmpty {
                Task.init {
                    self.createPrayer(from:getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_Prayers")) {
                        results in
                        
                    }
                }
            } else {
                self.getCurrentOrNextPrayers {
                    self.getMembersGivingCurrentOrNextSundaysPrayByType()
                }
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.prayers.rawValue)").order(by: DictionaryKeys.name.rawValue, descending: false)
        
        ref?.addSnapshotListener { querySnapshnot, error in
            guard let documents = querySnapshnot?.documents else {
                print("No Prayer Documents")
                return
            }
            
            self.prayers = documents.compactMap {
                (queryDocumentSnapshot) -> Prayer? in
                let data = queryDocumentSnapshot.data()
                
                let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                let name = data[DictionaryKeys.name.rawValue] as? String ?? ""
                let date = data[DictionaryKeys.date.rawValue] as? String ?? ""
                let type = data[DictionaryKeys.type.rawValue] as? String ?? ""
                
                return Prayer(uid: uid, name: name, date: date, type: type)
            }
            
            completion()
        }
    }
    
    func createPrayer(from json: JSONDictionary, completion: (_ results: String) -> Void) {
        if let prayers = json["prayers"] as? [[String: Any]] {
            for prayer in prayers {
                if let name: String = prayer[DictionaryKeys.name.rawValue] as? String, let date = prayer[DictionaryKeys.date.rawValue] as? String, let type = prayer[DictionaryKeys.type.rawValue] as? String {
                    let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                    let prayer = Prayer(id: id, uid: id, name: name, date: date, type: type)
                    self.addPrayerDocument(prayer: prayer) { results in
                        if results.contains("Success") {
                            CoreDataManager.shared.addPrayer(prayer: prayer) { results in
                                
                            }
                        }
                    }
                }
            }
            completion("Success")
        }
        
        completion("Error")
    }
    
    func addPrayer(prayer: Prayer, completion: @escaping (_ results: String) -> Void) {
        addPrayerDocument(prayer: prayer) { results in
            if results.contains("Success") {
                CoreDataManager.shared.addPrayer(prayer: prayer) { results in
                    completion("Prayer Added Successfully")
                }
            }
        }
    }
    
    func addPrayerDocument(prayer: Prayer, completion: @escaping (_ results: String) -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.prayers.rawValue)").document("\(prayer.uid)")

        ref?.setData([DictionaryKeys.uid.rawValue: prayer.uid, DictionaryKeys.name.rawValue: prayer.name,
                      DictionaryKeys.date.rawValue: prayer.date, DictionaryKeys.type.rawValue: prayer.type]) { err in
            if let err = err {
                print("Error adding prayer document: \(err)")
                completion(err.localizedDescription)
            } else {
                print("Success adding prayer with ID: \(ref!.documentID)")
                completion("Success")
            }
        }
    }
    
    func deletePrayerDocument(prayer: Prayer, completion: @escaping () -> Void) {
        db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.prayers.rawValue)").document(prayer.uid).delete() { err in
            if let err = err {
                print("Error removing prayer document: \(err)")
                completion()
            } else {
                print("Prayer document successfully removed!")
                completion()
            }
        }
    }

    func sortPrayers() -> [Prayer] {
        prayers.sorted { $0.name > $1.name }
    }
    
    func getCurrentWeeksPrayers(for currentDateComponents: (month: Int, day: Int, year: Int), completion: @escaping () -> Void) {
        for prayer in self.prayers {
            let dateAsString = prayer.date
            
            if dateAsString.isEmpty {
                break
            }
            
            let dateComponents = self.getDateComponents(from: dateAsString)
            
            if let month = dateComponents.month, let day = dateComponents.day, let year = dateComponents.year {
                if currentDateComponents.year == year && month >= currentDateComponents.month {
                    if month > currentDateComponents.month {
                        if day <= currentDateComponents.day {
                            if !memberPrayerExists(prayerToCheck: prayer) {
                                currentWeeksPrayers.append(prayer)
                            }
                        }
                    } else if month == currentDateComponents.month {
                        if day >= currentDateComponents.day {
                            if !memberPrayerExists(prayerToCheck: prayer) {
                                currentWeeksPrayers.append(prayer)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func memberPrayerExists(prayerToCheck: Prayer) -> Bool {
        for prayer in currentWeeksPrayers {
            if prayerToCheck.uid == prayer.uid {
                return true
            }
        }
        
        return false
    }
    
    func getCurrentOrNextPrayers(completion: @escaping () -> Void) {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentDay = calendar.component(.day, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let currentYearAsString = String(currentYear).suffix(2)
        let currentYr = Int(currentYearAsString)

        if prayers.isEmpty || prayers.first?.uid == "" {
            fetchData {
                self.getCurrentWeeksPrayers(for: (month: currentMonth, day: currentDay, year: currentYr ?? 0)) {
                    completion()
                }
                
                completion()
            }
        } else {
            self.getCurrentWeeksPrayers(for: (month: currentMonth, day: currentDay, year: currentYr ?? 0)) {
                completion()
            }
            
            completion()
        }
    }
    
    func getMembersGivingCurrentOrNextSundaysPrayByType() {
        for prayer in currentWeeksPrayers {
            if prayer.type == "Invocation" {
                invocation = prayer.name
            } else {
                benediction = prayer.name
            }
        }
    }
    
    func getMonthNumericValue(for month: String) -> Int {
        if month.contains("Janurary"){
            return 1
        }
        
        if month.contains("Feburary"){
            return 2
        }
        
        if month.contains("March"){
            return 3
        }
        
        if month.contains("April"){
            return 4
        }
        
        if month.contains("May"){
            return 5
        }
        
        if month.contains("June"){
            return 6
        }
        
        if month.contains("July"){
            return 7
        }
        
        if month.contains("August"){
            return 8
        }
        
        if month.contains("September"){
            return 9
        }
        
        if month.contains("October"){
            return 10
        }
        
        if month.contains("November"){
            return 11
        }
        
        if month.contains("December"){
            return 12
        }
        
        return -1
    }
    
    // extracts from format e.g. Janurary 12, 2023
    func getDay(from date: String) -> String {
        if let startIndex = date.firstIndex(of: " ") {
            if let endIndex = date.firstIndex(of: ",") {

                let subString = date[date.index(startIndex, offsetBy: 1)..<endIndex]

                return String(subString)
            }
        }
        
        return ""
    }
    
    func getDateComponents(from dateAsString: String) -> (month: Int?, day: Int?, year: Int?) {
        var month = ""
        var day = ""
        
        let startIndex = dateAsString.startIndex
            if let endIndex = dateAsString.firstIndex(of: "/") {
                let subString = dateAsString[dateAsString.index(startIndex, offsetBy: 0)..<endIndex]
                month = String(subString)
            }
        
        
        if let startIndex = dateAsString.firstIndex(of: "/") {
            if let endIndex = dateAsString.lastIndex(of: "/") {

                let subString = dateAsString[dateAsString.index(startIndex, offsetBy: 1)..<endIndex]

                day = String(subString)
            }
        }
        
        let monthAsInt = Int(month)
        let dayAsInt = Int(day)
        let yearAsInt = Int(dateAsString.suffix(2))
        
        return (month: monthAsInt, day: dayAsInt, year: yearAsInt)
    }
    
    func changeSundayLongToShortFormat(longSunday: String) -> String {
        var day = ""
        var month = -1
        var monthString = ""
        
        month = getMonthNumericValue(for: longSunday)
        
        if month < 10 {
            monthString = "0\(month)"
        } else {
            monthString = "\(month)"
        }
        
        day = getDay(from: longSunday)
        
        return "\(monthString)/\(day)/\(longSunday.suffix(2))"
    }
    
    func filterPrayers() {
        var inTheLastSixMonths = false
        var betweenSixMonthsAndAYear = false
        var isOverAYear = false
        
        for prayer in prayers {
            if speakingAssignmentOrPrayerInLast6Months(date: convertToDate(stringDate: prayer.date)) {
                    lastSixMonths.append(Prayer(uid: prayer.uid,
                                                name: prayer.name,
                                                date: prayer.date,
                                                type: prayer.type))
            }
            
            if speakingAssignmentOrPrayerIsBetween6MonthsAnd1Year(date: convertToDate(stringDate: prayer.date)) {
                sixMonthsToAYear.append(Prayer(uid: prayer.uid,
                                               name: prayer.name,
                                               date: prayer.date,
                                               type: prayer.type))
            }
            
            if speakingAssignmentOrPrayerIsOverAYear(date: convertToDate(stringDate: prayer.date)) {
                    moreThanAYear.append(Prayer(uid: prayer.uid,
                                                name: prayer.name,
                                                date: prayer.date,
                                                type: prayer.type))
            }
        }
        
        if !inTheLastSixMonths || !betweenSixMonthsAndAYear || !isOverAYear {
            var foundInLastSixMonths = false
            var foundBetweenSixMonthsAndAYear = false
            var foundInMoreThanAYear = false
            
            for member in MembersViewModel.shared.members {
                for assignment in lastSixMonths {
                    if member.name == assignment.name {
                        foundInLastSixMonths = true
                    }
                }
                
                for assignment in sixMonthsToAYear {
                    if member.name == assignment.name {
                        foundBetweenSixMonthsAndAYear = true
                    }
                }
                
                for assignment in moreThanAYear {
                    if member.name == assignment.name {
                        foundInMoreThanAYear = true
                    }
                }
                
                if !foundInLastSixMonths && !foundBetweenSixMonthsAndAYear && !foundInMoreThanAYear {
                    hasNeverPrayed.append(Prayer(uid: "",
                                                 name: member.name,
                                                 date: "",
                                                 type: ""))
                }
            }
        }
    }
    
    func getPrayers(for sectionTitle: String) -> [Prayer] {
        switch sectionTitle {
        case PrayersFilterGroups.withInLast6Mos.rawValue:
            return lastSixMonths
        case PrayersFilterGroups.sixMosTo1Yr.rawValue:
            return sixMonthsToAYear
        case PrayersFilterGroups.moreThan1Yr.rawValue:
            return moreThanAYear
        case PrayersFilterGroups.membersNeverPrayed.rawValue:
            return hasNeverPrayed
        default:
            return [Prayer]()
        }
    }
}
