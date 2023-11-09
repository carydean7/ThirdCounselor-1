//
//  SpeakingAssignmentsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/24/23.
//

import SwiftUI

struct SpeakingAssignmentsListView: View {
    @Environment(\.branding) var branding

    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var viewModel: SpeakingAssignmentsViewModel
    
    @State private var showAddToViewModel: Bool
    @State private var alphaToMember = [String]()
    @State private var showAddItemButton: Bool
    @State private var expandRow: Bool = false
    @State private var showCloseButton = true
    @State private var isSheet: Bool
    @State private var lowerTextContent: String?
    @State private var font: Font = Branding.mock.screenTitle_Title_34pt
    @State private var filterSelection = "History"
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var speakersWithInLast6MonthsIsExpanded = false
    @State private var speakers6moTo1YrIsExpanded = false
    @State private var speakersMoreThan1YrIsExpanded = false
    @State private var membersWhoHaveNotSpokenIsExpanded = false

    let filters = ["History", "Current"]
    
    public init(membersViewModel: MembersViewModel,
                viewModel: SpeakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared,
                showAddToViewModel: Bool = false,
                alphaToMember: [String] = [String](),
                showAddItemButton: Bool = false,
                expandRow: Bool = false,
                showCloseButton: Bool = true,
//                showConfirmDeleteOrganization: Bool = false,
                isSheet: Bool = false,
                lowerTextContent: String = "" ) {
        self.viewModel = viewModel
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showAddItemButton = showAddItemButton
        self.showAddToViewModel = showAddToViewModel
        self.alphaToMember = alphaToMember
        self.expandRow = expandRow
        self.isSheet = isSheet
        self.lowerTextContent = lowerTextContent
        self.membersViewModel = membersViewModel
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.speakingAssignment.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: membersViewModel,
                           speakingAssignmentsViewModel: viewModel,
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })
            
            Picker("Speaker Assignment Filters", selection: $filterSelection) {
                ForEach(filters, id:\.self) {
                    Text($0)
                        .customText(color: branding.destructiveButton,
                                    font: font,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .leading)
                }
            }
            .padding([.leading, .trailing], 20)
            .pickerStyle(.segmented)
            
            if filterSelection == "History" {
                NavigationView {
                    List(viewModel.disclosureGroupSectionTitles, id: \.self) {  sectionTitle in
                        CustomDisclosureGroupView(isExpanded: false,
                                                  speakingAssignments: viewModel.getSpeakingAssignments(for: sectionTitle),
                                                              sectionTitle: sectionTitle,
                                                              headingTitles: viewModel.disclosureGroupColumnHeadings,
                                                  contentType: .speakingAssignment)
                    }
                    .listStyle(SidebarListStyle())
                    .navigationBarTitleDisplayMode(.automatic)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    switch (Constants.deviceIdiom) {
                    case .pad:
                        font = branding.paragraphTextAndLinks_Semibold_17pt
                    case .phone:
                        font = branding.paragraphTextAndLinks_Regular_17pt
                    default:
                        break
                    }
                    
                    viewModel.fetchData {
                        viewModel.filterSpeakingAssignment()
                    }
                }
                .padding([.leading, .trailing], 10)
                .cornerRadius(25.0)
            } else {
                SpeakingAssignments12WeekView(viewModel: viewModel)
                    .padding([.leading, .trailing], 10)
            }
        }
        .cornerRadius(25.0)
        .environment(\.colorScheme, .light)
    }
}
