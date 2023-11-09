//
//  ListsView.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 2/24/23.
//

import SwiftUI

struct MembersListView: View {
    enum SubmitUpdateTypes: Int {
        case changeInCalling
        case memberAssignedToSpeak
    }
        
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel
    @ObservedObject var conductingSheetViewModel: ConductingSheetViewModel
    @ObservedObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    @ObservedObject var prayersViewModel: PrayersViewModel
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var showAddToViewModelView = false
    @State private var expandRow = false
    @State private var isSheet: Bool = false
    @State private var newlyAssignedMember = ""
    @State private var showCloseButton: Bool = false
    @State private var showAddItemButton = false
    @State private var memberAskedToSpeak = false
    @State private var changeInCalling = false
    @State private var font: Font = Branding.mock.primaryListRow_Body_23pt
    @State private var scrollTarget: String?
    @State private var memberName = ""
    @State private var showingAlert = false
    @State private var showEditMemberRows: Bool = false
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var showEditDoneButton: Bool = true
    @State private var multiSelection = Set<UUID>()
    @State private var allowMultipleSelection: Bool = false

    @Binding var showMembersList: Bool
    @Binding var forOrdinances: Bool
    @Binding var showEditButton: Bool

    var selectMemberAction: (Member) -> Void
    
    public init(showAddToViewModelView: Bool = false,
                expandRow: Bool = false,
                showCloseButton: Bool = false,
                showEditMemberRows: Bool = false,
                isSheet: Bool = true,
//                showConfirmDeleteOrganization: Bool = false,
                newlyAssignedMember: String = "",
                changeInCalling: Bool = false,
                memberAskedToSpeak: Bool = false,
                allowMultipleSelection: Bool = false,
                membersViewModel: MembersViewModel,
                orgMbrCallingViewModel: OrgMbrCallingViewModel,
                speakingAssignmentsViewModel: SpeakingAssignmentsViewModel,
                conductingSheetViewModel: ConductingSheetViewModel,
                prayersViewModel: PrayersViewModel,
                showMembersList: Binding<Bool>,
                forOrdinances: Binding<Bool>,
                showEditButton: Binding<Bool>,
                selectedMemberAction: @escaping (Member) -> Void) {
        self.membersViewModel = membersViewModel
        self.selectMemberAction = selectedMemberAction
        self.speakingAssignmentsViewModel = speakingAssignmentsViewModel
        self.orgMbrCallingViewModel = orgMbrCallingViewModel
        self.conductingSheetViewModel = conductingSheetViewModel
        self.prayersViewModel = prayersViewModel
        self._showMembersList = showMembersList
        self._forOrdinances = forOrdinances
        self._showEditButton = showEditButton
        self.newlyAssignedMember = newlyAssignedMember
        self.isSheet = isSheet
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showAddToViewModelView = showAddToViewModelView
        self.changeInCalling = changeInCalling
        self.expandRow = expandRow
        self.showCloseButton = showCloseButton
        self.showEditMemberRows = showEditMemberRows
        self.memberAskedToSpeak = memberAskedToSpeak
        self.allowMultipleSelection = allowMultipleSelection

        if membersViewModel.members.count == 0 {
            membersViewModel.fetchData {
                for member in membersViewModel.members {
                    orgMbrCallingViewModel.membersAndTheirCallings.append(orgMbrCallingViewModel.callingsForMember(name: member.name))
                }
            }
        }
    }
    
    //MARK: lettersListView
    
    var lettersListView: some View {
        VStack {
            ForEach(membersViewModel.alphaToMember, id: \.self) { letter in
                HStack {
                    Spacer()
                    Button(action: {
                        if membersViewModel.members.first(where: { $0.name.prefix(1) == letter }) != nil {
                            withAnimation {
                                scrollTarget = letter
                            }
                        }
                    }, label: {
                        Text(letter)
                            .font(.system(size: 14))
                            .padding(.trailing, 30)
                            .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                    })
                }
            }
        }
    }
    
    //MARK: searchBar
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
            TextField("", text: $memberName)
                .modifier(PlaceholderStyle(showPlaceHolder: memberName.isEmpty, placeholder: "Search"))
                .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                .font(Font.system(size: 21))
                .offset(y: -self.keyboardHeightHelper.keyboardHeight)
        }
        .padding(7)
        .background(branding.nonDestructiveButton)
        .cornerRadius(50)
    }
    
    //MARK: membersListView
    
    var membersListView: some View {
        ScrollView {
            ScrollViewReader { scrollProxy in
                LazyVStack(pinnedViews:[.sectionHeaders]) {
                    ForEach(membersViewModel.alphaToMember.filter{ self.searchForSection($0)}, id: \.self) { letter in
                        Section(header: SearchSectionHeaderView(text: letter).frame(width: nil, height: 35, alignment: .leading)) {
                            ForEach(membersViewModel.members.filter{ (member) -> Bool in member.name.prefix(1) == letter && self.searchForMember(member.name) }) { member in
                                MemberRow(conductingSheetViewModel: conductingSheetViewModel,
                                          orgMbrCallingViewModel: orgMbrCallingViewModel,
                                          membersViewModel: membersViewModel,
                                          prayersViewModel: prayersViewModel,
                                          member: member,
                                          newlyAssignedMember: $newlyAssignedMember,
                                          expandRow: $expandRow,
                                          isSheet: $isSheet,
                                          showEditMemberRows: $showEditMemberRows,
                                          callings: "",
                                          selectMemberAction: { selectedMemberName in
                                    membersViewModel.currentlySelectedMember = member
                                    
                                    showMembersList = false
                                    
                                    if membersViewModel.isSheet {
                                        membersViewModel.isSheet = false
                                        dismiss()
                                    }
                                    
                                    selectMemberAction(member)
                                })
                                .frame(height: 30)
                                .padding([.leading, .trailing], 40)
                                .contentShape(Rectangle())
                                .onTapGesture(perform: {
                                    if !membersViewModel.isSheet {
                                        expandRow.toggle()
                                    }
                                })
                                .onDisappear {
                                    if !conductingSheetViewModel.memberListInConductingSheet {
                                        membersViewModel.shouldShowCloseButon = false
                                        showCloseButton = false
                                        if changeInCalling {
                                            submit(for: .changeInCalling)
                                        } else if memberAskedToSpeak {
                                            submit(for: .memberAssignedToSpeak)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        scrollTarget = nil
                        withAnimation {
                            scrollProxy.scrollTo(target, anchor: .topLeading)
                        }
                    }
                }
            }
        }
        .environment(\.colorScheme, .light)
        .preferredColorScheme(.light)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ListHeaderView(headingTitle: ListHeadingTitles.members.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: membersViewModel,
                           speakingAssignmentsViewModel: speakingAssignmentsViewModel,
                           backgroundClr: branding.outerHeaderBackgroundColor,
                           addButtonAction: {_ in })
            .onAppear {
                if membersViewModel.isSheet {
                    membersViewModel.isInnerListHeader = true
                    membersViewModel.shouldShowCloseButon = true
                    showCloseButton = true
                } else {
                    membersViewModel.shouldShowAddItemButton = true
                    membersViewModel.shouldShowCloseButon = false
                }

                if conductingSheetViewModel.memberListInConductingSheet || PrayersViewModel.shared.memberListInAddPrayersSheet || speakingAssignmentsViewModel.memberListInAddSpeakingAssignmentsSheet {
                    membersViewModel.isSheet = true
                }

                switch (Constants.deviceIdiom) {
                case .pad:
                    font = branding.paragraphTextAndLinks_Semibold_17pt
                case .phone:
                    break
                default:
                    break
                }
            }
            
            if showEditButton {
                searchBar
                    .frame(height: 51)
                    .padding([.trailing, .leading], 15)
                    .background(branding.nonDestructiveButton)

                if showEditDoneButton {
                    Button {
                        showEditMemberRows = true
                        showEditDoneButton = false
                    } label: {
                        Label("Edit", systemImage: "rectangle.and.pencil.and.ellipsis")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .underline()
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.destructiveButton)
                    }
                    .padding(.bottom, 40)
                } else {
                    Button {
                        showEditMemberRows = false
                        showEditDoneButton = true
                    } label: {
                        Label("Done", systemImage: "person.fill.checkmark")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .underline()
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.destructiveButton)
                    }
                    .padding(.bottom, 40)
                }
            } else {
                searchBar
                    .frame(height: 51)
                    .padding([.trailing, .leading], 15)
                    .background(branding.nonDestructiveButton)
                    .padding(.bottom, 40)
            }
        }
        .onAppear() {
            if !MembersViewController.membersListLoadedFromMembersViewController || membersViewModel.isSheet {
                    membersViewModel.shouldShowCloseButon = true
                    showCloseButton = true
                } else {
                    membersViewModel.shouldShowCloseButon = false
                    showCloseButton = false
                }
                                
                membersViewModel.fetchData {
                    Task.init {
                       await membersViewModel.sortMembers()
                        membersViewModel.indexForName()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            
            ZStack {
                membersListView
                    .padding(.top, -50)
                lettersListView
                    .padding(.top, -30)
            }
        }
    
    //MARK: functions
    private func searchForMember(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(memberName.lowercased(with: .current)) || memberName.isEmpty)
    }
    
    private func searchForSection(_ txt: String) -> Bool {
        return (txt.prefix(1).lowercased(with: .current).hasPrefix(memberName.prefix(1).lowercased(with: .current)) || memberName.isEmpty)
    }
    
    func submit(for updateType: SubmitUpdateTypes) {
        switch updateType {
        case .changeInCalling:
            if membersViewModel.currentlySelectedMember.name != "" {
                let orgMbrCalling = OrgMbrCalling(uid: orgMbrCallingViewModel.selectedOrgMbrCallingUid,
                                                  callingName: orgMbrCallingViewModel.selectedOrgMbrCalling.callingName,
                                                  organizationName: orgMbrCallingViewModel.selectedOrgMbrCalling.organizationName,
                                                  memberName: membersViewModel.currentlySelectedMember.name,
                                                  memberToBeReleased: orgMbrCallingViewModel.selectedOrgMbrCalling.memberName,
                                                  approvedDate: "",
                                                  calledDate: "",
                                                  sustainedDate: "",
                                                  setApartDate: "",
                                                  releasedDate: "",
                                                  recommendedDate: convertToString(date: Date(), with: .medium),
                                                  ldrAssignToCall: "",
                                                  ldrAssignToSetApart: "",
                                                  callingPreviouslyFilledDate: orgMbrCallingViewModel.selectedOrgMbrCalling.callingPreviouslyFilledDate,
                                                  callingDisplayIndex: orgMbrCallingViewModel.selectedOrgMbrCalling.callingDisplayIndex,
                                                  callingAction: orgMbrCallingViewModel.selectedOrgMbrCalling.callingAction, recommendations: "")
                orgMbrCallingViewModel.updateCurrentOrgMbrCalling(model: orgMbrCalling) {
                    CoreDataManager.shared.updateCalling(model: orgMbrCalling) {
                        orgMbrCallingViewModel.fetchData {
                            orgMbrCallingViewModel.getOrgMbrCallingActions(forMe: false,
                                                                           leader: "",
                                                                           byOrganization:       false,
                                                                           organization: "") { results in }
                        }
                    }
                }
            }
        case .memberAssignedToSpeak:
            let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
            
            let speakingAssignment = SpeakingAssignment(uid: id, name: speakingAssignmentsViewModel.selectedMember, topic: speakingAssignmentsViewModel.topic, askToSpeakOnDate: convertToString(date: speakingAssignmentsViewModel.askToSpeakOnDate, with: .medium), weekOfYear: String(getWeekOfYear(date: speakingAssignmentsViewModel.askToSpeakOnDate)), weekNumberInMonthForSunday: String(speakingAssignmentsViewModel.weekNumberInMonthForSunday))

            speakingAssignmentsViewModel.addSpeakingAssignmentDocument(speakingAssignment: speakingAssignment) {
                CoreDataManager.shared.addSpeakingAssignment(speakingAssignment: speakingAssignment)
                speakingAssignmentsViewModel.fetchData {
                    speakingAssignmentsViewModel.filterSpeakingAssignment()

                    dismiss()
                }
            }
        }
    }
}
