//
//  ConductingViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/1/22.
//

import Foundation
import SwiftUI

@MainActor class ConductingSheetViewModel: BaseViewModel {
    enum TupleTypes {
        case releases
        case sustainings
        case ordinations
    }
    
    @Published var conductingSheetSections = [ConductingSheetSection]()
    @Published var speakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared
    @Published var selectedConductingSheetSection = ConductingSheetSection(songForSection: -1,
                                showList: true,
                                showTextField: true,
                                showAddButton: false,
                                sheetSection: 0,
                                sectionTitle: "",
                                upperSectionContent: "",
                                lowerSectionContent: "",
                                conducting: "",
                                presiding: "",
                                announcements: [String](),
                                openingSong: (title: "", number: ""),
                                invocation: "",
                                wardBusinessMoveIns: [String](),
                                wardBusinessReleases: [(member: "", calling: "")],
                                wardBusinessSustainings: [(member: "", calling: "")],
                                sacramentSong: (title: "", number: ""),
                                musicProviders: [String](),
                                speakers: [String](),
                                intermediatMusic: (title: "", number: ""),
                                ordinations: [(member: "", office: "")],
                                closingSong: (title: "", number: ""),
                                upperSectionIsEditable: false,
                                lowerSectionIsEditable: false)
    
    @Published var selectedSheetSection = 0
    @Published var memberListInConductingSheet = false
    @Published var newMoveIns: [Member] = [Member]()
    
    var currentWeeksSpeakingAssignments = [SpeakingAssignment]()
    var songForSection: Int = -1
    var addTextView: UITextView?
    
    var announcementsDataSource = [String]()
    var moveInsDataSource = [String]()
    var releasesDataSource = [String]()
    var sustainingsDataSource = [String]()
    var ordinationsDataSource = [Interview]()
    var speakersDataSource = [String]()
    
    var moveInsTableView: UITableView?
    var releasesTableView: UITableView?
    var sustainingsTableView: UITableView?
    var speakingAssignmentsTableView: UITableView?
    
    var selectedConductingSheetIndex = 0
    
    var invocation = "<Member>"
    var benediction = "<Member>"
    var currentWeeksPrayers = [Prayer]()
    
    var addButtonDelegate: AddButtonDelegate?
    
    @Published var contents = [
        ConductingSheetContent(index: ConductingSectionsIndexes.welcome.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.welcome,
                               lowerContent: Constants.ConductingSheetContents.Lower.welcome),
        ConductingSheetContent(index: ConductingSectionsIndexes.announcements.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.announcement,
                               lowerContent: Constants.ConductingSheetContents.Lower.announcement),
        ConductingSheetContent(index: ConductingSectionsIndexes.openingHymn.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.openHymnInvocation,
                               lowerContent: Constants.ConductingSheetContents.Lower.openHymnInvocation),
        ConductingSheetContent(index: ConductingSectionsIndexes.wardBusinessMoveIns.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.moveIns,
                               lowerContent: Constants.ConductingSheetContents.Lower.moveIns),
        ConductingSheetContent(index: ConductingSectionsIndexes.wardBusinessReleases.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.releases,
                               lowerContent: Constants.ConductingSheetContents.Lower.releases),
        ConductingSheetContent(index: ConductingSectionsIndexes.wardBusinessSustainings.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.sustainings,
                               lowerContent: Constants.ConductingSheetContents.Lower.sustainings),
        ConductingSheetContent(index: ConductingSectionsIndexes.wardBusinessOrdinations.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.ordinations,
                               lowerContent: Constants.ConductingSheetContents.Lower.ordinations),
        ConductingSheetContent(index: ConductingSectionsIndexes.sacramentMusic.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.sacrament,
                               lowerContent: Constants.ConductingSheetContents.Lower.sacrament),
        ConductingSheetContent(index: ConductingSectionsIndexes.speakersAndMusic.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.sacramentProgram,
                               lowerContent: Constants.ConductingSheetContents.Lower.sacramentProgram),
        ConductingSheetContent(index: ConductingSectionsIndexes.closingHymn.rawValue,
                               upperContent: Constants.ConductingSheetContents.Upper.closeHymnBenediction,
                               lowerContent: Constants.ConductingSheetContents.Lower.closeHymnBenediction)
    ]

    @Published var orgMbrCallingViewModel: OrgMbrCallingViewModel = OrgMbrCallingViewModel.shared
    @Published var showAddAnnouncementAlert = false

    static let shared = ConductingSheetViewModel()
    
    public init(conductingSheetSections: [ConductingSheetSection] = [ConductingSheetSection]()) {
        self.conductingSheetSections = conductingSheetSections
        super.init()
        
        fetchConductingSheetsData() { fetched in
            if fetched {
                self.setConductingSheetSection()
            }
        }
    }
    
    func fetchConductingSheetsData(completion: @escaping (Bool) -> Void) {
        getOrdinanceInterviews()

        AnnouncementsViewModel.shared.fetchData {
            for announcement in AnnouncementsViewModel.shared.announcements {
                if !announcement.fyi.isEmpty && announcement.announced == "N" {
                    self.announcementsDataSource.append(announcement.fyi)
                }
            }
            
            self.fetchNewMoveIns() { fetched in
                if fetched {
                    PrayersViewModel.shared.getCurrentOrNextPrayers() {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func getOrdinanceInterviews() {
        let interviews = InterviewsViewModel.shared.interviews
        
        if interviews.isEmpty {
            ordinationsDataSource = InterviewsViewModel.shared.getOrdinances()
        } else {
            for interview in interviews {
                if interview.category == "Ordinances" {
                    ordinationsDataSource.append(interview)
                }
            }
        }
    }
    
    func fetchNewMoveIns(completion: @escaping (Bool) -> Void) {
        var completedSearchOfMembersForNotWelcomed = false
        
        for (index, member) in MembersViewModel.shared.members.enumerated() {
            if member.welcomed == "N" {
                self.moveInsDataSource.append(member.name)
            }
            
            if index == MembersViewModel.shared.members.count {
                completedSearchOfMembersForNotWelcomed = true
            }
        }
        
        if completedSearchOfMembersForNotWelcomed {
            completion(completedSearchOfMembersForNotWelcomed)
        }
    }
    
    func memberWelcomed(name: String) {
        for (index, member) in MembersViewModel.shared.members.enumerated() {
            if member.name == name {
                MembersViewModel.shared.members[index].welcomed = "Y"
                
                MembersViewModel.shared.updateMember(model: MembersViewModel.shared.members[index]) {
                    self.moveInsDataSource.removeAll()
                    
                    for mbr in MembersViewModel.shared.members {
                        if mbr.welcomed == "N" {
                            self.moveInsDataSource.append(mbr.name)
                        }
                    }
                    
                    self.selectedConductingSheetSection.wardBusinessMoveIns = self.moveInsDataSource
                }
            }
        }
        
        if moveInsDataSource.isEmpty {
            moveInsDataSource.removeAll()
            self.selectedConductingSheetSection.wardBusinessMoveIns = self.moveInsDataSource
        }
    }
    
    func announcementAnnounced(proclamation: String) {
        for announcement in AnnouncementsViewModel.shared.announcements {
            if announcement.fyi == proclamation {
                AnnouncementsViewModel.shared.deleteAnnouncement(announcement: announcement) {
                    self.announcementsDataSource.removeAll()
                    
                    for announcement in AnnouncementsViewModel.shared.announcements {
                        self.announcementsDataSource.append(announcement.fyi)
                    }
                    
                    self.selectedConductingSheetSection.announcements = self.announcementsDataSource
                }
            }
        }
        
        if AnnouncementsViewModel.shared.announcements.isEmpty {
            announcementsDataSource.removeAll()
            self.selectedConductingSheetSection.announcements = self.announcementsDataSource
        }
    }
    
    func setConductingSheetSection() {
        if !conductingSheetSections.isEmpty {
            conductingSheetSections.removeAll()
        }
        
        for prayer in PrayersViewModel.shared.currentWeeksPrayers {
            if !prayer.name.isEmpty {
                if prayer.type == "Invocation" {
                    invocation = prayer.name
                } else {
                    benediction = prayer.name
                }
            }
        }
        
        if !invocation.isEmpty {
            contents[ConductingSectionsIndexes.openingHymn.rawValue].lowerContent =  contents[ConductingSectionsIndexes.openingHymn.rawValue].lowerContent.replacingOccurrences(of: "<Member>", with: invocation)
        }
        
        if !benediction.isEmpty {
            contents[ConductingSectionsIndexes.closingHymn.rawValue].lowerContent =  contents[ConductingSectionsIndexes.closingHymn.rawValue].lowerContent.replacingOccurrences(of: "<Member>", with: benediction)
        }
        
        for content in contents {
            switch content.index {
            case ConductingSectionsIndexes.welcome.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: -1,
                    showList: true,
                    showTextField: true,
                    showAddButton: false,
                    sheetSection: 0,
                    sectionTitle: ConductingSectionsTitles.welcome.stringValue,
                    upperSectionContent: content.upperContent.replacingOccurrences(of: "<Leader>", with: orgMbrCallingViewModel.getLeaderName()),
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: false,
                    lowerSectionIsEditable: true))
            case ConductingSectionsIndexes.announcements.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: -1,
                    showList: true,
                    showTextField: true,
                    showAddButton: false,
                    sheetSection: 1,
                    sectionTitle: ConductingSectionsTitles.announcements.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: announcementsDataSource.isEmpty ? ["No Announcements"] : announcementsDataSource,
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "Enter announcement...",
                    upperSectionIsEditable: false,
                    lowerSectionIsEditable: false))
            case ConductingSectionsIndexes.openingHymn.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: content.index,
                    showList: true,
                    showTextField: true,
                    showAddButton: false,
                    sheetSection: 2,
                    sectionTitle: ConductingSectionsTitles.openingHymn.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: "",
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: "",
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: true,
                    lowerSectionIsEditable: true))
            case ConductingSectionsIndexes.wardBusinessMoveIns.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: -1,
                    showList: true,
                    showTextField: true,
                    showAddButton: false,
                    sheetSection: 3,
                    sectionTitle: ConductingSectionsTitles.wardBusinessMoveIns.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: moveInsDataSource.isEmpty ? ["No New Members Moved In"] : moveInsDataSource,
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "Enter new move-in member name...",
                    upperSectionIsEditable: false,
                    lowerSectionIsEditable: false))
            case ConductingSectionsIndexes.wardBusinessReleases.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: -1,
                    showList: true,
                    showTextField: false,
                    showAddButton: false,
                    sheetSection: 4,
                    sectionTitle: ConductingSectionsTitles.wardBusinessReleases.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: false,
                    lowerSectionIsEditable: false))
            case ConductingSectionsIndexes.wardBusinessSustainings.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: -1,
                    showList: true,
                    showTextField: false,
                    showAddButton: false,
                    sheetSection: 5,
                    sectionTitle: ConductingSectionsTitles.wardBusinessSustainings.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: false,
                    lowerSectionIsEditable: false))
            case ConductingSectionsIndexes.wardBusinessOrdinations.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: -1,
                    showList: true,
                    showTextField: true,
                    showAddButton: true,
                    sheetSection: 6,
                    sectionTitle: ConductingSectionsTitles.wardBusinessOrdinations.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: false,
                    lowerSectionIsEditable: false))
            case ConductingSectionsIndexes.sacramentMusic.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: content.index,
                    showList: true,
                    showTextField: false,
                    showAddButton: false,
                    sheetSection: 7,
                    sectionTitle: ConductingSectionsTitles.sacramentMusic.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: true,
                    lowerSectionIsEditable: false))
            case ConductingSectionsIndexes.speakersAndMusic.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: content.index,
                    showList: true,
                    showTextField: false,
                    showAddButton: false,
                    sheetSection: 8,
                    sectionTitle: ConductingSectionsTitles.speakersAndMusic.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: true,
                    lowerSectionIsEditable: true))
            case ConductingSectionsIndexes.closingHymn.rawValue:
                conductingSheetSections.append(ConductingSheetSection(songForSection: content.index,
                    showList: true,
                    showTextField: false,
                    showAddButton: false,
                    sheetSection: 9,
                    sectionTitle: ConductingSectionsTitles.closingHymn.stringValue,
                    upperSectionContent: content.upperContent,
                    lowerSectionContent: content.lowerContent,
                    conducting: "",
                    presiding: "",
                    announcements: ["No Announcements"],
                    openingSong: (title: "", number: ""),
                    invocation: invocation,
                    wardBusinessMoveIns: ["No New Members Moved In"],
                    wardBusinessReleases: [(member: "No Releases", calling: "")],
                    wardBusinessSustainings: [(member: "No Sustainings", calling: "")],
                    sacramentSong: (title: "", number: ""),
                    musicProviders: [String](),
                    speakers: [String](),
                    intermediatMusic: (title: "", number: ""),
                    ordinations: [(member: "No Ordinations", office: "")],
                    closingSong: (title: "", number: ""),
                    benediction: benediction,
                    textFieldPlaceholderText: "",
                    upperSectionIsEditable: true,
                    lowerSectionIsEditable: true))
            default:
                break
            }
        }
    }
    
    func convertTupleToStringArray(for type: TupleTypes) {
        switch type {
        case .releases:
            if !selectedConductingSheetSection.wardBusinessReleases.isEmpty {
                if let firstElement = releasesDataSource.first {
                    if firstElement.contains("No Releases") {
                        releasesDataSource.removeAll()
                    }
                } else {
                   // releasesDataSource.append("No Releases")
                }

                for releases in selectedConductingSheetSection.wardBusinessReleases {
                    if releases.member == "No Releases" {
                        releasesDataSource.append(releases.member)
                    } else {
                        if !releases.member.isEmpty {
                            releasesDataSource.append("Member: \(releases.member)\tCalling: \(releases.calling)")
                        }
                    }
                }
            }
        case .sustainings:
            if !selectedConductingSheetSection.wardBusinessSustainings.isEmpty {
                if let firstElement = sustainingsDataSource.first {
                    if firstElement.contains("No Sustainings") {
                        sustainingsDataSource.removeAll()
                    }
                }

                for sustainings in selectedConductingSheetSection.wardBusinessSustainings {
                    if sustainings.member == "No Sustainings" {
                        sustainingsDataSource.append(sustainings.member)
                    } else {
                        if !sustainings.member.isEmpty {
                            sustainingsDataSource.append("Member: \(sustainings.member)\tCalling: \(sustainings.calling)")
                        }
                    }
                }
            }

        case .ordinations:
            break
           // getOrdinanceInterviews()
//            if !selectedConductingSheetSection.ordinations.isEmpty {
//                if let firstElement = ordinationsDataSource.first {
//                    if firstElement.contains("No Ordinations") {
//                        ordinationsDataSource.removeAll()
//                    }
//                }
//
//                for ordinations in selectedConductingSheetSection.ordinations {
//                    if ordinations.member == "No Ordinations" {
//                        ordinationsDataSource.append(ordinations.member)
//                    } else {
//                        if !ordinations.member.isEmpty {
//                            ordinationsDataSource.append("Member: \(ordinations.member)\tOffice: \(ordinations.office)")
//                        }
//                    }
//                }
//            }
        }
    }
    
    func setSpeakingAssignmentsForCurrentWeekNumber(week: Int) {
        switch week {
        case 1:
            currentWeeksSpeakingAssignments = SpeakingAssignmentsViewModel.shared.speakersForWeekOne
        case 2:
            currentWeeksSpeakingAssignments = SpeakingAssignmentsViewModel.shared.speakersForWeekTwo
        case 3:
            currentWeeksSpeakingAssignments = SpeakingAssignmentsViewModel.shared.speakersForWeekThree
        case 4:
            currentWeeksSpeakingAssignments = SpeakingAssignmentsViewModel.shared.speakersForWeekFour
        case 5:
            currentWeeksSpeakingAssignments = SpeakingAssignmentsViewModel.shared.speakersForWeekFive
        default:
            break
        }
    }
}
