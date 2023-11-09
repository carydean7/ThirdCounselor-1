//
//  CallingsAndMbrsInOrgListView.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 3/14/23.
//

import SwiftUI

struct CallingsAndMbrsInOrgListView: View {
    @Environment(\.branding) var branding
    
    @EnvironmentObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    @EnvironmentObject var membersViewModel: MembersViewModel
    
    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel
    
    @State private var primaryFont: Font
    @State private var secondaryFont: Font
    @State private var listHeaderTopPadding: CGFloat = 140.0
    @State private var listHeaderHeight: CGFloat = 40.0
    @State private var navigationViewTopPadding: CGFloat = 95.0
    @State private var showMembersList = false
    @State private var selectedCalling: String = ""
    @State private var newlyAssignedMember: String = ""
    @State private var isSheet: Bool = false
    @State private var sectionHeading = ""
    @State private var showLeaders = false
    @State private var isExpanded = false
    @State private var recommendations: [String] = [String]()
    @State private var selectedLeader = ""
    @State private var actionType: ActionTypes = .recommendationApproved
    @State private var bishopBranchStakePresidentOnly = false
    @State private var callingsWithMembersInSelectedOrganization = Array(arrayLiteral: OrgMbrCalling())
    @State private var actionPending = false
    
    var selectedOrganization: Organization
    
    public init(primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt,
                secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt,
                callingsWithMembersInSelectedOrganization: [OrgMbrCalling]? = nil,
                showMembersList: Bool = false,
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
        self.speakingAssignmentsViewModel = speakingAssignmentsViewModel
        self.callingsWithMembersInSelectedOrganization = callingsWithMembersInSelectedOrganization ?? [OrgMbrCalling]()
        self.showMembersList = showMembersList
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
                    Text(ListHeadingTitles.callings.rawValue)
                        .customText(color: branding.labels,
                                    font: branding.screenTitle_Title_34pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 60,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                        .frame(height: 20)
                    
                    Text(selectedOrganization.name)
                        .customText(color: branding.labels,
                                    font: branding.secondaryListRow_iPad_Title2_28pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 60,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                        .frame(height: 20)
                    
                    Divider()
                    
                    List {
                        if orgMbrCallingViewModel.callingActionsInSelectedOrganization.count > 0 {
                            ForEach(orgMbrCallingViewModel.callingActionsInSelectedOrganization, id: \.self) {
                                orgMbrCalling in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(orgMbrCalling.callingName)
                                            .if(orgMbrCalling.callingAction) { view in
                                                view.italic()
                                            }
                                            .customText(color: branding.labels, font: primaryFont,
                                                        btmPad: -5,
                                                        topPad: 0,
                                                        leadPad: 20,
                                                        trailPad: 0,
                                                        width: UIScreen.main.bounds.width * 0.80,
                                                        alignment: .leading)
                                        
                                        Text(orgMbrCalling.memberName)
                                            .if(orgMbrCalling.callingAction) { view in
                                                view.italic()
                                            }
                                            .customText(color: branding.contentTextColor,
                                                        font: secondaryFont,
                                                        btmPad: 5,
                                                        topPad: 0,
                                                        leadPad: 20,
                                                        trailPad: 0,
                                                        width: UIScreen.main.bounds.width * 0.80,
                                                        alignment: .leading)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .swipeActions(allowsFullSwipe: true) {
                                    Button("Recommended Change") {
                                        actionType = .recommendationsForApproval
                                        orgMbrCallingViewModel.selectedOrgMbrCalling = orgMbrCalling
                                        selectedCalling = orgMbrCalling.callingName
                                        orgMbrCallingViewModel.selectedOrgMbrCallingUid = orgMbrCalling.uid
                                        membersViewModel.isSheet = true
                                        showMembersList.toggle()
                                    }
                                    .tint(branding.nonDestructiveButton)
                                    .font(secondaryFont)
                                }
                            }
                        } else {
                            ForEach($callingsWithMembersInSelectedOrganization, id: \.self) {
                                orgMbrCalling in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(orgMbrCalling.callingName.wrappedValue)
                                            .if(orgMbrCalling.callingAction.wrappedValue) { view in
                                                view.italic()
                                            }
                                            .customText(color: branding.labels, font: primaryFont,
                                                        btmPad: -5,
                                                        topPad: 0,
                                                        leadPad: 20,
                                                        trailPad: 0,
                                                        width: UIScreen.main.bounds.width * 0.80,
                                                        alignment: .leading)
                                        
                                        Text(orgMbrCalling.memberName.wrappedValue)
                                            .if(orgMbrCalling.callingAction.wrappedValue) { view in
                                                view.italic()
                                            }
                                            .customText(color: branding.contentTextColor,
                                                        font: secondaryFont,
                                                        btmPad: 5,
                                                        topPad: 0,
                                                        leadPad: 20,
                                                        trailPad: 0,
                                                        width: UIScreen.main.bounds.width * 0.80,
                                                        alignment: .leading)
                                        
                                        if !recommendationsAreEmpty(recommendations: DataManager.shared.convertRecommendationsStringToArrayOfRecommendations(recommendationsString: orgMbrCalling.recommendations.wrappedValue)) {
                                            OrgMbrCallingListGroup(sectionTitle: "Recommendations", recommendations: orgMbrCallingViewModel.recommendations)
                                                .padding(.leading, 80)
                                        }
                                    }
                                }
                                .swipeActions(allowsFullSwipe: true) {
                                    Button("Recommended Change") {
                                        actionType = .recommendationsForApproval
                                        orgMbrCallingViewModel.selectedOrgMbrCalling = orgMbrCalling.wrappedValue
                                        selectedCalling = orgMbrCalling.callingName.wrappedValue
                                        orgMbrCallingViewModel.selectedOrgMbrCallingUid = orgMbrCalling.uid.wrappedValue
                                        membersViewModel.isSheet = true
                                        showMembersList.toggle()
                                    }
                                    .tint(branding.nonDestructiveButton)
                                    .font(secondaryFont)
                                }
                            }
                        }
                    }
                    .padding(.top, 0)
                    .sheet(isPresented: $showLeaders) {
                        if !bishopBranchStakePresidentOnly {
                            LeaderBottomSheetView(selectedLeader: $selectedLeader,
                                                  leaders: orgMbrCallingViewModel.leaders,
                                                  member: $orgMbrCallingViewModel.currentActionTypeModel.memberName.wrappedValue,
                                                  nextActionTypeMessage: orgMbrCallingViewModel.nextActionTypeMessage,
                                                  selectLeaderAction: { selectedLeader in
                                self.selectedLeader = selectedLeader ?? ""
                                
                                orgMbrCallingViewModel.updateCallingAction(actionType: actionType, orgMbrCalling: orgMbrCallingViewModel.currentActionTypeModel)
                            })
                            .presentationDetents([.medium, .large])
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .sheet(isPresented: $showMembersList, onDismiss: {
                        print("debugStr3")
                        isSheet = true
                    }, content: {
                        MultiSelectMembersListView(membersViewModel: membersViewModel, orgMbrCallingViewModel: orgMbrCallingViewModel, showMembersList: $showMembersList) { selection in
                            print("returning member(s) : \(selection)")
                            
                            var omc = OrgMbrCalling(uid: orgMbrCallingViewModel.selectedOrgMbrCallingUid,
                                                    callingName: orgMbrCallingViewModel.selectedOrgMbrCalling.callingName,
                                                    organizationName: orgMbrCallingViewModel.selectedOrgMbrCalling.organizationName,
                                                    memberName: orgMbrCallingViewModel.selectedOrgMbrCalling.memberName,
                                                    memberToBeReleased: orgMbrCallingViewModel.selectedOrgMbrCalling.memberName,
                                                    approvedDate: "",
                                                    calledDate: "",
                                                    sustainedDate: "",
                                                    setApartDate: "",
                                                    releasedDate: "",
                                                    recommendedDate: orgMbrCallingViewModel.selectedOrgMbrCalling.recommendedDate,
                                                    ldrAssignToCall: "",
                                                    ldrAssignToSetApart: "",
                                                    callingPreviouslyFilledDate: orgMbrCallingViewModel.selectedOrgMbrCalling.calledDate,
                                                    callingDisplayIndex: orgMbrCallingViewModel.selectedOrgMbrCalling.callingDisplayIndex,
                                                    callingAction: String(actionType.rawValue),
                                                    recommendations: DataManager.shared.convertArrayOfRecommendationsToDeliniatedString(recommendations: selection))
                            omc.id = omc.uid
                            orgMbrCallingViewModel.updateCurrentOrgMbrCalling(model: omc) {
                                orgMbrCallingViewModel.fetchData {
                                    callingsWithMembersInSelectedOrganization = [OrgMbrCalling]()
                                    if !callingsWithMembersInSelectedOrganization.isEmpty {
                                        callingsWithMembersInSelectedOrganization.removeAll()
                                        callingsWithMembersInSelectedOrganization = callingsFor(organization: selectedOrganization)
                                        
                                        orgMbrCallingViewModel.callingActionsInSelectedOrganization = callingsFor(organization: selectedOrganization)
                                        
                                    } else {
                                        callingsWithMembersInSelectedOrganization = callingsFor(organization: selectedOrganization)
                                        callingsWithMembersInSelectedOrganization = callingsWithMembersInSelectedOrganization.sorted { Double($0.callingDisplayIndex) ?? 0.0 < Double($1.callingDisplayIndex) ?? 0.0 }
                                        
                                        orgMbrCallingViewModel.callingActionsInSelectedOrganization = orgMbrCallingViewModel.callingActionsInSelectedOrganization.sorted { Double($0.callingDisplayIndex) ?? 0.0 < Double($1.callingDisplayIndex) ?? 0.0 }
                                    }
                                }
                            }
                        }
                    })
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
                    callingsWithMembersInSelectedOrganization = [OrgMbrCalling]()
                    if !callingsWithMembersInSelectedOrganization.isEmpty {
                        callingsWithMembersInSelectedOrganization.removeAll()
                        callingsWithMembersInSelectedOrganization = callingsFor(organization: selectedOrganization)
                        
                        orgMbrCallingViewModel.callingActionsInSelectedOrganization = callingsFor(organization: selectedOrganization)
                        
                    } else {
                        callingsWithMembersInSelectedOrganization = callingsFor(organization: selectedOrganization)
                        callingsWithMembersInSelectedOrganization = callingsWithMembersInSelectedOrganization.sorted { Double($0.callingDisplayIndex) ?? 0.0 < Double($1.callingDisplayIndex) ?? 0.0 }
                        
                        orgMbrCallingViewModel.callingActionsInSelectedOrganization = orgMbrCallingViewModel.callingActionsInSelectedOrganization.sorted { Double($0.callingDisplayIndex) ?? 0.0 < Double($1.callingDisplayIndex) ?? 0.0 }
                    }
                }
            }
            .onDisappear {
                print("debugStr4")
                membersViewModel.isSheet = false
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
    
    func recommendationsAreEmpty(recommendations: [Recommendation]) -> Bool {
        recommendations.isEmpty ? true : false
    }
    
    func callingsFor(organization: Organization) -> [OrgMbrCalling] {
        var orgMbrKallings = [OrgMbrCalling]()
        
        for orgMbrCallings in orgMbrCallingViewModel.orgMbrCallings {
            if orgMbrCallings.organizationName == "Relief Society" {
                print("")
            }
            if orgMbrCallings.organizationName == organization.name {
                orgMbrKallings.append(orgMbrCallings)
            }
        }
        
        return orgMbrKallings
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: String, transform: (Self) -> Content) -> some View {
        if condition == "No Further Action Required" {
            transform(self)
        } else {
            self
        }
    }
}

struct OrgMbrCallingListGroup: View {
    @Environment(\.branding) var branding
    
    @State private var isExpanded = false
    
    var recommendations: [Recommendation]

    var sectionTitle = ""
    
    init(sectionTitle: String = "",
         recommendations: [Recommendation]) {
        self.sectionTitle = sectionTitle
        self.recommendations = recommendations
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded,
                        content: {
            ForEach(recommendations, id: \.self) { recommendation in
                ListContentRow(contents: [recommendation.member],
                               bottomPadding: 5,
                               topPadding: 0,
                               leadingPadding: 20,
                               trailingPadding: 20,
                               rowContentIsRecommendations: false,
                               alignRowsInHStack: .constant(false))
                    .listRowSeparatorTint(.clear)
            }
        },
                        label: {
            Text(sectionTitle)
                .customText(color: branding.labels,
                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
                .italic()
        })
        .cornerRadius(25.0)
    }
    
    func recommendationsAreEmpty(recommendations: [String]) -> Bool {
        recommendations.isEmpty ? true : false
    }
}
