//
//  ConductingSheetSection.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/1/22.
//

import SwiftUI

struct ConductingSheetSection: Identifiable, Hashable {
    static func == (lhs: ConductingSheetSection, rhs: ConductingSheetSection) -> Bool {
        lhs.sectionTitle == rhs.sectionTitle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionTitle)
    }
    
    typealias wardBusinessReleasesSustainings = [(member: String, calling: String)]
    typealias songInfo = (title: String, number: String)
    
    var id = UUID().uuidString
    
  //  var uid: String
    var songForSection: Int
    var showList: Bool
    var showTextField: Bool
    var showAddButton: Bool
    var sheetSection: Int
    var sectionTitle: String?
    var upperSectionContent: String?
    var lowerSectionContent: String?
    var conducting: String?
    var presiding: String?
    var announcements: [String] = [String]()
    var openingSong: (title: String, number: String)?
    var invocation: String?
    var wardBusinessMoveIns: [String] = [String]()
    var wardBusinessReleases: [(member: String, calling: String)] // wardBusinessReleasesSustainings?
    var wardBusinessSustainings: [(member: String, calling: String)] //wardBusinessReleasesSustainings?
    var sacramentSong: (title: String, number: String)?
    var musicProviders: [String]?
    var speakers: [String]?
    var intermediatMusic: (title: String, number: String)?
    var ordinations: [(member: String, office: String)]
    var closingSong: (title: String, number: String)?
    var benediction: String?
    var textFieldPlaceholderText: String
    var upperSectionIsEditable: Bool
    var lowerSectionIsEditable: Bool
    
    init(songForSection: Int = -1,
         showList: Bool = false,
         showTextField: Bool = false,
         showAddButton: Bool = false,
         sheetSection: Int = 0,
         sectionTitle: String = "",
         upperSectionContent: String = "",
         lowerSectionContent: String = "",
         conducting: String = "",
         presiding: String = "",
         announcements: [String] = [String](),
         openingSong: songInfo,
         invocation: String = "",
         wardBusinessMoveIns: [String] = [String](),
         wardBusinessReleases: wardBusinessReleasesSustainings,
         wardBusinessSustainings: wardBusinessReleasesSustainings,
         sacramentSong: songInfo,
         musicProviders: [String] = [String](),
         speakers: [String] = [String](),
         intermediatMusic: songInfo,
         ordinations: [(member: String, office: String)],
         closingSong: songInfo,
         benediction: String = "",
         textFieldPlaceholderText: String = "",
         upperSectionIsEditable: Bool,
         lowerSectionIsEditable: Bool) {
        self.songForSection = songForSection
        self.showList = showList
        self.showTextField = showTextField
        self.showAddButton = showAddButton
        self.sheetSection = sheetSection
        self.sectionTitle = sectionTitle
        self.upperSectionContent = upperSectionContent
        self.lowerSectionContent = lowerSectionContent
        self.conducting = conducting
        self.presiding = presiding
        self.announcements = announcements
        self.openingSong = openingSong
        self.invocation = invocation
        self.wardBusinessMoveIns = wardBusinessMoveIns
        self.wardBusinessReleases = wardBusinessReleases
        self.wardBusinessSustainings = wardBusinessSustainings
        self.sacramentSong = sacramentSong
        self.musicProviders = musicProviders
        self.speakers = speakers
        self.intermediatMusic = intermediatMusic
        self.ordinations = ordinations
        self.closingSong = closingSong
        self.benediction = benediction
        self.textFieldPlaceholderText = textFieldPlaceholderText
        self.upperSectionIsEditable = upperSectionIsEditable
        self.lowerSectionIsEditable = lowerSectionIsEditable
    }
}
