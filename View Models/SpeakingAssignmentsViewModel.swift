//
//  SacramentSpeakersViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/27/22.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class SpeakingAssignmentsViewModel: BaseViewModel {
    enum MonthDirection: Int {
        case previous = 0
        case next = 1
        case noDirection = -1
    }
    
    @Published var speakingAssignments = [SpeakingAssignment]()
    @Published var filteredSpeakingAssignments = [[SpeakingAssignment]]()
    @Published var lastSixMonths = [SpeakingAssignment]()
    @Published var sixMonthsToAYear = [SpeakingAssignment]()
    @Published var moreThanAYear = [SpeakingAssignment]()
    @Published var hasNeverSpoken = [SpeakingAssignment]()
    @Published var sundays = [String]()
    @Published var selectedSunday = ""
    @Published var selectedTitle = ""
    @Published var currentlySelectedMonth = ""
    @Published var currentlySelectedMonthsAbbreviatedString = ""
    @Published var speakersForWeekOne = [SpeakingAssignment]()
    @Published var speakersForWeekTwo = [SpeakingAssignment]()
    @Published var speakersForWeekThree = [SpeakingAssignment]()
    @Published var speakersForWeekFour = [SpeakingAssignment]()
    @Published var speakersForWeekFive = [SpeakingAssignment]()
    @Published var sundayDatesForNext12Weeks = [String]()
    @Published var sundaysInAYear = [String]()
    @Published var fourWeeksOfSundays = [String]()
    @Published var weeklyDisclosureGroupHeadings = [String]()
    @Published var memberListInAddSpeakingAssignmentsSheet = false
   
    var topic = ""
    var askToSpeakOnDate = Date()
    var speakerGroups = [[[String: Any]]]()
    var currentGroups = [[String: Any]]()
    var selectedMember = ""
    var memberAskedToSpeak = false
    var weekNumberInMonthForSunday = 0
    var weekOneSundayDate = ""
    var weekTwoSundayDate = ""
    var weekThreeSundayDate = ""
    var weekFourSundayDate = ""
    var weekFiveSundayDate = ""
    var currentDay = 0
    var currentWeek = 0
    var currentMonth = 0
    var currentYear = 23
    
    static let shared = SpeakingAssignmentsViewModel()
    static var hasInitialized = false
    static var currentDate = "06/01/2023"
        
    let disclosureGroupColumnHeadings = ["Speaker", "Topic", "Date"]
    
    let disclosureGroupSectionTitles: [String] = [
        SpeakingAssignmentFilterGroups.withInLast6Mos.rawValue,
        SpeakingAssignmentFilterGroups.sixMosTo1Yr.rawValue,
        SpeakingAssignmentFilterGroups.moreThan1Yr.rawValue,
        SpeakingAssignmentFilterGroups.membersNeverSpoke.rawValue,
    ]

    public init(speakingAssignments: [SpeakingAssignment] = [SpeakingAssignment](), filteredSpeakingAssignments: [SpeakingAssignment] = [SpeakingAssignment]()) {
        super.init()
        self.currentlySelectedMonth = getAMonthsAbbreviatedString(for: 0)
        
        fetchData {
            if self.speakingAssignments.isEmpty {
                Task.init {
                    if !SpeakingAssignmentsViewModel.hasInitialized {
                        await self.createSpeakingAssignment(from:getDataFromJSON(fileName: "\(AppDelegate.unitNumber)_SpeakingList"))
                        
                        SpeakingAssignmentsViewModel.hasInitialized = true
                    }
                }
            } else {
                self.speakingAssignments = self.speakingAssignments.sorted {speakAssignment, speakAssignment in
                    speakAssignment.askToSpeakOnDate > speakAssignment.askToSpeakOnDate
                }
                
                self.filterSpeakingAssignment()
            }
            
            let calendar = Calendar.current
            let yr = calendar.component(.year, from: Date())

            var currentYearFullRangeDate = "01-01-\(yr)"
            
            getSundays(for: 52, date: convertToDate(stringDate: currentYearFullRangeDate) /*Date()*/) { sabbaths in
                
                self.sundaysInAYear = sabbaths
                
                let month = self.currentlySelectedMonth
                
                if self.selectedSunday == "" {
                    // find the first sunday in month
                    for sunday in self.sundays {
                        let calendar = Calendar.current
                        let mo = calendar.component(.month, from: convertToDate(stringDate: sunday))
                        
                        let monthInt = self.getCurrentMonthIntValue(from: month)
                        
                        if monthInt == mo {
                            self.selectedSunday = convertToString(date: Date(), with: .medium)
                        }
                    }
                }
                                
                let abbreviatedMonthStr = self.selectedSunday.prefix(3)
                
                self.selectedSunday = self.selectedSunday.replacingOccurrences(of: abbreviatedMonthStr, with: "0" + String(self.getCurrentMonthIntValue(from: String(abbreviatedMonthStr))))
                
                self.selectedSunday = self.selectedSunday.replacingOccurrences(of: " ", with: "/")
                
                self.selectedSunday = self.selectedSunday.replacingOccurrences(of: ",", with: "")
                
                let date = convertToDate(stringDate: self.selectedSunday)
                
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date)
                
                if day < 10 {
                    let monthStr = self.selectedSunday.prefix(3)
                    
                    self.selectedSunday = self.selectedSunday.replacingOccurrences(of: monthStr, with: monthStr + "0")
                }
                
                self.getSpeakersForNext4Sundays(for: self.currentlySelectedMonth, direction: .noDirection)
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
        let ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.speakingAssignments.rawValue)").order(by: "askToSpeakOnDate", descending: false)
        
        ref?.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Speaking Assignment Documents")
                return
            }
            
            self.speakingAssignments = documents.compactMap { (queryDocumentSnapshot) -> SpeakingAssignment? in
                let data = queryDocumentSnapshot.data()
                
                let uid = data[DictionaryKeys.uid.rawValue] as? String ?? ""
                let name = data[DictionaryKeys.name.rawValue] as? String ?? ""
                let topic = data[DictionaryKeys.topic.rawValue] as? String ?? ""
                let askToSpeakOnDate = data[DictionaryKeys.askToSpeakOnDate.rawValue] as? String ?? ""
                let weekOfYear = data[DictionaryKeys.weekOfYear.rawValue] as? String ?? ""
                let weekNumberInMonthForSunday = data[DictionaryKeys.weekNumberInMonthForSunday.rawValue] as? String ?? ""
                
                return SpeakingAssignment(uid: uid, name: name, topic: topic, askToSpeakOnDate: askToSpeakOnDate, weekOfYear: weekOfYear, weekNumberInMonthForSunday: weekNumberInMonthForSunday)
            }
            
            completion()
        }
    }
    
    func getAMonthsAbbreviatedString(for monthIntValue: Int) -> String {
        var monthValue = 0
        
        if monthIntValue == 0 {
            let date = Date()
            let calendar = Calendar.current
            monthValue = calendar.component(.month, from: date)
        } else {
            monthValue = monthIntValue
        }
        
        switch monthValue {
        case 1:
            currentlySelectedMonthsAbbreviatedString = "Jan"
        case 2:
            currentlySelectedMonthsAbbreviatedString = "Feb"
        case 3:
            currentlySelectedMonthsAbbreviatedString = "Mar"
        case 4:
            currentlySelectedMonthsAbbreviatedString = "Apr"
        case 5:
            currentlySelectedMonthsAbbreviatedString = "May"
        case 6:
            currentlySelectedMonthsAbbreviatedString = "Jun"
        case 7:
            currentlySelectedMonthsAbbreviatedString = "Jul"
        case 8:
            currentlySelectedMonthsAbbreviatedString = "Aug"
        case 9:
            currentlySelectedMonthsAbbreviatedString = "Sep"
        case 10:
            currentlySelectedMonthsAbbreviatedString = "Oct"
        case 11:
            currentlySelectedMonthsAbbreviatedString = "Nov"
        case 12:
            currentlySelectedMonthsAbbreviatedString = "Dec"
            
        default:
            currentlySelectedMonthsAbbreviatedString = ""
        }
        
        return currentlySelectedMonthsAbbreviatedString
    }
    
    func getCurrentMonthIntValue(from monthString: String) -> Int {
        switch monthString.prefix(3) {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
            
        default:
            return 0
        }
    }
    
    func getSpeakersForNext4Sundays(for date: String, direction: MonthDirection) {
        if !speakersForWeekOne.isEmpty {
            speakersForWeekOne.removeAll()
        }
        
        if !speakersForWeekTwo.isEmpty {
            speakersForWeekTwo.removeAll()
        }
        
        if !speakersForWeekThree.isEmpty {
            speakersForWeekThree.removeAll()
        }
        
        if !speakersForWeekFour.isEmpty {
            speakersForWeekFour.removeAll()
        }
        
        if !speakersForWeekFive.isEmpty {
            speakersForWeekFive.removeAll()
        }
        
        let calendar = Calendar.current

        let dateMonth = calendar.component(.month, from: convertToDate(stringDate: date))
        let dateYear = calendar.component(.year, from: convertToDate(stringDate: date))
        
        for sunday in sundaysInAYear {
            let sundayDate = convertToDate(stringDate: sunday)
            
            let year = calendar.component(.year, from: sundayDate)
            let month = calendar.component(.month, from: sundayDate)
            let day = calendar.component(.day, from: sundayDate)
            
            let formattedSunday = formatMonthAndYearToString(dateStr: sunday, direction: direction)
            
            if month == dateMonth && year == dateYear {
                switch day {
                case 1...7:
                    weekOneSundayDate = getAMonthsAbbreviatedString(for: month) + " \(day) \(year)"
                    
                case 8...14:
                    weekTwoSundayDate = getAMonthsAbbreviatedString(for: month) + " \(day) \(year)"
                case 15...21:
                    weekThreeSundayDate = getAMonthsAbbreviatedString(for: month) + " \(day) \(year)"
                case 22...28:
                    weekFourSundayDate = getAMonthsAbbreviatedString(for: month) + " \(day) \(year)"
                case 29...31:
                    weekFiveSundayDate = getAMonthsAbbreviatedString(for: month) + " \(day) \(year)"
                default:
                    print("")
                }
            }
            
            for assignment in speakingAssignments {
                let assignmentDate = convertToDate(stringDate: assignment.askToSpeakOnDate)
                let assignmentYear = calendar.component(.year, from: assignmentDate)
                let assignmentMonth = calendar.component(.month, from: assignmentDate)
                let assignmentDay = calendar.component(.day, from: assignmentDate)
                
                if year == assignmentYear && month == assignmentMonth && dateMonth == month {
                    switch assignment.weekNumberInMonthForSunday {
                    case "1":
                        if !assignmentFoundforWeek(week: assignment.weekNumberInMonthForSunday, assignment: assignment) {
                            speakersForWeekOne.append(assignment)
                          //  weekOneSundayDate = assignment.askToSpeakOnDate
                        }
                    case "2":
                        if !assignmentFoundforWeek(week: assignment.weekNumberInMonthForSunday, assignment: assignment) {
                            speakersForWeekTwo.append(assignment)
                          //  weekTwoSundayDate = assignment.askToSpeakOnDate
                        }
                    case "3":
                        if !assignmentFoundforWeek(week: assignment.weekNumberInMonthForSunday, assignment: assignment) {
                            speakersForWeekThree.append(assignment)
                       //     weekThreeSundayDate = assignment.askToSpeakOnDate
                        }
                    case "4":
                        if !assignmentFoundforWeek(week: assignment.weekNumberInMonthForSunday, assignment: assignment) {
                            speakersForWeekFour.append(assignment)
                      //      weekFourSundayDate = assignment.askToSpeakOnDate
                        }
                    case "5":
                        if !assignmentFoundforWeek(week: assignment.weekNumberInMonthForSunday, assignment: assignment) {
                            speakersForWeekFive.append(assignment)
                       //     weekFiveSundayDate = assignment.askToSpeakOnDate
                        }
                    default:
                        break
                    }
                }
            }
        }
        
        if !weeklyDisclosureGroupHeadingExists(heading: weekOneSundayDate) {
            weeklyDisclosureGroupHeadings.append(weekOneSundayDate)
        }
        
        if !weeklyDisclosureGroupHeadingExists(heading: weekTwoSundayDate) {
            weeklyDisclosureGroupHeadings.append(weekTwoSundayDate)
        }
        
        if !weeklyDisclosureGroupHeadingExists(heading: weekThreeSundayDate) {
            weeklyDisclosureGroupHeadings.append(weekThreeSundayDate)
        }
        
        if !weeklyDisclosureGroupHeadingExists(heading: weekFourSundayDate) {
            weeklyDisclosureGroupHeadings.append(weekFourSundayDate)
        }

        if !weeklyDisclosureGroupHeadingExists(heading: weekFiveSundayDate) && !weekFiveSundayDate.isEmpty {
            weeklyDisclosureGroupHeadings.append(weekFiveSundayDate)
        }
    }
    
    func weeklyDisclosureGroupHeadingExists(heading: String) -> Bool {
        for aHeading in weeklyDisclosureGroupHeadings {
            if aHeading == heading {
                return true
            }
        }
        
        return false
    }
    
    func getASundaysSpeakers(for sectionTitle: String) -> [SpeakingAssignment] {
        for (index, groupHeading) in weeklyDisclosureGroupHeadings.enumerated() {
            if groupHeading == sectionTitle {
                switch (index + 1) {
                case 1:
                    return speakersForWeekOne
                case 2:
                    return speakersForWeekTwo
                case 3:
                    return speakersForWeekThree
                case 4:
                    return speakersForWeekFour
                case 5:
                    return speakersForWeekFive
                default:
                    break
                }
            }
        }
        
        return [SpeakingAssignment]()
    }
    
    func setSpeakingAssignmentSundayRelatedData() {
        let stringDate = convertToString(date: Date(), with: .medium)
        
        currentWeek =  getWeekNumberInMonthForSunday(dateString: stringDate)
        
        getSundays(for: 4, date: convertToDate(stringDate: stringDate)) { sundays in 
            self.getSpeakersForNext4Sundays(for: stringDate, direction: .previous)
        }
    }
    
    func assignmentFoundforWeek(week: String, assignment: SpeakingAssignment) -> Bool {
        var assignments = [SpeakingAssignment]()
        
        switch week {
        case "1":
            assignments = speakersForWeekOne
        case "2":
            assignments = speakersForWeekTwo
        case "3":
            assignments = speakersForWeekThree
        case "4":
            assignments = speakersForWeekFour
        case "5":
            assignments = speakersForWeekFive
        default:
            break
        }
        
        for assign in assignments {
            if assignment.name == assign.name {
                return true
            }
        }
        
        return false
    }
    
    func getCurrentMonth(from dateStr: String) -> String {
        let date = convertToDate(stringDate: dateStr)
        
        let month = date.month
        
        return month
    }
    
    func getWeekNumberInMonthForSunday(dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let sunday = formatter.date(from: dateString) else { return 0 }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: sunday)
        
        if day < 8 {
            return 1
        } else if day > 7 && day < 15 {
            return 2
        } else if day > 14 && day < 22 {
            return 3
        } else if day > 21 && day < 29 {
            return 4
        } else if day > 28 && day < 31 {
            return 5
        }
        
        return 0
    }
    
    func getPreviousOrNextMonthsDate(currentMonth: String, direction: MonthDirection) -> String {
        if self.currentlySelectedMonth != "" {
            // already set to a month
            if direction == .previous {
                var previousMonthsIntValue = getCurrentMonthIntValue(from: currentMonth)
                
                if previousMonthsIntValue == 1 {
                    previousMonthsIntValue = 12
                } else {
                    previousMonthsIntValue -= 1
                }
                
                self.currentlySelectedMonth = getAMonthsAbbreviatedString(for: previousMonthsIntValue)
            } else {
                var nextMonthsIntValue = getCurrentMonthIntValue(from: currentMonth)
                
                if nextMonthsIntValue == 12 {
                    nextMonthsIntValue = 1
                } else {
                    nextMonthsIntValue += 1
                }
                
                self.currentlySelectedMonth = getAMonthsAbbreviatedString(for: nextMonthsIntValue)
            }
        }
        
        return formatMonthAndYearToString(dateStr: self.currentlySelectedMonth, direction: direction)
    }
    
    func getSpeakingAssignments(for speakingAssignmentSectionTitle: String) -> [SpeakingAssignment] {
        switch speakingAssignmentSectionTitle {
        case SpeakingAssignmentFilterGroups.withInLast6Mos.rawValue:
            return lastSixMonths
        case SpeakingAssignmentFilterGroups.sixMosTo1Yr.rawValue:
            return sixMonthsToAYear
        case SpeakingAssignmentFilterGroups.moreThan1Yr.rawValue:
            return moreThanAYear
        case SpeakingAssignmentFilterGroups.membersNeverSpoke.rawValue:
            return hasNeverSpoken
        default:
            return [SpeakingAssignment]()
        }
    }
    
    func filterSpeakingAssignment() {
        var inTheLastSixMonths = false
        var betweenSixMonthsAndAYear = false
        var isOverAYear = false
        
        for assignment in speakingAssignments {
            if speakingAssignmentOrPrayerInLast6Months(date: convertToDate(stringDate: assignment.askToSpeakOnDate)) {
                if !assignment.name.contains("Fast Sunday") && !assignment.name.contains("High Council") && !assignment.name.contains("Conference") {
                    lastSixMonths.append(SpeakingAssignment(uid: assignment.uid, name: assignment.name, topic: assignment.topic, askToSpeakOnDate: assignment.askToSpeakOnDate, weekOfYear: String(getWeekOfYear(date: convertToDate(stringDate: assignment.askToSpeakOnDate))), weekNumberInMonthForSunday: String(assignment.weekNumberInMonthForSunday)))
                }
            }
            
            if speakingAssignmentOrPrayerIsBetween6MonthsAnd1Year(date: convertToDate(stringDate: assignment.askToSpeakOnDate)) {
                if !assignment.name.contains("Fast Sunday") && !assignment.name.contains("High Council") && !assignment.name.contains("Conference") {
                    sixMonthsToAYear.append(SpeakingAssignment(uid: assignment.uid, name: assignment.name, topic: assignment.topic, askToSpeakOnDate: assignment.askToSpeakOnDate, weekOfYear: String(getWeekOfYear(date: convertToDate(stringDate: assignment.askToSpeakOnDate))), weekNumberInMonthForSunday: String(assignment.weekNumberInMonthForSunday)))
                }
            }
            
            if speakingAssignmentOrPrayerIsOverAYear(date: convertToDate(stringDate: assignment.askToSpeakOnDate)) {
                if !assignment.name.contains("Fast Sunday") && !assignment.name.contains("High Council") && !assignment.name.contains("Conference") {
                    moreThanAYear.append(SpeakingAssignment(uid: assignment.uid, name: assignment.name, topic: assignment.topic, askToSpeakOnDate: assignment.askToSpeakOnDate, weekOfYear: String(getWeekOfYear(date: convertToDate(stringDate: assignment.askToSpeakOnDate))), weekNumberInMonthForSunday: String(assignment.weekNumberInMonthForSunday)))
                }
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
                    hasNeverSpoken.append(SpeakingAssignment(uid: "", name: member.name, topic: "", askToSpeakOnDate: "", weekOfYear: "", weekNumberInMonthForSunday: ""))
                }
            }
        }
    }
    
    func createSpeakingAssignment(from json: JSONDictionary) async {
        if let speakAssignments = json["speakingAssignments"] as? [[String: Any]] {
            for speakAssignment in speakAssignments {
                if let name: String = speakAssignment[DictionaryKeys.name.rawValue] as? String, let topic: String = speakAssignment[DictionaryKeys.topic.rawValue] as? String, let askToSpeakOnDate: String = speakAssignment[DictionaryKeys.askToSpeakOnDate.rawValue] as? String, let weekNumberInMonthForSunday: String = speakAssignment[DictionaryKeys.weekNumberInMonthForSunday.rawValue] as? String {
                    let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                    let speakingAssignment = SpeakingAssignment(id: id, uid: id, name: name, topic: topic, askToSpeakOnDate: askToSpeakOnDate, weekOfYear: String(getWeekOfYear(date: convertToDate(stringDate: askToSpeakOnDate))), weekNumberInMonthForSunday: weekNumberInMonthForSunday)
                    self.addSpeakingAssignmentDocument(speakingAssignment: speakingAssignment) {
                        CoreDataManager.shared.addSpeakingAssignment(speakingAssignment: speakingAssignment)
                    }
                }
            }
        }
    }
    
    func addSpeakingAssignmentDocument(speakingAssignment: SpeakingAssignment, completion: @escaping () -> Void) {
        var ref: DocumentReference? = nil
        ref = db?.collection("\(AppDelegate.unitNumber)_\(CollectionEntities.speakingAssignments.rawValue)").document(speakingAssignment.uid)
        
        ref?.setData([DictionaryKeys.uid.rawValue: speakingAssignment.uid, DictionaryKeys.name.rawValue: speakingAssignment.name, DictionaryKeys.topic.rawValue: speakingAssignment.topic, DictionaryKeys.askToSpeakOnDate.rawValue: speakingAssignment.askToSpeakOnDate, DictionaryKeys.weekOfYear.rawValue: speakingAssignment.weekOfYear, DictionaryKeys.weekNumberInMonthForSunday.rawValue: speakingAssignment.weekNumberInMonthForSunday]) { err in
            if let err = err {
                print("Error adding speaking assignment document: \(err)")
                completion()
            } else {
                print("collection Document added speaking assignment with ID: \(ref!.documentID)")
                completion()
            }
        }
    }
    
    func formatMonthAndYearToString(dateStr: String, direction: MonthDirection) -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let stringToDate = convertToDate(stringDate: dateStr)
        
        var dayOfStringToDate = -1
        
        if direction == .noDirection {
            dayOfStringToDate = 01
        } else {
            dayOfStringToDate = calendar.component(.day, from: stringToDate)
        }
        
        let monthIntValue = getCurrentMonthIntValue(from: dateStr)
        
        var monthStringValue = ""
        
        if monthIntValue < 10 {
            monthStringValue = "0" + String(monthIntValue)
        }
        
        if direction == .noDirection {
            return monthStringValue + "/0\(dayOfStringToDate)/" + String(year)
        }
        
        return monthStringValue + "/01/" + String(year)
//        return monthStringValue + "/\(dayOfStringToDate)/" + String(year)
    }
    
//    func getSundays(for range: Int, date: Date, completion: @escaping ([String]) -> Void) {
//        var index = 0
//        var monthIndex = 1
//        var monthWeekIndex = 1
//        
//        var sundays = [String]()
//        
//       // let date = Date()
//        
////        if !sundaysInAYear.isEmpty {
////            sundaysInAYear.removeAll()
////        }
////
//        let calendar = Calendar.current
//        currentDay = calendar.component(.day, from: date)
//        
//        let nextFollowingSundays = date.nextFollowingSundays(range)
//        nextFollowingSundays.forEach { sunday in
//            var currentSunday = sunday.description(with: .current)
//            
//            currentSunday = currentSunday.replacingOccurrences(of: "Sunday, ", with: "")
//            
//            if currentSunday.contains("Daylight") {
//                currentSunday = currentSunday.replacingOccurrences(of: " at 12:00:00 AM Mountain Daylight Time", with: "")
//            } else {
//                currentSunday = currentSunday.replacingOccurrences(of: " at 12:00:00 AM Mountain Standard Time", with: "")
//            }
//            
//            let currentSundayDate = convertToDate(stringDate: currentSunday)
//            
//            currentMonth = calendar.component(.month, from: currentSundayDate)
//            currentYear = calendar.component(.year, from: currentSundayDate)
//
//            let currentSundayDay = calendar.component(.day, from: currentSundayDate)
//            
//            if currentSundayDay < currentDay {
//                monthIndex += 1
//                monthWeekIndex = 1
//                currentDay = currentSundayDay
//            }
//            
////            sundaysInAYear.append(currentSunday)
//            if monthWeekIndex == 4 {
//                monthWeekIndex = 1
//            }
//            
//            monthWeekIndex += 1
//            
//            if range == 4 {
//                // month worth only
//                sundays.append(currentSunday)
//                
//                index += 1
//            } else if range == 12 {
//                // 3 months or 12 weeks worth
//               // sundayDatesForNext12Weeks.append(currentSunday)
//                sundays.append(currentSunday)
//            } else {
//                sundays.append(currentSunday)
//            }
//        }
//        
////        self.sundayDatesForNext12Weeks = self.sundayDatesForNext12Weeks.sorted {sunday, sunday in
////            sunday > sunday
////        }
//        
//        self.sundays = self.sundays.sorted {sunday, sunday in
//            sunday > sunday
//        }
//        
//        completion(sundays)
//    }
}
