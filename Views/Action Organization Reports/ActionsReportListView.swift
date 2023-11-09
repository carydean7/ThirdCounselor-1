//
//  ActionsReportListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 4/28/23.
//

import SwiftUI

struct ActionsReportListView: View {
    @StateObject var orgMbrCallingViewModel: OrgMbrCallingViewModel = OrgMbrCallingViewModel.shared
    
    @Environment(\.branding) var branding
    
    @ObservedObject var organizationsViewModel: OrganizationsViewModel
    @ObservedObject var membersViewModel: MembersViewModel
    
    @State private var showCloseButton = true
    @State private var navigationTitle = ""
    @State private var approvedRecommendation = "Approved"
    @State private var approvedCallsToExtend = "Called"
    @State private var sustained = "Sustained"
    @State private var setApart = "Set Apart"
    @State private var releaseExtended = "Released"
    @State private var showLeaders = false
    @State private var showingAlert = false
    @State private var bishopBranchStakePresidentOnly = false
    @State private var selectedLeader = ""
    @State private var nextActionTypeMessage = ""
    @State private var actionType: ActionTypes = .recommendationsForApproval
    @State private var showAddItemButton = false
    @State private var primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt
    @State private var secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var recommendedIsExpanded = false
    @State private var approvedCallsToExtendIsExpanded = false
    @State private var releasesIsExpanded = false
    @State private var toBeSustainedIsExpanded = false
    @State private var settingApartsIsExpanded = false
    
    let disclosureGroupHeadings = ["Organization", "Calling", "Member Serving"]
    
    public init(navigationTitle: String = "",
                approvedRecommendation: String = "Approved",
                approvedCallsToExtend: String = "Called",
                sustained: String = "Sustained",
                setApart: String = "Set Apart",
                releaseExtended: String = "Released",
                selectedLeader: String = "",
                showLeaders: Bool = false,
                showingAlert: Bool = false,
//                showConfirmDeleteOrganization: Bool = false,
                bishopBranchStakePresidentOnly: Bool = false,
                organizationsViewModel: OrganizationsViewModel = OrganizationsViewModel.shared,
                showCloseButton: Bool = true,
                showAddItemButton: Bool = false,
                nextActionTypeMessage: String = "",
                actionType: ActionTypes = .recommendationsForApproval,
                membersViewModel: MembersViewModel,
                orgMbrCallingViewModel: OrgMbrCallingViewModel) {
        self.membersViewModel = membersViewModel
        self.organizationsViewModel = organizationsViewModel
        self.showCloseButton = showCloseButton
        self.showAddItemButton = showAddItemButton
        self.navigationTitle = navigationTitle
        self.approvedRecommendation = approvedRecommendation
        self.approvedCallsToExtend = approvedCallsToExtend
        self.sustained = sustained
        self.setApart = setApart
        self.releaseExtended = releaseExtended
        self.selectedLeader = selectedLeader
        self.showLeaders = showLeaders
        self.showingAlert = showingAlert
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.bishopBranchStakePresidentOnly = bishopBranchStakePresidentOnly
        self.nextActionTypeMessage = nextActionTypeMessage
        self.actionType = actionType
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.callingActions.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: membersViewModel,
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })
            
            NavigationView {
                List {
                    DisclosureGroup(
                        content: {
                            
                        },
                        label: {
                            Text("").frame(maxWidth: .infinity, minHeight: 40).padding(.leading, -40)
                        })
                    .accentColor(.clear)
                    .background(branding.nonDestructiveButton)
                    .frame(maxWidth: .infinity, minHeight: 20)
                    .padding([.leading, .trailing, .top, .bottom], -40)
                    .listRowSeparatorTint(.clear)
                    
                    DisclosureGroup(isExpanded: $recommendedIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: disclosureGroupHeadings)
                        
                        ForEach(orgMbrCallingViewModel.recommendationsForApproval, id: \.self) { recommendedCallingChange in
                            ListContentRow(contents: [recommendedCallingChange.organizationName,                                recommendedCallingChange.callingName,                                       recommendedCallingChange.memberName],
                                           bottomPadding: 5,
                                           topPadding: 0,
                                           leadingPadding: 20,
                                           trailingPadding: 20,
                                           rowContentIsRecommendations: true,
                                           alignRowsInHStack: .constant(true))
                            .listRowSeparator(.hidden)
                            
                            List(recommendedCallingChange.recommendations, id: \.self) { recommendation in
                                HStack(spacing: 20) {
                                    Text(recommendation.member)
                                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                    font: secondaryFont,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: .infinity,
                                                    alignment: .leading)
                                        .frame(height: 20)
                                    
                                    ActionButton(branding: branding,
                                                 buttonTitle: CallingActionTypeButtonTitles.approved.stringValue,
                                                 topPadding: 0,
                                                 bottomPadding: 0,
                                                 leadingPadding: 0,
                                                 trailingPadding: 0,
                                                bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                 showLeaders: $showLeaders,
                                                 color: branding.nonDestructiveButton,
                                                 font: branding.pageAndModalTitle_Semibold_17pt,
                                                 nextActionTypeMessage: "to extend call to ",
                                                 itemIndex: recommendation.selectionIndex,
                                                 actionHandler: { index in
                                        orgMbrCallingViewModel.nextActionTypeMessage = "to extend call to "
                                            handleButtonAction(for: CallingActionTypeButtonTitles.approved.stringValue, model: orgMbrCallingViewModel.findOrgMbrCalling(for: recommendedCallingChange) ?? OrgMbrCalling(callingAction: String(ActionTypes.recommendationApproved.rawValue)),
                                                               selectedMember: recommendedCallingChange.recommendations[index].member
                                                )
                                    })

                                    if recommendedCallingChange.recommendations.count == 1 {
                                        ActionButton(branding: branding,
                                                     buttonTitle: CallingActionTypeButtonTitles.notApproved.stringValue,
                                                     topPadding: 0,
                                                     bottomPadding: 0,
                                                     leadingPadding: 0,
                                                     trailingPadding: 0,
                                                     bishopBranchStakePresidentOnly: $bishopBranchStakePresidentOnly,
                                                     showLeaders: $showLeaders,
                                                     color: branding.destructiveButton,
                                                     font: branding.pageAndModalTitle_Semibold_17pt,
                                                     nextActionTypeMessage: "",
                                                     itemIndex: recommendation.selectionIndex,
                                                     actionHandler: { index in
                                            
                                        })
                                    }
                                }
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                                .padding([.leading, .trailing], 40)
                            }
                            .frame(height: 200)
                        }
                    },label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle:  ActionTypeSectionTitles.recommended.stringValue,
                                                             showExpansionChevrons: true,
                                                             isExpanded: $recommendedIsExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $approvedCallsToExtendIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: disclosureGroupHeadings)
                        ForEach(orgMbrCallingViewModel.callsToBeExtended, id: \.self) { call in
                            ListContentRow(contents: [call.organizationName, call.callingName, call.memberName],
                                           bottomPadding: 5,
                                           topPadding: 0,
                                           leadingPadding: 20,
                                           trailingPadding: 20,
                                           rowContentIsRecommendations: false,
                                           alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    actionType = .callDeclined
                                    showingAlert = false
                                    orgMbrCallingViewModel.currentActionTypeModel = call
                                    
                                    // remove member from callsToBeExtended and replace
                                    // the calling member with the member who previously was in the calling.
                                    
                                } label: {
                                    Text(CallingActionTypeButtonTitles.declined.stringValue)
                                        .customText(color: branding.destructiveButton,
                                                    font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: 0,
                                                    alignment: .leading)
                                }
                                .tint(branding.destructiveButton)
                                .accentColor(branding.destructiveButton)
                                .frame(height: 30)
                                
                                Button {
                                    actionType = .callAccepted
                                    orgMbrCallingViewModel.currentActionTypeModel = call
                                    orgMbrCallingViewModel.getLeadership(selectedModel: orgMbrCallingViewModel.currentActionTypeModel) { leaders in
                                        if leaders.count == 1 {
                                            // Bishop / Branch President or Stake President Only
                                            bishopBranchStakePresidentOnly = true
                                        } else {
                                            orgMbrCallingViewModel.leaders = leaders
                                            orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                                        }
                                    }
                                } label: {
                                    Text(CallingActionTypeButtonTitles.accepted.stringValue)
                                        .customText(color: branding.nonDestructiveButton,
                                                    font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: 0,
                                                    alignment: .leading)
                                }
                                .tint(branding.nonDestructiveButton)
                                .accentColor(branding.nonDestructiveButton)
                                .frame(height: 30)
                            }
                        }
                    }, label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle:  ActionTypeSectionTitles.called.stringValue,
                                                             showExpansionChevrons: true,
                                                             isExpanded: $approvedCallsToExtendIsExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $releasesIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: disclosureGroupHeadings)
                        ForEach(orgMbrCallingViewModel.membersNeedingToBeReleased, id: \.self) { releases in
                            ListContentRow(contents: [releases.organizationName, releases.callingName, releases.memberToBeReleased],                                                               bottomPadding: 5,
                                           topPadding: 0,
                                           leadingPadding: 20,
                                           trailingPadding: 20,
                                           rowContentIsRecommendations: false,
                                           alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    actionType = .released
                                    orgMbrCallingViewModel.currentActionTypeModel = releases
                                    
                                    orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                                } label: {
                                    Text(CallingActionTypeButtonTitles.released.stringValue)
                                        .customText(color: branding.destructiveButton,
                                                    font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: 0,
                                                    alignment: .leading)
                                }
                                .tint(branding.destructiveButton)
                            }
                        }
                        
                    }, label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle:  ActionTypeSectionTitles.released.stringValue,
                                                             showExpansionChevrons: true,
                                                             isExpanded: $releasesIsExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $toBeSustainedIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: disclosureGroupHeadings)
                        ForEach(orgMbrCallingViewModel.toBeSustained, id: \.self) { sustaining in
                            ListContentRow(contents: [sustaining.organizationName, sustaining.callingName, sustaining.memberName],
                                           bottomPadding: 5,
                                           topPadding: 0,
                                           leadingPadding: 20,
                                           trailingPadding: 20,
                                           rowContentIsRecommendations: false,
                                           alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    actionType = .sustained
                                    orgMbrCallingViewModel.currentActionTypeModel = sustaining
                                    
                                    orgMbrCallingViewModel.nextActionTypeMessage = "to set apart:\n"
                                    
                                    orgMbrCallingViewModel.getLeadership(selectedModel: orgMbrCallingViewModel.currentActionTypeModel) { leaders in
                                        if leaders.count == 1 {
                                            // Bishop / Branch President or Stake President Only
                                            bishopBranchStakePresidentOnly = true
                                            
                                            self.selectedLeader = leaders.first ?? ""
                                            
                                            orgMbrCallingViewModel.currentActionTypeModel.ldrAssignToSetApart = self.selectedLeader
                                            
                                            orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                                        } else {
                                            orgMbrCallingViewModel.leaders = leaders
                                            showLeaders = true
                                        }
                                    }
                                } label: {
                                    Text(CallingActionTypeButtonTitles.sustained.stringValue)
                                        .customText(color: branding.nonDestructiveButton,
                                                    font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: 0,
                                                    alignment: .leading)
                                }
                                .tint(branding.nonDestructiveButton)
                            }
                        }
                        
                    }, label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle:  ActionTypeSectionTitles.sustained.stringValue,
                                                             showExpansionChevrons: true,
                                                             isExpanded: $toBeSustainedIsExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $settingApartsIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: disclosureGroupHeadings)
                        ForEach(orgMbrCallingViewModel.settingAparts, id: \.self) { settingAparts in
                            ListContentRow(contents: [settingAparts.organizationName, settingAparts.callingName, settingAparts.memberName],
                                           bottomPadding: 5,
                                           topPadding: 0,
                                           leadingPadding: 20,
                                           trailingPadding: 20,
                                           rowContentIsRecommendations: false,
                                           alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    actionType = .setApart
                                    orgMbrCallingViewModel.currentActionTypeModel = settingAparts
                                    
                                    orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                                } label: {
                                    Text(CallingActionTypeButtonTitles.setApart.stringValue)
                                        .customText(color: branding.nonDestructiveButton,
                                                    font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: 0,
                                                    alignment: .leading)
                                }
                                .tint(branding.nonDestructiveButton)
                            }
                        }
                        
                    }, label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle:  ActionTypeSectionTitles.setApart.stringValue,
                                                             showExpansionChevrons: true,
                                                             isExpanded: $settingApartsIsExpanded)
                    })
                }
                .sheet(isPresented: $showLeaders) {
                    if !bishopBranchStakePresidentOnly {
                        LeaderBottomSheetView(selectedLeader: $selectedLeader,
                                              leaders: orgMbrCallingViewModel.leaders,
                                              member: orgMbrCallingViewModel.currentActionTypeModel.memberName,
                                              nextActionTypeMessage:                                             actionType == .recommendationsForApproval ? "to extend call to" : "to set apart ",
                                              selectLeaderAction: { selectedLeader in
                            self.selectedLeader = selectedLeader ?? ""
                            
                            orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                        })
                        .environment(\.colorScheme, .light)
                        .preferredColorScheme(.light)
                        .presentationDetents([.medium, .large])
                    }
                }
                .environment(\.colorScheme, .light)
                .preferredColorScheme(.light)
                .listStyle(SidebarListStyle())
                .onAppear {
                    navigationTitle = "Actions"
                }
                .padding(.top, 10)
                .navigationBarTitleDisplayMode(.automatic)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                switch (Constants.deviceIdiom) {
                case .pad:
                    primaryFont = branding.primaryListRow_iPad_Title_34pt
                    secondaryFont = branding.secondaryListRow_iPad_Title2_28pt
                case .phone:
                    primaryFont = branding.primaryListRow_Body_23pt
                    secondaryFont = branding.secondaryListRow_Callout_22pt
                default:
                    break
                }
                                
                orgMbrCallingViewModel.fetchData {
                    orgMbrCallingViewModel.getOrgMbrCallingActions(forMe: false,
                                                                   leader: "",
                                                                   byOrganization: false,
                                                                   organization: "") { results in
                    }
                }
            }
            .cornerRadius(25.0)
            .padding([.leading, .trailing], 10)
        }
        .environmentObject(orgMbrCallingViewModel)
        .cornerRadius(25.0)
    }
    
    @MainActor func handleButtonAction(for title: String, model: OrgMbrCalling, selectedMember: String) {
        var omc = OrgMbrCalling(id: model.uid,
                                uid: model.uid,
                                callingName: model.callingName,
                                organizationName: model.organizationName,
                                memberName: selectedMember,
                                memberToBeReleased: model.memberName,
                                approvedDate: model.approvedDate,
                                calledDate: model.calledDate,
                                sustainedDate: model.sustainedDate,
                                setApartDate: model.setApartDate,
                                releasedDate: model.releasedDate,
                                recommendedDate: model.releasedDate,
                                ldrAssignToCall: model.ldrAssignToCall,
                                ldrAssignToSetApart: model.ldrAssignToSetApart,
                                callingPreviouslyFilledDate: model.callingPreviouslyFilledDate,
                                callingDisplayIndex: model.callingDisplayIndex,
                                callingAction: model.callingAction,
                                recommendations: "")
                
        OrgMbrCallingViewModel.shared.getLeadership(selectedModel: model) { leaders in
            if leaders.count == 1 {
                bishopBranchStakePresidentOnly = true
            } else {
                OrgMbrCallingViewModel.shared.leaders = leaders
                showLeaders = true
            }
            
            omc.ldrAssignToCall = selectedLeader
            omc.callingAction = String(ActionTypes.recommendationApproved.rawValue)
            
            OrgMbrCallingViewModel.shared.currentActionTypeModel = omc
            OrgMbrCallingViewModel.shared.nextActionTypeMessage = nextActionTypeMessage //"to extend call to:"
            
            OrgMbrCallingViewModel.shared.updateCallingAction(actionType: getActionType(for: title), orgMbrCalling: model)
            
            if !selectedLeader.isEmpty {
                OrgMbrCallingViewModel.shared.resetRecommendedChanges(for: model)
            }
        }
    }
    
    func getActionType(for buttonTitle: String) -> ActionTypes {
        switch buttonTitle {
        case CallingActionTypeButtonTitles.approved.stringValue:
            return .recommendationApproved
        case CallingActionTypeButtonTitles.notApproved.stringValue:
            return .recommendationNotApproved
        case CallingActionTypeButtonTitles.accepted.stringValue:
            return .callAccepted
        case CallingActionTypeButtonTitles.declined.stringValue:
            return .callDeclined
        case CallingActionTypeButtonTitles.sustained.stringValue:
            return .sustained
        case CallingActionTypeButtonTitles.setApart.stringValue:
            return .setApart
        case CallingActionTypeButtonTitles.released.stringValue:
            return .released
        default:
            return .noFurtherActionRequired
        }
    }
}

struct ContentHeaderView: View {
    @Environment(\.branding) var branding
    
    var hstackSpacing: CGFloat
    var headingTitles = [String]()
    
    var body: some View {
        HStack(spacing: hstackSpacing) {
            ForEach(headingTitles, id:\.self) { heading in
                Text(heading)
                    .customText(color: branding.labels,
                                font: branding.paragraphTextAndLinks_Semibold_17pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 0,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .leading)
                    .underline()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct LeaderBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @State private var selection: String = ""
    @State private var primaryFont: Font = Branding.mock.primaryListRow_Body_23pt
    @State private var secondaryFont: Font = Branding.mock.secondaryListRow_Callout_22pt
    
    @Binding var selectedLeader: String
    
    var selectLeaderAction: ((_ name: String?) -> Void)
    var leaders = [String]()
    var member = ""
    var nextActionTypeMessage = ""
    
    init(selectedLeader: Binding<String>,
         selection: String = "",
         leaders: [String] = [String](),
         member: String = "",
         nextActionTypeMessage: String = "",
         selectLeaderAction: @escaping ((_ name: String?) -> Void)) {
        _selectedLeader = selectedLeader
        self.leaders = leaders
        self.member = member
        self.selectLeaderAction = selectLeaderAction
        self.selection = selection
        self.nextActionTypeMessage = nextActionTypeMessage
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.selectLeader.rawValue,
                           showCloseButton: .constant(true),
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: MembersViewModel.shared,
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })
            
            Text("Choose the leader \(nextActionTypeMessage) \(member)")
                .customText(color: branding.labels,
                            font: primaryFont,
                            btmPad: 0,
                            topPad: 20,
                            leadPad: 20,
                            trailPad: 20,
                            width: .infinity,
                            alignment: .center)
                .lineLimit(2)
            
            List(leaders, id: \.self) { ldr in
                Button {
                    selection = ldr
                    selectedLeader = selection
                    selectLeaderAction(selectedLeader)
                    dismiss()
                    
                } label: {
                    Text(ldr)
                        .customText(color: branding.contentTextColor,
                                    font: secondaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .leading)
                }
            }
            
            Text("\(selection)")
                .customText(color: branding.contentTextColor,
                            font: secondaryFont,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                primaryFont = branding.primaryListRow_iPad_Title_34pt
                secondaryFont = branding.secondaryListRow_iPad_Title2_28pt
            case .phone:
                primaryFont = branding.primaryListRow_Body_23pt
                secondaryFont = branding.secondaryListRow_Callout_22pt
            default:
                break
            }
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition == true {
            transform(self)
        } else {
            self
        }
    }
}

