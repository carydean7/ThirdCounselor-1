//
//  MultiSelectMembersListView.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 2/24/23.
//

import SwiftUI

struct MultiSelectMembersListView: View {
    enum SubmitUpdateTypes: Int {
        case changeInCalling
        case memberAssignedToSpeak
    }
        
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var showCloseButton: Bool = false
    @State private var changeInCalling = false
    @State private var listHeaderTopPadding: CGFloat = 140.0
    @State private var listHeaderHeight: CGFloat = 40.0
    @State private var navigationViewTopPadding: CGFloat = 95.0
    @State private var font: Font = Branding.mock.primaryListRow_Body_23pt
    @State private var scrollTarget: String?
    @State private var memberName = ""
    @State private var showEditMemberRows: Bool = false
    @State private var showEditDoneButton: Bool = true
    @State private var multiSelection = Set<UUID>()
    @State private var allowMultipleSelection: Bool = false
    @State private var showSelectedRowIcon: Bool = false
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var shouldUpdateRadioButton: Bool = false
    @State private var selections: [String] = [String]()

    @Binding var showMembersList: Bool

    var selectedMemberRecommendationsAction: ([Recommendation]) -> Void
    
    public init(showCloseButton: Bool = false,
                showEditMemberRows: Bool = false,
                changeInCalling: Bool = false,
                allowMultipleSelection: Bool = false,
                membersViewModel: MembersViewModel,
                orgMbrCallingViewModel: OrgMbrCallingViewModel,
                showMembersList: Binding<Bool>,
                selectedMemberRecommendationsAction: @escaping ([Recommendation]) -> Void) {
        self.membersViewModel = membersViewModel
        self.selectedMemberRecommendationsAction = selectedMemberRecommendationsAction
        self.orgMbrCallingViewModel = orgMbrCallingViewModel
        self._showMembersList = showMembersList
        self.changeInCalling = changeInCalling
        self.showCloseButton = showCloseButton
        self.showEditMemberRows = showEditMemberRows
        self.allowMultipleSelection = allowMultipleSelection
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
                                RadioButton(orgMbrCallingViewModel: orgMbrCallingViewModel,
                                            shouldUpdateRadioButton: shouldUpdateRadioButton,
                                            labelText: member.name,
                                            selections: $selections, forRecommendations: true) { results in
                                    print("results ::::: \(results)")
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
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
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

                switch (Constants.deviceIdiom) {
                case .pad:
                    font = branding.paragraphTextAndLinks_Semibold_17pt
                case .phone:
                    listHeaderTopPadding = -60
                    listHeaderHeight = 40
                    navigationViewTopPadding = 40

                default:
                    break
                }
            }
            
          //  if showEditButton {
                searchBar
                    .frame(height: 51)
                    .padding([.trailing, .leading], 15)
                    .background(branding.nonDestructiveButton)
            
//            if !itemSelection.isEmpty {
//                
//                Button("Deselect All"){
//                    print("Items: \(itemSelection)")
//                    itemSelection.removeAll()
//                }
//                .transition(AnyTransition.move(edge: .bottom))
//            }

//                if showEditDoneButton {
//                    Button {
//                        showEditMemberRows = true
//                        showEditDoneButton = false
//                    } label: {
//                        Label("Edit", systemImage: "rectangle.and.pencil.and.ellipsis")
//                            .multilineTextAlignment(.leading)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .padding()
//                            .underline()
//                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
//                            .foregroundColor(branding.destructiveButton)
//                    }
//                    .padding(.bottom, 40)
//                } else {
                    Button {
                        showEditMemberRows = false
                        showEditDoneButton = true
                        
                        if membersViewModel.isSheet {
                            membersViewModel.isSheet = false
                        //    dismiss()
                        }
                        
                        selectedMemberRecommendationsAction(orgMbrCallingViewModel.recommendations)
                        
                        dismiss()
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
//                }
          //  }
//            else {
//                searchBar
//                    .frame(height: 51)
//                    .padding([.trailing, .leading], 15)
//                    .background(branding.nonDestructiveButton)
//                    .padding(.bottom, 40)
//            }
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
                .onDisappear {
                    submit()
                }
            
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
    
    func submit() {
        if membersViewModel.currentlySelectedMember.name != "" {
            if orgMbrCallingViewModel.recommendations.count > 0 {
                orgMbrCallingViewModel.selectedOrgMbrCalling.callingAction = String(ActionTypes.recommendationsForApproval.rawValue)
            }
            
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
                                              callingAction: orgMbrCallingViewModel.selectedOrgMbrCalling.callingAction,
                                              recommendations:DataManager.shared.convertArrayOfRecommendationsToDeliniatedString(recommendations: orgMbrCallingViewModel.recommendations))
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
    }
}

struct RadioButton: View {
    @Environment(\.branding) var branding

    @ObservedObject var orgMbrCallingViewModel: OrgMbrCallingViewModel

    @State private var shouldUpdateRadioButton: Bool = false
    @State private var forRecommendations: Bool = false
    
    @Binding var selections: [String]
    
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    
    var labelText: String
    var actionHandler: (String) -> Void
    
    var leadingPadding: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                return CGFloat(20)
            }
        case .phone:
            return CGFloat(-20)
        @unknown default:
            return CGFloat(-20)
        }
    
        return CGFloat(-20)
    }
    
    var trailingPadding: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                return CGFloat(60)
            }
        case .phone:
            return CGFloat(0)
        @unknown default:
            return CGFloat(0)
        }
        
        return CGFloat(0)
    }
    
    init(orgMbrCallingViewModel: OrgMbrCallingViewModel = OrgMbrCallingViewModel.shared,
         shouldUpdateRadioButton: Bool = false,
         labelText: String,
         selections: Binding<[String]>,
         forRecommendations: Bool,
         actionHandler: @escaping (String) -> Void) {
        self.orgMbrCallingViewModel = orgMbrCallingViewModel
        self.shouldUpdateRadioButton = shouldUpdateRadioButton
        self.labelText = labelText
        self._selections = selections
        self.forRecommendations = forRecommendations
        self.actionHandler = actionHandler
    }
    
    var body: some View {
            Button {
                shouldUpdateRadioButton.toggle()
                
                if forRecommendations {
                    if shouldUpdateRadioButton {
                        orgMbrCallingViewModel.recommendations.append(Recommendation(uid: UUID().uuidString, selectionIndex: 0, member: labelText))
                    } else {
                        orgMbrCallingViewModel.removeRecommendation(member: labelText)
                    }
                } else {
                    if !selectionExists(in: labelText) {
                        actionHandler(labelText)
                    }
                }
            } label: {
                Label(labelText, systemImage: shouldUpdateRadioButton ? "circle.fill" : "circle")
                    .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                    .padding(.leading, 10)
                    .minimumScaleFactor(0.5)
            }
            .font(branding.paragraphTextAndLinks_Semibold_17pt)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 30)
            .padding(.trailing, trailingPadding)
            .padding(.leading, leadingPadding)
    }
    
    func selectionExists(in selected: String) -> Bool {
        for selection in selections {
            if selection == selected {
                return true
            }
        }
        
        return false
    }
}
