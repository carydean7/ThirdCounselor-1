//
//  CallingsAndMbrsInOrgActionsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/20/23.
//

import SwiftUI

struct CallingsAndMbrsInOrgActionsListView: View {
    @Environment(\.branding) var branding
    
    @EnvironmentObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel
    
    @State private var primaryFont: Font
    @State private var secondaryFont: Font
    @State private var listHeaderTopPadding: CGFloat = 140.0
    @State private var listHeaderHeight: CGFloat = 40.0
    @State private var navigationViewTopPadding: CGFloat = 95.0
    @State private var showCallingActions = false
    @State private var showMembersList = false
    @State private var selectedCalling: String = ""
    @State private var newlyAssignedMember: String = ""
    @State private var isSheet: Bool = false
    @State private var sectionHeading = ""
    @State private var showEditButton: Bool = false
    @State private var showLeaders = false
    @State private var selectedLeader = ""
    @State private var actionType: ActionTypes = .recommendationApproved
    @State private var bishopBranchStakePresidentOnly = false
    @State private var callingsWithMembersInSelectedOrganization = Array(arrayLiteral: OrgMbrCalling())
    
    var selectedOrganization: Organization
    
    public init(primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt,
                secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt,
                callingsWithMembersInSelectedOrganization: [OrgMbrCalling]? = nil,
                showMembersList: Bool = false,
                showEditButton: Bool = false,
                showCallingActions: Bool = false,
                showLeaders: Bool = false,
                selectedLeader: String = "",
                actionType: ActionTypes = .recommendationApproved,
                bishopBranchStakePresidentOnly: Bool = false,
                selectedOrganization: Organization = Organization(id: "", uid: "", name: ""),
                sectionHeading: String = "",
                membersViewModel: MembersViewModel,
                speakingAssignmentsViewModel: SpeakingAssignmentsViewModel) {
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.membersViewModel = membersViewModel
        self.speakingAssignmentsViewModel = speakingAssignmentsViewModel
        self.callingsWithMembersInSelectedOrganization = callingsWithMembersInSelectedOrganization ?? [OrgMbrCalling]()
        self.showMembersList = showMembersList
        self.showEditButton = showEditButton
        self.showCallingActions = showCallingActions
        self.showLeaders = showLeaders
        self.selectedLeader = selectedLeader
        self.actionType = actionType
        self.bishopBranchStakePresidentOnly = bishopBranchStakePresidentOnly
        self.selectedOrganization = selectedOrganization
        self.selectedCalling = selectedCalling
        self.newlyAssignedMember = newlyAssignedMember
        self.sectionHeading = sectionHeading
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 10) {
                    Text(ListHeadingTitles.callingActions.rawValue)
                        .customText(color: branding.labels,
                                    font: branding.screenTitle_Title_34pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                    
                    Text(selectedOrganization.name)
                        .customText(color: branding.labels,
                                    font: branding.secondaryListRow_iPad_Title2_28pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                    
                    Divider()
                    
                    List {
                        ForEach(orgMbrCallingViewModel.callingActionsInSelectedOrganization, id: \.self) {
                            orgMbrCalling in
                            HStack {
                                VStack(alignment: .leading) {
                                    CallingActionRow(orgMbrCalling: orgMbrCalling, primaryFont: primaryFont, secondaryFont: secondaryFont)
                                }
                                
                                HStack {
                                    if !orgMbrCalling.callingAction.isEmpty || !orgMbrCalling.callingAction.contains("No Further Action") {
                                        switch orgMbrCalling.callingAction {
                                        case String(ActionTypes.recommendationsForApproval.rawValue):
                                            Text("Recommendation: ")
                                                .customText(color: branding.labels,
                                                            font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                            btmPad: 0,
                                                            topPad: 0,
                                                            leadPad: 0,
                                                            trailPad: 0,
                                                            width: 200,
                                                            alignment: .leading)
                                            
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.approved.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 10,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                         showLeaders: $showLeaders,
                                                         color: branding.nonDestructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt,
                                                         nextActionTypeMessage: "",
                                                         itemIndex: 0,
                                                         actionHandler: { index in
                                                
                                            })
                                            
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.notApproved.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 10,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                         showLeaders: $showLeaders,
                                                         color: branding.destructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt, nextActionTypeMessage: "",
                                                         itemIndex: 0,
                                                         actionHandler: { index in
                                                
                                            })
                                            
                                        case String(ActionTypes.extendCall.rawValue):
                                            Text("Call: ")
                                                .customText(color: branding.labels,
                                                            font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                            btmPad: 0,
                                                            topPad: 0,
                                                            leadPad: 0,
                                                            trailPad: 0,
                                                            width: 200,
                                                            alignment: .leading)
                                            
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.accepted.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 0,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                         showLeaders: $showLeaders,
                                                         color: branding.nonDestructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt, nextActionTypeMessage: "",
                                                         itemIndex: 0,
                                                         actionHandler: { index in
                                                
                                            })
                                            
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.declined.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 0,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                         showLeaders: $showLeaders,
                                                         color: branding.destructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt, nextActionTypeMessage: "",
                                                         itemIndex: 0,
                                                         actionHandler: { index in
                                                
                                            })
                                            
                                        case ActionTypeSectionTitles.sustained.stringValue:
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.sustained.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 0,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                         showLeaders: $showLeaders,
                                                         color: branding.nonDestructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt, nextActionTypeMessage: "",
                                                         itemIndex: 0,
                                                         actionHandler: { index in
                                                
                                            })
                                            
                                        case ActionTypeSectionTitles.setApart.stringValue:
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.setApart.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 0,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                         showLeaders: $showLeaders,
                                                         color: branding.nonDestructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt, nextActionTypeMessage: "",
                                                         itemIndex: 0,
                                                         actionHandler: { index in
                                                
                                            })
                                            
                                        default:
                                            if orgMbrCalling.callingAction == ActionTypeSectionTitles.released.stringValue {
                                                ActionButton(branding: branding,
                                                             buttonTitle: CallingActionTypeButtonTitles.released.stringValue,
                                                             topPadding: 0,
                                                             bottomPadding: 0,
                                                             leadingPadding: 0,
                                                             trailingPadding: 0,
                                                             bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                             showLeaders: $showLeaders,
                                                             color: branding.nonDestructiveButton,
                                                             font: branding.pageAndModalTitle_Semibold_17pt, nextActionTypeMessage: "",
                                                             itemIndex: 0,
                                                             actionHandler: { index in
                                                    
                                                })
                                            }
                                        }
                                    }
                                }
                                .frame(height: 60)
                                .padding(.leading, 80)
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .padding(.top, 0)
                    .sheet(isPresented: $showLeaders) {
                        if !bishopBranchStakePresidentOnly {
                            LeaderBottomSheetView(selectedLeader: $selectedLeader,
                                                  leaders: orgMbrCallingViewModel.leaders,
                                                  member: orgMbrCallingViewModel.currentActionTypeModel.memberName,
                                                  nextActionTypeMessage:                                             orgMbrCallingViewModel.nextActionTypeMessage,
                                                  selectLeaderAction: { selectedLeader in
                                self.selectedLeader = selectedLeader ?? ""
                                
                                orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                            })
                            .presentationDetents([.medium, .large])
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .cornerRadius(25)
                    .environment(\.colorScheme, .light)
                }
                .cornerRadius(25)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(branding.nonDestructiveButton)
            .cornerRadius(25)
            .padding(.top, 60)
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .frame(maxWidth: .infinity)
            .frame(height: 600)
            .listStyle(PlainListStyle())
            .onAppear() {
                OrganizationsViewModel.shared.shouldShowAddItemButton = false
                MembersViewController.membersListLoadedFromMembersViewController = false
                membersViewModel.shouldShowAddItemButton = false
                membersViewModel.shouldShowCloseButon = true
                sectionHeading = selectedOrganization.name
                
                orgMbrCallingViewModel.fetchData {
                    orgMbrCallingViewModel.callingActionsInSelectedOrganization = callingsFor(organization: selectedOrganization)
                    
                    orgMbrCallingViewModel.callingActionsInSelectedOrganization = orgMbrCallingViewModel.callingActionsInSelectedOrganization.sorted { Double($0.callingDisplayIndex) ?? 0.0 < Double($1.callingDisplayIndex) ?? 0.0 }
                }
            }
            .onDisappear {
                OrganizationsViewModel.shared.shouldShowAddItemButton = true
            }
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
            case .phone:
                primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
            default:
                break
            }
        }
    }
    
    func callingsFor(organization: Organization) -> [OrgMbrCalling] {
        var orgMbrKallings = [OrgMbrCalling]()
        
        for orgMbrCallings in orgMbrCallingViewModel.orgMbrCallings {
            if orgMbrCallings.organizationName == organization.name {
                orgMbrKallings.append(orgMbrCallings)
            }
        }
        
        return orgMbrKallings
    }
}

