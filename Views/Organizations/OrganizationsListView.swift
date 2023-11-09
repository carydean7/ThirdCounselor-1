//
//  OrganizationsListView.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 3/14/23.
//

import SwiftUI

struct OrganizationsListView: View {
    @Environment(\.branding) var branding

    @ObservedObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var organizationsViewModel: OrganizationsViewModel
    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel
    
    @State private var showAddItemButton: Bool = true
    @State private var headingTitle: String = ListHeadingTitles.organizations.rawValue
    @State private var showAddToViewModel = false
    @State private var showCloseButton = false
    @State private var navigationTitle = ""
    @State private var listHeaderTopPadding: CGFloat = 140.0
    @State private var listHeaderHeight: CGFloat = 40.0
    @State private var navigationViewTopPadding: CGFloat = 95.0
    @State private var font: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt
    @State private var showAlert = false
    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var showCallingActions: Bool = false
    
    init(organizationsViewModel: OrganizationsViewModel,
         showAddItemButton: Bool = true,
         showAlert: Bool = false,
         showConfirmDeleteOrganization: Bool = false,
         showCallingActions: Bool = false,
         headingTitle: String = "",
         showAddToViewModel: Bool = false,
         showCloseButton: Bool = false,
         membersViewModel: MembersViewModel = MembersViewModel.shared,
         orgMbrCallingViewModel: OrgMbrCallingViewModel = OrgMbrCallingViewModel.shared,
         speakingAssignmentsViewModel: SpeakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared) {
        self.organizationsViewModel = organizationsViewModel
        self.showAddItemButton = showAddItemButton
        self.showAlert = showAlert
        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showCallingActions = showCallingActions
        self.headingTitle = headingTitle
        self.showAddToViewModel = showAddToViewModel
        self.showCloseButton = showCloseButton
        self.membersViewModel = membersViewModel
        self.orgMbrCallingViewModel = orgMbrCallingViewModel
        self.speakingAssignmentsViewModel = speakingAssignmentsViewModel
    }
            
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.organizations.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: $showConfirmDeleteOrganization,
                           membersViewModel: membersViewModel,
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                           backgroundClr: branding.outerHeaderBackgroundColor,
                           addButtonAction: {_ in })
                .onAppear {
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate

                    membersViewModel.shouldShowAddItemButton = false
                    organizationsViewModel.shouldShowAddItemButton = true
                    
                    switch (Constants.deviceIdiom) {
                    case .pad:
                        if appDelegate.isLandscape {
                            listHeaderTopPadding = 120
                            navigationViewTopPadding = 60.0
                            font = branding.paragraphTextAndLinks_Semibold_17pt
                        } else {
                            
                        }
                    case .phone:
                        listHeaderTopPadding = 100
                        listHeaderHeight = 40
                        navigationViewTopPadding = 60
                    default:
                        break
                    }
                }
                .padding(.top, listHeaderTopPadding)
                .frame(height: listHeaderHeight)
            
            NavigationView {
                List(organizationsViewModel.organizations) { organization in
                    if TabBarController.currentlySelectedTab == TabBarTagIdentifiers.callings.rawValue {
                        NavigationLink(destination:
                                        CallingsAndMbrsInOrgListView(callingsWithMembersInSelectedOrganization: nil,
                                            selectedOrganization: organization,
                                            membersViewModel: membersViewModel,
                                                                     speakingAssignmentsViewModel: speakingAssignmentsViewModel)) {
                            OrganizationRow(organization: organization)
                                .frame(height: 30)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        organizationsViewModel.currentlySelectedOrganization = organization
                                        showAlert = true
                                        showConfirmDeleteOrganization = true
                                    } label: {
                                        Text("Delete Organization")
                                            .customText(color: branding.nonDestructiveButton,
                                                        font: branding.paragraphTextAndLinks_Semibold_17pt,
                                                        btmPad: 0,
                                                        topPad: 0,
                                                        leadPad: 0,
                                                        trailPad: 0,
                                                        width: .infinity,
                                                        alignment: .leading)
                                    }
                                    .tint(branding.nonDestructiveButton)
                                }
                        }
                        .listRowSeparator(.hidden)
                    } else {
                        NavigationLink(destination:
                                        CallingsAndMbrsInOrgActionsListView(callingsWithMembersInSelectedOrganization: nil,
                                            showCallingActions: showCallingActions,
                                            selectedOrganization: organization,
                                            membersViewModel: membersViewModel,
                                                                     speakingAssignmentsViewModel: speakingAssignmentsViewModel)) {
                            OrganizationRow(organization: organization)
                                .frame(height: 30)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .foregroundColor(branding.outerHeaderBackgroundColor)
                .fontWeight(.bold)
                .cornerRadius(25.0)
                .padding(.top, 10)
            }
            .onAppear {
                organizationsViewModel.shouldShowAddItemButton = true
                membersViewModel.shouldShowCloseButon = false
                organizationsViewModel.fetchData {}
            }
            .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
            .cornerRadius(20.0)
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(.top, navigationViewTopPadding)
            .padding([.leading, .trailing], 10)
        }
        .onAppear {
            membersViewModel.shouldShowCloseButon = false
        }
        .environmentObject(membersViewModel)
        .environmentObject(orgMbrCallingViewModel)
    }
}
