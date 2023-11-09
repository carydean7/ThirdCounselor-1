//
//  CustomDisclosureGroupView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/7/23.
//

import SwiftUI

enum DisclosureGroupType {
    case none
    case speakersWithInLast6MonthsIsExpanded
    case speakers6moTo1YrIsExpanded
    case speakersMoreThan1YrIsExpanded
    case membersWhoHaveNotSpokenIsExpanded
}

struct CustomDisclosureGroupView: View {
    @Environment(\.branding) var branding

    @State private var isExpanded: Bool = false
    @State private var disclosureGroupType: DisclosureGroupType = .none
    @State private var sundayDates: [String] = [String]()
    @State private var contentType: CustomDisclosureGroupViewContentTypes
    
    var speakingAssignments: [SpeakingAssignment] = [SpeakingAssignment]()
    var prayers: [Prayer] = [Prayer]()
    var sectionTitle: String = ""
    var headingTitles: [String] = [String]()
    
    init(isExpanded: Bool = false,
         speakingAssignments: [SpeakingAssignment] = [SpeakingAssignment](),
         prayers: [Prayer] = [Prayer](),
         sectionTitle: String = "",
         disclosureGroupType: DisclosureGroupType = .none,
         sundayDates: [String] = [String](),
         headingTitles: [String] = [String](),
         contentType: CustomDisclosureGroupViewContentTypes = .speakingAssignment) {
        self.isExpanded = isExpanded
        self.speakingAssignments = speakingAssignments
        self.prayers = prayers
        self.sectionTitle = sectionTitle
        self.disclosureGroupType = disclosureGroupType
        self.sundayDates = sundayDates
        self.headingTitles = headingTitles
        self.contentType = contentType
    }
    
    var body: some View {
        DisclosureGroup (isExpanded: $isExpanded,
            content: {
            if contentType == .speakingAssignment {
                ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: headingTitles)
                    ForEach(speakingAssignments, id: \.self) { speakingAssignment in
                        ListContentRow(contents: [speakingAssignment.name, speakingAssignment.topic, speakingAssignment.askToSpeakOnDate], 
                                       bottomPadding: 5,
                                       topPadding: 0,
                                       leadingPadding: 20,
                                       trailingPadding: 20,
                                       rowContentIsRecommendations: false,
                                       alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                    }
            } else {
                ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: headingTitles)
                    ForEach(prayers, id: \.self) { prayer in
                        ListContentRow(contents: [prayer.name, prayer.type, prayer.date],
                                       bottomPadding: 5,
                                       topPadding: 0,
                                       leadingPadding: 20,
                                       trailingPadding: 20,
                                       rowContentIsRecommendations: false,
                                       alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                    }
            }
            }, label: {
                DisclosureGroupLabelWithChevronsView(sectionTitle: sectionTitle,
                    showExpansionChevrons: true,
                    isExpanded: $isExpanded)
            })
    }
}

struct DisclosureGroupLabelWithChevronsView: View {
    @Environment(\.branding) var branding
    
    @State private var showExpansionChevrons = false
    
    @Binding var isExpanded: Bool

    var sectionTitle = ""
    
    init(sectionTitle: String = "",
         showExpansionChevrons: Bool,
         isExpanded: Binding<Bool>) {
        self.sectionTitle = sectionTitle
        self.showExpansionChevrons = showExpansionChevrons
        self._isExpanded = isExpanded
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(sectionTitle)
                    .customText(color: branding.labels,
                                font: branding.paragraphTextAndLinks_Semibold_17pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 0,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .leading)
                
                if showExpansionChevrons {
                    Spacer()
                    
                    if isExpanded {
                        Image(systemName: "chevron.down")
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.labels)
                            .frame(alignment: .trailing)
                    } else {
                        Image(systemName: "chevron.forward")
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.labels)
                            .frame(alignment: .trailing)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
