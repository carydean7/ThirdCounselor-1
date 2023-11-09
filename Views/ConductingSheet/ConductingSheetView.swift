//
//  ConductingSheetView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/8/23.
//

import SwiftUI

struct ConductingSheetView: View, AddButtonDelegate {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var hymnsViewModel: HymnsViewModel = HymnsViewModel.shared
    @ObservedObject var viewModel: ConductingSheetViewModel = ConductingSheetViewModel.shared
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var showHymnsList = false
    @State private var showMembersList = false
    @State private var showCloseButton = false
    @State private var showSelectionListView = false
    @State private var tapInUpperContent = false
    @State private var textFieldData = ""
    @State private var showAddToViewModelView: Bool = false
    @State private var intermediateHymnOrSpecialMusicalNumberSelection: String = ""
    @State private var musicMember1 = ""
    @State private var isPresented = false
    @State private var showEditButton: Bool = false
    @State private var isInnerListHeader: Bool = true
    @State private var showPresidingAuthorityList = false
    @State private var isSheet: Bool = false
    @State private var announcement: String = ""
    @State private var announcementsFound: Bool = false
    @State private var newMembersFound: Bool = false
    
    @State private var showAddAnnouncementAlert: Bool = true
    
    @FocusState private var focusConfirm: Bool
    
    @Binding var selectedSheetIdx: Int?
    @Binding var addAnnouncementButtonTapped: Bool
    
    var selectedSheetSection: Int
    var selectConductingSheetSectionAction: (Int) -> Void
    
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    
    init(selectedSheetIdx: Binding<Int?>,
         showSelectionListView: Bool = false,
         showCloseButton: Bool = false,
         textFieldData: String = "",
         selectedSheetSection: Int = 0,
         tapInUpperContent: Bool = false,
         addAnnouncementButtonTapped: Binding<Bool>,
         viewModel: ConductingSheetViewModel = ConductingSheetViewModel.shared,
         hymnsViewModel: HymnsViewModel = HymnsViewModel.shared,
         showHymnsList: Bool = false,
         showMembersList: Bool = false,
         showEditButton: Bool = false,
         showPresidingAuthorityList: Bool = false,
         isSheet: Bool = false,
         showAddAnnouncementAlert: Bool = false,
         announcement: String = "",
         selectConductingSheetSectionAction: @escaping (Int) -> Void
    ) {
        self._addAnnouncementButtonTapped = addAnnouncementButtonTapped
        self._selectedSheetIdx = selectedSheetIdx
        self.selectConductingSheetSectionAction = selectConductingSheetSectionAction
        self.selectedSheetSection = selectedSheetSection
        self.viewModel = viewModel
        self.hymnsViewModel = hymnsViewModel
        self.textFieldData = textFieldData
        self.showSelectionListView = showSelectionListView
        self.showCloseButton = showCloseButton
        self.showHymnsList = showHymnsList
        self.showMembersList = showMembersList
        self.showEditButton = showEditButton
        self.showPresidingAuthorityList = showPresidingAuthorityList
        self.isSheet = isSheet
        self.showAddAnnouncementAlert = showAddAnnouncementAlert
        self.announcement = announcement
        self.tapInUpperContent = tapInUpperContent
        
        self.viewModel.addButtonDelegate = self
    }
    
    var body: some View {
        Form {
            VStack {
                ListHeaderView(headingTitle: viewModel.selectedConductingSheetSection.sectionTitle ?? "",
                               showCloseButton: $showCloseButton,
                               isInnerListHeader: $isInnerListHeader,
                               showConfirmDeleteOrganization: .constant(false),
                               backgroundClr: branding.innerHeaderBackgroundColor,
                               addButtonAction: { showAddTextField in
                })
                .onAppear {
                    switch viewModel.selectedConductingSheetSection.sheetSection {
                    case ConductingSectionsIndexes.announcements.rawValue:
                        if viewModel.selectedConductingSheetSection.announcements.isEmpty {
                            viewModel.selectedConductingSheetSection.announcements.append("No Announcements")
                            announcementsFound = false
                        } else {
                            if viewModel.selectedConductingSheetSection.announcements.first == "No Announcements" {
                                announcementsFound = false
                            } else {
                                announcementsFound = true
                            }
                        }
                        
                    case ConductingSectionsIndexes.wardBusinessMoveIns.rawValue:
                        if viewModel.selectedConductingSheetSection.wardBusinessMoveIns.isEmpty {
                            viewModel.selectedConductingSheetSection.wardBusinessMoveIns.append("No New Members Moved In")
                            newMembersFound = false
                        } else {
                            if viewModel.selectedConductingSheetSection.wardBusinessMoveIns.first == "No New Members Moved In" {
                                newMembersFound = false
                            } else {
                                newMembersFound = true
                            }
                        }
                        
                    case ConductingSectionsIndexes.wardBusinessReleases.rawValue:
                        viewModel.convertTupleToStringArray(for: .releases)
                        
                    case ConductingSectionsIndexes.wardBusinessSustainings.rawValue:
                        viewModel.convertTupleToStringArray(for: .sustainings)
                        
                    case ConductingSectionsIndexes.wardBusinessOrdinations.rawValue:
                        viewModel.getOrdinanceInterviews()
                    default:
                        break
                    }
                }
                
                VStack {
                    HStack {
                        ContentView(viewModel: viewModel,
                                    upperContent: true,
                                    showHymnsList: $showHymnsList,
                                    showMembersList: $showMembersList,
                                    isUpperContent: .constant(true),
                                    showListTapGestureAction: { listToShow in
                            if listToShow == .hymns {
                                handleTapGesture(for: viewModel.selectedConductingSheetSection.sheetSection, upperContent: true)
                            }
                        })
                        
                        if viewModel.selectedConductingSheetSection.upperSectionIsEditable {
                            Button {
                                handleTapGesture(for: viewModel.selectedConductingSheetSection.sheetSection, upperContent: true)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: 125, alignment: .trailing)
                                    .padding()
                                    .underline()
                                    .font(branding.paragraphTextAndLinks_Semibold_17pt)
                                    .foregroundColor(branding.destructiveButton)
                            }
                            .frame(maxWidth: 125, alignment: .trailing)
                            .padding(.bottom, 40)
                            .padding(.trailing, 0)
                        }
                    }
                    
                    if $viewModel.selectedConductingSheetSection.showTextField.wrappedValue {
                        if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.welcome.rawValue || viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.openingHymn.rawValue ||
                            viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.announcements.rawValue || viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.wardBusinessMoveIns.rawValue {
                            TextField("", text: .constant("")) {
                                UIApplication.shared.endEditing()
                            }
                                .font(branding.formControlsButtonsTextInputs_Semibold_17pt)
                                .padding(.bottom, 20)
                                .padding(.top, -120)
                                .padding([.leading, .trailing], -10)
                                .frame(maxWidth: .infinity)
                                .frame(height: 20)
                        }
                    }
                    
                    if viewModel.selectedConductingSheetSection.showList {
                        List {
                            if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.announcements.rawValue {
                                ForEach(viewModel.selectedConductingSheetSection.announcements, id: \.self) { announcement in
                                    HStack(spacing: 20) {
                                        Text(announcement)
                                            .lineLimit(3)
                                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                                        btmPad: 0,
                                                        topPad: 0,
                                                        leadPad: 0,
                                                        trailPad: 0,
                                                        width: .infinity,
                                                        alignment: .leading)
                                            .contentShape(Rectangle())
                                        if announcementsFound {
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.announced.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 0,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: .constant(false),
                                                         showLeaders: .constant(false),
                                                         color: branding.nonDestructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt,
                                                         nextActionTypeMessage: "",
                                                         itemIndex: -1,
                                                         actionHandler: { _ in
                                                viewModel.announcementAnnounced(proclamation: announcement)
                                            })
                                        }

                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.wardBusinessMoveIns.rawValue {
                                ForEach(viewModel.selectedConductingSheetSection.wardBusinessMoveIns, id: \.self) { member in
                                    HStack(spacing: 20) {
                                        Text(member)
                                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                                        btmPad: 0,
                                                        topPad: 0,
                                                        leadPad: 0,
                                                        trailPad: 0,
                                                        width: .infinity,
                                                        alignment: .leading)
                                            .contentShape(Rectangle())
                                        
                                        if newMembersFound {
                                            ActionButton(branding: branding,
                                                         buttonTitle: CallingActionTypeButtonTitles.welcomed.stringValue,
                                                         topPadding: 0,
                                                         bottomPadding: 0,
                                                         leadingPadding: 0,
                                                         trailingPadding: 0,
                                                         bishopBranchStakePresidentOnly: .constant(false),
                                                         showLeaders: .constant(false),
                                                         color: branding.nonDestructiveButton,
                                                         font: branding.pageAndModalTitle_Semibold_17pt,
                                                         nextActionTypeMessage: "",
                                                         itemIndex: -1,
                                                         actionHandler: { _ in
                                                viewModel.memberWelcomed(name: member)
                                            })
                                        }
                                    }
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity)
                                }
                            } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.wardBusinessReleases.rawValue {
                                ForEach(viewModel.releasesDataSource, id: \.self) { releases in
                                    Text(releases)
                                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                    font: branding.paragraphTextAndLinks_Regular_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: .infinity,
                                                    alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                            } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.wardBusinessSustainings.rawValue {
                                ForEach(viewModel.sustainingsDataSource, id: \.self) { sustainings in
                                    Text(sustainings)
                                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                    font: branding.paragraphTextAndLinks_Regular_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 0,
                                                    trailPad: 0,
                                                    width: .infinity,
                                                    alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                            } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.wardBusinessOrdinations.rawValue {
                                ForEach(viewModel.ordinationsDataSource, id: \.self) { ordinations in
                                    HStack {
                                        Text(ordinations.name)
                                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                                        btmPad: 0,
                                                        topPad: 0,
                                                        leadPad: 0,
                                                        trailPad: 0,
                                                        width: .infinity,
                                                        alignment: .leading)
                                            .contentShape(Rectangle())
                                        
                                        Text(ordinations.ordination)
                                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                                        btmPad: 0,
                                                        topPad: 0,
                                                        leadPad: 0,
                                                        trailPad: 0,
                                                        width: .infinity,
                                                        alignment: .leading)
                                            .contentShape(Rectangle())
                                    }
                                }
                            } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.speakersAndMusic.rawValue {
                                ForEach(viewModel.currentWeeksSpeakingAssignments, id: \.id) { speaker in
                                    if speaker.topic.contains("Music") {
                                        HStack {
                                            Text(speaker.name + "- Special Musical Number")
                                                .foregroundColor(branding.destructiveButton)
                                            Spacer()
                                            Label("", systemImage: "arrow.up.and.down.text.horizontal")
                                                .font(branding.paragraphTextAndLinks_Semibold_17pt)
                                                .foregroundColor(branding.nonDestructiveButton)
                                        }
                                    } else {
                                        HStack {
                                            Text(speaker.name)
                                                .foregroundColor(branding.destructiveButton)
                                            Spacer()
                                            Label("", systemImage: "arrow.up.and.down.text.horizontal")
                                                .font(branding.paragraphTextAndLinks_Semibold_17pt)
                                                .foregroundColor(branding.nonDestructiveButton)
                                        }
                                    }
                                }
                                .onMove { indicies, destination in
                                    viewModel.currentWeeksSpeakingAssignments.move(fromOffsets: indicies, toOffset: destination)
                                }
                                .listRowSeparator(.hidden)
                            } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.welcome.rawValue {
                                ForEach(1...5, id: \.self) { val in
                                    Text("")
                                }
                            }
                        }
                    }
                    else {
                        Spacer().frame(maxHeight: 280)
                    }
                    
                    HStack {
                        ContentView(viewModel: viewModel,
                                    upperContent: false,
                                    showHymnsList: $showHymnsList,
                                    showMembersList: $showMembersList,
                                    isUpperContent: .constant(false),
                                    showListTapGestureAction: { listToShow in
                            if listToShow == .members {
                                showMembersList = true
                            } else if listToShow == .leaders {
                                showPresidingAuthorityList = true
                            }
                            
                            handleTapGesture(for: viewModel.selectedConductingSheetSection.sheetSection, upperContent: /*tapInUpperContent*/ false)
                            
                            showSelectionListView = true
                            dismiss()
                        })
                        
                        if viewModel.selectedConductingSheetSection.lowerSectionIsEditable {
                            Button {
//                                tapInUpperContent = false
                                handleTapGesture(for: viewModel.selectedConductingSheetSection.sheetSection, upperContent: /*tapInUpperContent*/ false)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: 125, alignment: .trailing)
                                    .padding()
                                    .underline()
                                    .font(branding.paragraphTextAndLinks_Semibold_17pt)
                                    .foregroundColor(branding.destructiveButton)
                            }
                            .frame(maxWidth: 125, alignment: .trailing)
                            .padding(.bottom, 40)
                            .padding(.trailing, 0)
                        }
                    }
                }
                
                if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.speakersAndMusic.rawValue {
                    Button {
                        showAddToViewModelView.toggle()
                    } label: {
                        Label("Add Hymn or Musical Number", systemImage: "music.note.list")
                            .fontWeight(.regular)
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.nonDestructiveButton)
                    }
                    .font(Branding.mock.screenTitle_Title_34pt)
                    .alert("Intermediate Hymn or Special Musical Number", isPresented: $showAddToViewModelView) {
                        TextField(" Enter selection", text: $intermediateHymnOrSpecialMusicalNumberSelection)
                            .preferredColorScheme(.light)
                            .foregroundColor(.white)
                            .font(branding.paragraphTextAndLinks_Regular_17pt)
                            .offset(y: -self.keyboardHeightHelper.keyboardHeight)
                        Button("ADD", role: .destructive, action: submit)
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                        Button("CANCEL", role: .cancel, action: {})
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                    } message: {
                        Text("Enter the intermediate hymn or special musical number below:")
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.62)
            .sheet(isPresented: $showMembersList, onDismiss: {
                showMembersList = false
            }, content: {
                MembersListView(showCloseButton: false,
                                isSheet: true,
                                membersViewModel: MembersViewModel.shared,
                                orgMbrCallingViewModel: OrgMbrCallingViewModel.shared,
                                speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                                conductingSheetViewModel: ConductingSheetViewModel.shared,
                                prayersViewModel: PrayersViewModel.shared,
                                showMembersList: $showMembersList,
                                forOrdinances: .constant(true),
                                showEditButton: $showEditButton) { member in
                    
                    var isUpperSection = false
                    
                    switch viewModel.selectedConductingSheetSection.sheetSection {
                    case ConductingSectionsIndexes.openingHymn.rawValue:
                            viewModel.selectedConductingSheetSection.invocation = member.name
                        
                    case ConductingSectionsIndexes.wardBusinessOrdinations.rawValue:
                        isUpperSection = true
                        
                    case ConductingSectionsIndexes.speakersAndMusic.rawValue:
                        isUpperSection = true
                        var providerExists = false
                        if let musicProviders = viewModel.selectedConductingSheetSection.musicProviders {
                            for provider in musicProviders {
                                if provider == member.name {
                                    providerExists = true
                                }
                            }
                            
                            if !providerExists {
                                viewModel.selectedConductingSheetSection.musicProviders?.append(member.name)
                            }
                        }
                        
                    case ConductingSectionsIndexes.closingHymn.rawValue:
                        viewModel.selectedConductingSheetSection.benediction = member.name
                        
                    default:
                        break
                    }
                    
                    if isUpperSection {
                        if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.speakersAndMusic.rawValue {
                            if let musicProviders = viewModel.selectedConductingSheetSection.musicProviders {
                                if musicProviders.count == 2 {
                                    for (index, member) in musicProviders.enumerated() {
                                        switch index {
                                        case 0:
                                            viewModel.selectedConductingSheetSection.upperSectionContent = viewModel.selectedConductingSheetSection.upperSectionContent?.replacingOccurrences(of: "<Conductor>", with: member)
                                        case 1:
                                            viewModel.selectedConductingSheetSection.upperSectionContent = viewModel.selectedConductingSheetSection.upperSectionContent?.replacingOccurrences(of: "<Accompanist>", with: member)
                                        default:
                                            break
                                        }
                                    }
                                }
                            }
                        } else {
                            viewModel.selectedConductingSheetSection.upperSectionContent = viewModel.selectedConductingSheetSection.upperSectionContent?.replacingOccurrences(of: "<Member>", with: member.name)
                        }
                    } else {
                        if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.openingHymn.rawValue {
                            if let invocation = viewModel.selectedConductingSheetSection.invocation {
                                if !invocation.isEmpty {
                                    viewModel.selectedConductingSheetSection.lowerSectionContent = viewModel.selectedConductingSheetSection.lowerSectionContent?.replacingOccurrences(of: "<Member>", with: invocation)
                                }
                            }
                        } else if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.closingHymn.rawValue {
                            if let benediction = viewModel.selectedConductingSheetSection.benediction {
                                if !benediction.isEmpty {
                                    viewModel.selectedConductingSheetSection.lowerSectionContent = viewModel.selectedConductingSheetSection.lowerSectionContent?.replacingOccurrences(of: "<Member>", with: benediction)
                                }
                            }
                        } else {
                            viewModel.selectedConductingSheetSection.lowerSectionContent = viewModel.selectedConductingSheetSection.lowerSectionContent?.replacingOccurrences(of: "<Member>", with: member.name)
                        }
                    }
                    
                    dismiss()
                }
            })
            .sheet(isPresented: $showHymnsList, onDismiss: {
                showHymnsList = false
            }, content: {
                HymnsListView { hymn in }
            })
            .sheet(isPresented: $showPresidingAuthorityList, onDismiss: {
                // isSheet = true
            }, content: {
                var key = ""
                PresidingAuthorityListView(isSheet: $isSheet) { selectedLeaderPosition in
                    let defaults = UserDefaults.standard
                    
                    if selectedLeaderPosition == "stakePresident" {
                        key = "Stake President"
                    }
                    
                    if selectedLeaderPosition == "stakePresidencyFirstCounselor" {
                        key = LeadersPresidingAtSacrament.stakePresidencyFirstCounselor.stringValue
                    }
                    
                    if selectedLeaderPosition == "stakePresidencySecondCounselor" {
                        key = LeadersPresidingAtSacrament.stakePresidencySecondCounselor.stringValue
                    }
                    
                    if let leaderName = defaults.string(forKey: key) {
                        ConductingViewController.presidingAuthorityName = leaderName
                        ConductingSheetViewModel.shared.conductingSheetSections[viewModel.selectedConductingSheetSection.sheetSection].presiding = leaderName
                        
                        viewModel.selectedConductingSheetSection.lowerSectionContent = viewModel.selectedConductingSheetSection.lowerSectionContent?.replacingOccurrences(of: "<Leader>", with: leaderName)
                        
                        viewModel.conductingSheetSections[viewModel.selectedConductingSheetSection.sheetSection].lowerSectionContent = viewModel.conductingSheetSections[viewModel.selectedConductingSheetSection.sheetSection].lowerSectionContent?.replacingOccurrences(of: "<Leader>", with: leaderName)
                        dismiss()
                        showPresidingAuthorityList = false
                    }
                }
            })
            
            .onAppear {
                switch viewModel.selectedConductingSheetSection.sheetSection {
                case ConductingSectionsIndexes.announcements.rawValue:
                    if viewModel.selectedConductingSheetSection.announcements.isEmpty {
                        viewModel.selectedConductingSheetSection.announcements.append("No Announments")
                    }
                    
                case ConductingSectionsIndexes.wardBusinessMoveIns.rawValue:
                    if viewModel.selectedConductingSheetSection.wardBusinessMoveIns.isEmpty {
                        viewModel.selectedConductingSheetSection.wardBusinessMoveIns.append("No New Members Moved In")
                    }
                    
                case ConductingSectionsIndexes.wardBusinessReleases.rawValue:
                    viewModel.convertTupleToStringArray(for: .releases)
                    
                case ConductingSectionsIndexes.wardBusinessSustainings.rawValue:
                    viewModel.convertTupleToStringArray(for: .sustainings)
                    
                case ConductingSectionsIndexes.wardBusinessOrdinations.rawValue:
                    viewModel.getOrdinanceInterviews()
                    break
                default:
                    break
                }
                
                selectConductingSheetSectionAction(selectedSheetIdx ?? 0)
            }
            .environmentObject(hymnsViewModel)
            .environmentObject(viewModel)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.85)
    }
    
    func addButtonAction() {
        viewModel.showAddAnnouncementAlert = true
    }
        
    func handleTapGesture(for section: Int, upperContent: Bool, showPresidingAuthorityAlert: Bool = false) {
        if upperContent {
            switch section {
            case ConductingSectionsIndexes.welcome.rawValue,
                ConductingSectionsIndexes.wardBusinessMoveIns.rawValue,
                ConductingSectionsIndexes.wardBusinessReleases.rawValue,
                ConductingSectionsIndexes.wardBusinessSustainings.rawValue:
                break
               
            case ConductingSectionsIndexes.announcements.rawValue:
                showAddAnnouncementAlert = true

            case ConductingSectionsIndexes.openingHymn.rawValue:
                viewModel.selectedConductingSheetSection.upperSectionContent = Constants.ConductingSheetContents.Upper.openHymnInvocation
                showHymnsList = true
                
            case ConductingSectionsIndexes.sacramentMusic.rawValue:
                viewModel.selectedConductingSheetSection.upperSectionContent = Constants.ConductingSheetContents.Upper.sacrament
                showHymnsList = true
                
            case ConductingSectionsIndexes.closingHymn.rawValue:
                viewModel.selectedConductingSheetSection.upperSectionContent = Constants.ConductingSheetContents.Upper.closeHymnBenediction
                showHymnsList = true
                
            case ConductingSectionsIndexes.wardBusinessOrdinations.rawValue:
                viewModel.conductingSheetSections[viewModel.selectedConductingSheetSection.sheetSection].upperSectionContent = Constants.ConductingSheetContents.Upper.ordinations
                
            case ConductingSectionsIndexes.speakersAndMusic.rawValue:
                viewModel.conductingSheetSections[viewModel.selectedConductingSheetSection.sheetSection].upperSectionContent = Constants.ConductingSheetContents.Upper.sacramentProgram
                
            default:
                break
            }
        } else {
            switch section {
            case ConductingSectionsIndexes.welcome.rawValue:
                viewModel.selectedConductingSheetSection.lowerSectionContent = Constants.ConductingSheetContents.Lower.welcome
                
                self.showPresidingAuthorityList = true
                
            case ConductingSectionsIndexes.announcements.rawValue,
                ConductingSectionsIndexes.wardBusinessMoveIns.rawValue,
                ConductingSectionsIndexes.wardBusinessReleases.rawValue,
                ConductingSectionsIndexes.wardBusinessSustainings.rawValue,
                ConductingSectionsIndexes.wardBusinessOrdinations.rawValue,
                ConductingSectionsIndexes.sacramentMusic.rawValue,
                ConductingSectionsIndexes.speakersAndMusic.rawValue:
                break
                
            case ConductingSectionsIndexes.openingHymn.rawValue:
                viewModel.selectedConductingSheetSection.lowerSectionContent = Constants.ConductingSheetContents.Lower.openHymnInvocation
                
            case ConductingSectionsIndexes.closingHymn.rawValue:
                viewModel.selectedConductingSheetSection.lowerSectionContent = Constants.ConductingSheetContents.Lower.closeHymnBenediction
                
            default:
                break
            }
        }
    }
    
    func submit() {
        if viewModel.selectedConductingSheetIndex == ConductingSectionsIndexes.speakersAndMusic.rawValue {
            viewModel.selectedConductingSheetSection.showList = true
            let speakingAssignment = SpeakingAssignment(uid: "", name: $intermediateHymnOrSpecialMusicalNumberSelection.wrappedValue, topic: $intermediateHymnOrSpecialMusicalNumberSelection.wrappedValue, askToSpeakOnDate: "", weekOfYear: "", weekNumberInMonthForSunday: "")
            viewModel.currentWeeksSpeakingAssignments.append(speakingAssignment)
        }
    }
}
