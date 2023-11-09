//
//  OrdinationsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/30/23.
//

import SwiftUI

struct OrdinationsListView: View {
    @Environment(\.branding) var branding
    
    @ObservedObject var viewModel: OrdinationsViewModel
    
    @State private var showCloseButton: Bool = true
//    @State private var showConfirmDeleteOrganization: Bool = false
    
    init(showCloseButton: Bool = true, /*showConfirmDeleteOrganization: Bool = false,*/ viewModel: OrdinationsViewModel = OrdinationsViewModel.shared) {
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 50 ) {
            if viewModel.ordinations.isEmpty {
                ListHeaderView(headingTitle: ListHeadingTitles.ordinations.rawValue,
                               showCloseButton: $showCloseButton,
                               isInnerListHeader: .constant(false),
                               showConfirmDeleteOrganization: .constant(false),
                               membersViewModel: MembersViewModel.shared,
                               backgroundClr: branding.outerHeaderBackgroundColor,
                               addButtonAction: {_ in })

                Text("No Ordinations")
                    .customText(color: branding.contentTextColor,
                                font: branding.paragraphTextAndLinks_Semibold_17pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 0,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .center)
            } else {
                VStack(spacing: 20) {
                    ListHeaderView(headingTitle: ListHeadingTitles.ordinations.rawValue,
                                   showCloseButton: $showCloseButton,
                                   isInnerListHeader: .constant(false),
                                   showConfirmDeleteOrganization: .constant(false),
                                   membersViewModel: MembersViewModel.shared,
                                   backgroundClr: branding.outerHeaderBackgroundColor,
                                   addButtonAction: {_ in })
                    
                    List(viewModel.wardBranchOrdinationSectionTitles, id: \.self) {
                        sectionTitle in
                        OrdinationListGroup(sectionTitle: sectionTitle, viewModel: viewModel)
                    }
                    .cornerRadius(15)
                    .padding(.top, -40)
                    .padding(.bottom, 20)
                    .listStyle(SidebarListStyle())
                    .navigationBarTitleDisplayMode(.automatic)
                }
            }
        }
        .cornerRadius(15)
        .onAppear {
            viewModel.fetchData {
                if !viewModel.ordinations.isEmpty {
                    viewModel.ordinations = viewModel.sortOrdinations()
                } else {
                    if !InterviewsViewModel.shared.interviews.isEmpty {
                        for interview in InterviewsViewModel.shared.interviews {
                            if !interview.ordination.isEmpty {
                                if AppDelegate.unitType == UnitTypes.ward.stringValue || AppDelegate.unitType == UnitTypes.branch.stringValue {
                                    if interview.ordination == OrdinationOfficeCategories.deacon.rawValue || interview.ordination == OrdinationOfficeCategories.teacher.rawValue || interview.ordination == OrdinationOfficeCategories.priest.rawValue || interview.ordination == OrdinationOfficeCategories.elder.rawValue || interview.ordination == OrdinationOfficeCategories.highPriest.rawValue {
                                        viewModel.ordinations.append(Ordination(uid: interview.uid, name: interview.name, ordinationOffice: interview.ordination, status: interview.status, datePerformed: interview.scheduledInterviewDate))
                                    }
                                } else {
                                    if interview.ordination == OrdinationOfficeCategories.patriarch.rawValue || interview.ordination == OrdinationOfficeCategories.bishop.rawValue || interview.ordination == OrdinationOfficeCategories.elder.rawValue || interview.ordination == OrdinationOfficeCategories.highPriest.rawValue {
                                        viewModel.ordinations.append(Ordination(uid: interview.uid, name: interview.name, ordinationOffice: interview.ordination, status: interview.status, datePerformed: interview.scheduledInterviewDate))
                                    }
                                }
                            }
                        }
                        
                        viewModel.ordinations = viewModel.sortOrdinations()
                    }
                }
            }
        }
    }
}

struct OrdinationListGroup: View {
    @Environment(\.branding) var branding
    
    @ObservedObject var viewModel: OrdinationsViewModel
    
    @State private var isExpanded = false
    
    var sectionTitle = ""
    
    init(sectionTitle: String = "",
         viewModel: OrdinationsViewModel
    ) {
        self.sectionTitle = sectionTitle
        self.viewModel = viewModel
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded,
            content: {
            ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: viewModel.disclosureGroupHeaders)
                
                ForEach(Array(viewModel.ordinations.enumerated()), id: \.offset) { (index, ordination) in
                    if sectionTitle == ordination.ordinationOffice {
                        ListContentRow(contents: [ordination.name, ordination.ordinationOffice, ordination.status, ordination.datePerformed],
                                       bottomPadding: 5,
                                       topPadding: 0,
                                       leadingPadding: 20,
                                       trailingPadding: 20,
                                       rowContentIsRecommendations: false,
                                       alignRowsInHStack: .constant(true))
                            .frame(height: 130)
                            .listRowSeparatorTint(.clear)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    viewModel.deleteOrdination(ordination: ordination)
                                } label: {
                                    Text("Ordained")
                                        .customText(color: branding.destructiveButton,
                                                    font: branding.paragraphTextAndLinks_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: 0,
                                                    alignment: .leading)
                                }
                                .tint(branding.destructiveButton)
                                .font(branding.paragraphTextAndLinks_Regular_17pt)
                            }
                    }
                }
            },
            label: {
                DisclosureGroupLabelWithChevronsView(sectionTitle: sectionTitle,
                    showExpansionChevrons: true,
                    isExpanded: $isExpanded)
            })
    }
}
