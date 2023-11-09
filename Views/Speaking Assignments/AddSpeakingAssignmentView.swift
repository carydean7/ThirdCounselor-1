//
//  AddSpeakingAssignmentView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/24/23.
//

import SwiftUI

struct AddSpeakingAssignmentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding

    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel
    @ObservedObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var headingTitle = ListHeadingTitles.addSpeakingAssignment.rawValue
    @State private var showCloseButton: Bool = true
    @State private var assignmentSummaryText: String = ""
    @State private var showMemberListing = false
    @State private var date = NSDate()
    @State private var topic: String = ""
    @State private var speaker: String = ""
    @State private var loadWebView = false
    @State private var lowerTextContent: String? = ""
    @State private var showAddItemButton = false
    @State private var assignmentValidated = false
    @State private var selectedMember = ""
    @State private var selectedSunday = ""
    @State private var sundaySelected = false
    @State private var selectASunday = false
    @State private var topicSelected = false
    @State private var memberSelected = false
    @State private var closeButtonTrailingPadding: CGFloat = 0.0
    @State private var validationSucceeded = true
    @State private var primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt
    @State private var secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt
    @State private var showMembersList = false
    @State private var showEditButton: Bool = false

    @Binding var showAddSpeakingAssignmentsView: Bool
    
    public init(headingTitle: String = "",
                closeButtonTrailingPadding: CGFloat = 0.0,
                showCloseButton: Bool = true,
                assignmentSummaryText: String = "",
                showMemberListing: Bool = false,
                showEditButton: Bool = false,
                date: Date = Date(),
                topic: String = "",
                speaker: String = "",
                loadWebView: Bool = false,
                lowerTextContent: String = "",
                membersViewModel: MembersViewModel,
                orgMbrCallingViewModel: OrgMbrCallingViewModel,
                speakingAssignmentsViewModel: SpeakingAssignmentsViewModel,
                showAddItemButton: Bool = false,
                selectedMember: String = "",
                selectedSunday: String = "",
                selectASunday: Bool = false,
                topicSelected: Bool = false,
                memberSelected: Bool = false,
                validationSucceeded: Bool = true,
                showAddSpeakingAssignmentsView: Binding<Bool>
            ) {
        self.membersViewModel = membersViewModel
        self.orgMbrCallingViewModel = orgMbrCallingViewModel
        self.speakingAssignmentsViewModel = speakingAssignmentsViewModel
        self._showAddSpeakingAssignmentsView = showAddSpeakingAssignmentsView
        self.headingTitle = headingTitle
        self.closeButtonTrailingPadding = closeButtonTrailingPadding
        self.showCloseButton = showCloseButton
        self.assignmentSummaryText = assignmentSummaryText
        self.showMemberListing = showMemberListing
        self.showEditButton = showEditButton
        self.date = date as NSDate
        self.topic = topic
        self.speaker = speaker
        self.loadWebView = loadWebView
        self.lowerTextContent = lowerTextContent
        self.showAddItemButton = showAddItemButton
        self.selectedMember = selectedMember
        self.selectedSunday = selectedSunday
        self.selectASunday = selectASunday
        self.topicSelected = topicSelected
        self.memberSelected = memberSelected
        self.validationSucceeded = validationSucceeded
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                if showCloseButton {
                    CloseButtonView(headingTitle: headingTitle)
                        .onDisappear {
                            if headingTitle == ListHeadingTitles.speakingAssignment.rawValue {
                                SpeakingAssignmentsViewModel.shared.shouldShowAddItemButton = true
                            }
                        }
                        .padding(.trailing, closeButtonTrailingPadding)
                }
                
                Spacer()
                
                Text(headingTitle)
                    .customText(color: .white,
                                font: branding.screenSubTitle_Title2_28pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 0,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .center)
                   // .minimumScaleFactor(0.5)
            }
            .onAppear {
                switch headingTitle {
                case ListHeadingTitles.assignments.rawValue:
                    closeButtonTrailingPadding = -40.0
                case ListHeadingTitles.notes.rawValue:
                    closeButtonTrailingPadding = -60
                case ListHeadingTitles.callingActions.rawValue:
                    closeButtonTrailingPadding = -20
                default:
                    closeButtonTrailingPadding = 0.0
                }
            }
            .frame(height: 60)
            .background(RoundedCorners(color: branding.innerHeaderBackgroundColor, tl: 10, tr: 10, bl: 0, br: 0))
            .padding(.top, -270)

            if selectASunday {
                VStack {
                    Button {
                        validationSucceeded = true
                        speakingAssignmentsViewModel.memberListInAddSpeakingAssignmentsSheet = true
                        showMemberListing.toggle()
                    } label: {
                        Label("Select Member", systemImage: "person.3.fill")
                            .font(primaryFont)
                            .frame(height: 20)
                            .foregroundColor(branding.destructiveButton)
                            .padding()
                            .underline()
                    }
                    .sheet(isPresented: $showMemberListing) {
                        MembersListView(showCloseButton: false,
                                        isSheet: true,
                                        membersViewModel: membersViewModel,
                                        orgMbrCallingViewModel: orgMbrCallingViewModel,
                                        speakingAssignmentsViewModel: speakingAssignmentsViewModel,
                                        conductingSheetViewModel: ConductingSheetViewModel.shared,
                                        prayersViewModel: PrayersViewModel.shared,
                                        showMembersList: $showMembersList,
                                        forOrdinances: .constant(false),
                                        showEditButton: $showEditButton) { member in
                            selectedMember = member.name
                            memberSelected = true
                        }
                    }.onDisappear {
                        speakingAssignmentsViewModel.memberListInAddSpeakingAssignmentsSheet = false
                    }
                    .padding(.top, -80)
                    
                    if memberSelected {
                        Text("Member: \($selectedMember.wrappedValue)")
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: -70,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .frame(height: 20)
                            .underline()
                            .italic()
                    }
                }
                .environment(\.colorScheme, .light)
                
                VStack {
                    Button {
                        validationSucceeded = true
                        selectASunday.toggle()
                    } label: {
                        Label("Select a Sunday", systemImage: "calendar.circle")
                            .font(primaryFont)
                            .frame(height: 20)
                            .foregroundColor(branding.destructiveButton)
                            .underline()
                    }
                    .padding(.top, -60)
                    
                    if sundaySelected {
                        Text("Sunday: \(selectedSunday)")
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: -30,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .underline()
                            .italic()
                    }
                    
                    if selectASunday {
                        List {
                            ForEach(speakingAssignmentsViewModel.sundays, id: \.self) { sunday in
                                Button {
                                    speakingAssignmentsViewModel.selectedSunday = sunday
                                    selectedSunday = sunday
                                    
                                    // calculate which week of the month this sunday falls on ( 1-5)
                                    speakingAssignmentsViewModel.weekNumberInMonthForSunday =  speakingAssignmentsViewModel.getWeekNumberInMonthForSunday(dateString: sunday)
                                    selectASunday.toggle()
                                    sundaySelected = true
                                } label: {
                                    Label(sunday, systemImage: "calendar.circle")
                                        .foregroundColor(.black)
                                        .font(secondaryFont)
                                        .frame(height: 10)
                                }
                                .tint(.black)
                                .listRowSeparatorTint(.clear)
                            }
                        }
                        .frame(height: 250)
                        .padding(.top, -20)
                        
                        Divider()
                        
                    } else {
                        if sundaySelected {
                            Text("Sunday: \(selectedSunday)")
                                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                            font: secondaryFont,
                                            btmPad: 0,
                                            topPad: -150,
                                            leadPad: 0,
                                            trailPad: 0,
                                            width: .infinity,
                                            alignment: .center)
                                .underline()
                                .italic()
                        }
                    }
                }
                .environment(\.colorScheme, .light)
                
                VStack(alignment: .center, spacing: 20) {
                    Button {
                        validationSucceeded = true
                        topicSelected = true
                        loadWebView.toggle()
                    } label: {
                        Label("Select Conference Talk", systemImage: "person.wave.2.fill")
                            .font(primaryFont)
                            .frame(height: 20)
                            .foregroundColor(branding.destructiveButton)
                            .underline()
                    }
                    .sheet(isPresented: $loadWebView, content: {
                        Webview()
                    })
                    .padding(.top, 40)
                    
                    if topicSelected {
                        Text("Topic: \(speakingAssignmentsViewModel.selectedTitle)")
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .frame(height: 20)
                            .underline()
                            .italic()
                    }
                    
                    Text("OR")
                        .customText(color: branding.labels,
                                    font: primaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                        .frame(height: 20)
                    
                    TextField("Enter a topic here.", text: $topic)
                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                    font: secondaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 10,
                                    trailPad: 10,
                                    width: .infinity,
                                    alignment: .center)
                        .underlineTextField()
                        .frame(height: 20)
                        .offset(y: -self.keyboardHeightHelper.keyboardHeight)
                        .onChange(of: topic) { newValue in
                            topicSelected = true
                            validationSucceeded = true
                            speakingAssignmentsViewModel.selectedTitle = topic
                        }
                }
                .environment(\.colorScheme, .light)
            } else {
                VStack(spacing: 20) {
                    Button {
                        validationSucceeded = true
                        showMemberListing.toggle()
                    } label: {
                        Label("Select Member", systemImage: "person.3.fill")
                            .font(primaryFont)
                            .frame(height: 10)
                            .foregroundColor(branding.destructiveButton)
                    }
                    .sheet(isPresented: $showMemberListing) {
                        MembersListView(showCloseButton: false,
                                        isSheet: true,
                                        membersViewModel: membersViewModel,
                                        orgMbrCallingViewModel: orgMbrCallingViewModel,
                                        speakingAssignmentsViewModel: speakingAssignmentsViewModel,
                                        conductingSheetViewModel: ConductingSheetViewModel.shared,
                                        prayersViewModel: PrayersViewModel.shared,
                                        showMembersList: $showMembersList,
                                        forOrdinances: .constant(false),
                                        showEditButton: $showEditButton) { member in
                            selectedMember = member.name
                            memberSelected = true
                        }
                    }
                    .padding(.top, -120)
                    
                    if memberSelected {
                        Text("Member: \($selectedMember.wrappedValue)")
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: -115,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .underline()
                            .italic()
                    }
                    
                    Text("OR")
                        .customText(color: branding.labels,
                                    font: primaryFont,
                                    btmPad: 0,
                                    topPad: -100,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)

                    TextField("Enter speaker here", text: $speaker)
                        .underlineTextField()
                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                    font: primaryFont,
                                    btmPad: 0,
                                    topPad: -120,
                                    leadPad: 80,
                                    trailPad: 80,
                                    width: .infinity,
                                    alignment: .center)
                        .offset(y: -self.keyboardHeightHelper.keyboardHeight)
                        .onChange(of: speaker) { newValue in
                            selectedMember = speaker
                            speakingAssignmentsViewModel.selectedMember = speaker
                            memberSelected = true
                            validationSucceeded = true
                        }

                }
                .environment(\.colorScheme, .light)
                
                VStack(spacing: 20) {
                    Button {
                        validationSucceeded = true
                        selectASunday.toggle()
                    } label: {
                        Label("Select a Sunday", systemImage: "calendar.circle")
                            .font(primaryFont)
                          //  .frame(width: 300)
                            .frame(height: 10)
                            .foregroundColor(branding.destructiveButton)
                    }
                    .padding(.top, -40)
                    
                    if sundaySelected {
                        Text("Sunday: \(selectedSunday)")
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: -55,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .underline()
                            .italic()
                    }
                }
                .environment(\.colorScheme, .light)
                
                VStack(spacing: 40) {
                    Button {
                        validationSucceeded = true
                        topicSelected = true
                        loadWebView.toggle()
                    } label: {
                        Label("Select Conference Talk", systemImage: "person.wave.2.fill")
                            .font(primaryFont)
                          //  .frame(width: 300)
                            .frame(height: 10)
                            .foregroundColor(branding.destructiveButton)
                    }
                    .sheet(isPresented: $loadWebView, content: {
                        Webview()
                    })
                    .padding(30)
                    .padding(.top, -50)
                    
                    if topicSelected {
                        Text("Topic: \(speakingAssignmentsViewModel.selectedTitle)")
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: -50,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .font(secondaryFont)
                            .padding(.top, -50)
                            .underline()
                            .italic()
                            .foregroundColor(branding.destructiveButton)
                    }
                    
                    Text("OR")
                        .customText(color: branding.labels,
                                    font: primaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                    
                    TextField("Enter a topic here.", text: $topic)
                        .underlineTextField()
                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                    font: primaryFont,
                                    btmPad: 0,
                                    topPad: -40,
                                    leadPad: 80,
                                    trailPad: 80,
                                    width: .infinity,
                                    alignment: .leading)
                        .offset(y: -self.keyboardHeightHelper.keyboardHeight)
                        .onChange(of: topic) { newValue in
                            topicSelected = true
                            validationSucceeded = true
                            speakingAssignmentsViewModel.selectedTitle = topic
                        }
                }
                .environment(\.colorScheme, .light)
            }
            
            Button {
                addSpeakingAssignment()
            } label: {
                Label("ADD SPEAKING ASSIGNMENT", systemImage: "badge.plus.radiowaves.right")
                    .font(primaryFont)
                    .frame(height: 40)
                    .foregroundColor(branding.nonDestructiveButton)
            }
            .padding(.bottom, -200)
            
            if !validationSucceeded {
                Text("Missing Required Information")
                    .font(secondaryFont)
                    .foregroundColor(.red)
            } else {
                
            }
        }
        .onDisappear {
            getSundays(for: 52, date: Date()) { sundays in
                speakingAssignmentsViewModel.sundays = sundays
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
            
            getSundays(for: 52, date: Date()) { sundays in
                speakingAssignmentsViewModel.sundays = sundays
            }
        }
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
    }
    
    func addSpeakingAssignment() {
        if validateSpeakingAssignment() {
            let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"

            if topic.isEmpty {
                topic = speakingAssignmentsViewModel.selectedTitle
            }
            
            speakingAssignmentsViewModel.weekNumberInMonthForSunday = speakingAssignmentsViewModel.getWeekNumberInMonthForSunday(dateString: selectedSunday)
            
            let speakingAssignment = SpeakingAssignment(id: id, uid: id, name: selectedMember, topic: topic, askToSpeakOnDate: selectedSunday, weekOfYear: String(getWeekOfYear(date: convertToDate(stringDate: selectedSunday))), weekNumberInMonthForSunday: String(speakingAssignmentsViewModel.weekNumberInMonthForSunday))
            
            speakingAssignmentsViewModel.addSpeakingAssignmentDocument(speakingAssignment: speakingAssignment) {
                CoreDataManager.shared.addSpeakingAssignment(speakingAssignment: speakingAssignment)
                speakingAssignmentsViewModel.fetchData {
                    speakingAssignmentsViewModel.filterSpeakingAssignment()
                    showAddSpeakingAssignmentsView = false
                    dismiss()
                }
            }
        } else {
            validationSucceeded = false
        }
    }
    
    func validateSpeakingAssignment() -> Bool {
        if selectedMember != "" && speakingAssignmentsViewModel.selectedTitle != "" && selectedSunday != "" {
            return true
        }
        return false
    }
}

struct AddSpeakingAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeakingAssignmentView(membersViewModel: MembersViewModel.shared, orgMbrCallingViewModel: OrgMbrCallingViewModel.shared, speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared, showAddSpeakingAssignmentsView: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
            .previewDisplayName("iPhone 13 mini")
        
        AddSpeakingAssignmentView(membersViewModel: MembersViewModel.shared, orgMbrCallingViewModel: OrgMbrCallingViewModel.shared, speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared, showAddSpeakingAssignmentsView: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Pro 11-inch 4th Generation")
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
