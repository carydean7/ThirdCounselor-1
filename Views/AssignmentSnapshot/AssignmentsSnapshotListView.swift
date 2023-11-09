//
//  AssignmentsSnapshotListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 4/28/23.
//

import SwiftUI

struct AssignmentsSnapshotListView: View {
    @StateObject var orgMbrCallingViewModel: OrgMbrCallingViewModel = OrgMbrCallingViewModel.shared
    
    @Environment(\.branding) var branding
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var organizationsViewModel: OrganizationsViewModel
    @ObservedObject var notesViewModel: NotesViewModel
    @ObservedObject var assignmentsViewModel: AssignmentsViewModel
    @ObservedObject var ordinationsViewModel: OrdinationsViewModel
    @ObservedObject var interviewsViewModel: InterviewsViewModel
    
    @State private var navigationTitle = ""
    @State private var notes = ""
    @State private var showNotes = false
    @State private var showCloseButton = true
    @State private var showAddItemButton = false
    @State private var primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt
    @State private var secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt
    @State private var noteButtonSize: CGFloat = 20
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var approvedCallsToExtendIsExpanded = false
    @State private var releasesIsExpanded = false
    @State private var settingApartsIsExpanded = false
    @State private var interviewsIsExpanded = false
    @State private var isExpanded = false
    @State private var callingsToUpdateOnWebIsExpanded = false

    let disclosureGroupHeadings = ["Organization", "     Calling", "Member"]
    let forWebDisclosureGroupHeadings = ["Organization", "     Calling", "Member", "Date"]

    let defaults = UserDefaults.standard
    var leader = UserDefaults.standard.string(forKey: UserDefaultKeys.leaderPosition.stringValue) ?? ""
    
    init(noteButtonSize: CGFloat = 20,
         primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt,
         secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt,
         navigationTitle: String = "",
         organizationsViewModel: OrganizationsViewModel = OrganizationsViewModel.shared,
         notesViewModel: NotesViewModel = NotesViewModel.shared,
         assignmentsViewModel: AssignmentsViewModel = AssignmentsViewModel.shared,
         ordinationsViewModel: OrdinationsViewModel = OrdinationsViewModel.shared,
         interviewsViewModel: InterviewsViewModel = InterviewsViewModel.shared,
         notes: String = "",
         showCloseButton: Bool = true,
//         showConfirmDeleteOrganization: Bool = false,
         showAddItemButton: Bool = false,
         membersViewModel: MembersViewModel) {
        self.membersViewModel = membersViewModel
        self.organizationsViewModel = organizationsViewModel
        self.notesViewModel = notesViewModel
        self.assignmentsViewModel = assignmentsViewModel
        self.ordinationsViewModel = ordinationsViewModel
        self.interviewsViewModel = interviewsViewModel
        self.navigationTitle = navigationTitle
        self.notes = notes
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showAddItemButton = showAddItemButton
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.noteButtonSize = noteButtonSize
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.assignments.rawValue,
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
                                .foregroundColor(branding.destructiveButton)
                        })
                    .accentColor(.clear)
                    .background(branding.nonDestructiveButton)
                    .frame(maxWidth: .infinity, minHeight: 20)
                    .padding([.leading, .trailing, .top, .bottom], -40)
                    .listRowSeparatorTint(.clear)
                    
                    DisclosureGroup(isExpanded: $isExpanded,
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
                                        orgMbrCallingViewModel.updateCallingAction(actionType: .released, orgMbrCalling: call)
                                    } label: {
                                        Text("Declined Call")
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

                                    Button {
                                        orgMbrCallingViewModel.updateCallingAction(actionType: .callAccepted, orgMbrCalling: call)
                                    } label: {
                                        Text("Accepted Call")
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
                    },
                                    label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle: ActionTypeSectionTitles.called.stringValue,
                            showExpansionChevrons: true,
                            isExpanded: $isExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $releasesIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: disclosureGroupHeadings)
                        
                        ForEach(orgMbrCallingViewModel.membersNeedingToBeReleased, id: \.self) { releases in
                            ListContentRow(contents: [releases.organizationName, releases.callingName, releases.memberName],
                                           bottomPadding: 5,
                                           topPadding: 0,
                                           leadingPadding: 20,
                                           trailingPadding: 20,
                                           rowContentIsRecommendations: false,
                                           alignRowsInHStack: .constant(true))
                                .listRowSeparatorTint(.clear)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        orgMbrCallingViewModel.updateCallingAction(actionType: .released, orgMbrCalling: releases)
                                    } label: {
                                        Text("Released")
                                            .customText(color: branding.nonDestructiveButton,
                                                        font: branding.paragraphTextAndLinks_Semibold_17pt,
                                                        btmPad: 0,
                                                        topPad: 0,
                                                        leadPad: 60,
                                                        trailPad: 0,
                                                        width: .infinity,
                                                        alignment: .leading)
                                    }
                                }
                        }
                    },
                                    label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle: ActionTypeSectionTitles.released.stringValue,
                            showExpansionChevrons: true,
                            isExpanded: $releasesIsExpanded)
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
                                        orgMbrCallingViewModel.updateCallingAction(actionType: .setApart, orgMbrCalling: settingAparts)
                                    } label: {
                                        Text("Set Apart")
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
                    },
                                    label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle: ActionTypeSectionTitles.setApart.stringValue,
                            showExpansionChevrons: true,
                            isExpanded: $settingApartsIsExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $interviewsIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: interviewsViewModel.disclosureGroupColumnHeadings)
                        
                        ForEach(Array(interviewsViewModel.interviews.enumerated()), id: \.offset) { (index, interview) in
                            InterviewRow(model: interview)
                                .listRowSeparatorTint(.clear)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button {
                                        interviewsViewModel.updateInterview(interview: interview) {
                                            interviewsViewModel.fetchData {
                                                
                                            }
                                        }
                                    } label: {
                                        Text("Interviewed")
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
                    },
                                    label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle: ActionTypeSectionTitles.interviews.stringValue,
                            showExpansionChevrons: true,
                            isExpanded: $interviewsIsExpanded)
                    })
                    
                    DisclosureGroup(isExpanded: $callingsToUpdateOnWebIsExpanded,
                                    content: {
                        ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: forWebDisclosureGroupHeadings)
                        
                        ForEach(Array(orgMbrCallingViewModel.orgMbrCallings.enumerated()), id: \.offset) { (index, call) in
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
                                        let omc = OrgMbrCalling(uid: call.uid,
                                                                callingName: call.callingName,
                                                                organizationName: call.organizationName,
                                                                memberName: call.memberName,
                                                                memberToBeReleased: call.memberToBeReleased,
                                                                approvedDate: call.approvedDate,
                                                                calledDate: call.calledDate,
                                                                sustainedDate: call.sustainedDate,
                                                                setApartDate: call.setApartDate,
                                                                releasedDate: call.releasedDate,
                                                                recommendedDate: call.recommendedDate,
                                                                ldrAssignToCall: call.ldrAssignToCall,
                                                                ldrAssignToSetApart: call.ldrAssignToSetApart,
                                                                callingPreviouslyFilledDate: call.callingPreviouslyFilledDate,
                                                                callingDisplayIndex: call.callingDisplayIndex,
                                                                callingAction: String(ActionTypes.callingUpdatedOnWeb.rawValue),
                                                                recommendations: "")
                                        orgMbrCallingViewModel.updateCurrentOrgMbrCalling(model: omc, completion: {
                                            orgMbrCallingViewModel.fetchData {
                                                
                                            }
                                        })
                                    } label: {
                                        Text("Calling Update for Web")
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
                    },
                    label: {
                        DisclosureGroupLabelWithChevronsView(sectionTitle: ActionTypeSectionTitles.callingsToUpdateOnWeb.stringValue,
                            showExpansionChevrons: true,
                            isExpanded: $callingsToUpdateOnWebIsExpanded)
                    })
                    
                    Button {
                        showNotes = true
                    } label: {
                        Label("Notes", systemImage: "note.text.badge.plus")
                            .font(primaryFont)
                            .frame(height: noteButtonSize)
                            .foregroundColor(branding.destructiveButton)
                    }
                    .font(primaryFont)
                    .padding([.leading, .trailing], 20)
                    .sheet(isPresented: $showNotes, content: {
                        NotesView(notesViewModel: notesViewModel,
                                  leader: leader,
                                  membersViewModel: membersViewModel)
                        .presentationDetents([.medium])
                    })
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 10)
                .listStyle(SidebarListStyle())
                .navigationBarTitleDisplayMode(.automatic)
                .navigationTitle($navigationTitle)
                .font(primaryFont)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                orgMbrCallingViewModel.fetchData {
                    orgMbrCallingViewModel.getOrgMbrCallingActions(forMe: true,
                                                                   leader: leader,
                                                                   byOrganization: false,
                                                                   organization: "") { results in
                    }
                }
            }
            .cornerRadius(25.0)
            .padding([.leading, .trailing], 10)
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
                noteButtonSize = 20
            case .phone:
                primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
            default:
                break
            }
            
            notesViewModel.fetchData(for: leader) {
                
            }
        }
        .environmentObject(orgMbrCallingViewModel)
        .cornerRadius(25.0)
    }
}
