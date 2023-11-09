//
//  AddInterviewView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/4/23.
//

import Combine
import SwiftUI

struct AddInterviewView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var interviewsViewModel: InterviewsViewModel
    
    @State private var selectedInterviewType: String = "No Interview Type Selected"
    @State private var isPresented = false
    @State private var selectedMember = "No Member Selected"
    @State private var memberSelected = false
    @State private var selectedDate = ""
    @State private var selectedTime = ""
    @State private var interviewIsValid = false
    @State private var currentTime = Date()
    @State private var showInfoAlert = false
    @State private var showLeaderAlert = false
    @State private var selectedLeader = ""
    @State private var leaders = [String]()
    @State private var isSheet: Bool = false
    @State private var showMembersList: Bool = false
    @State private var interviews = [[String]]()
    @State private var showInterviewTypesList = false
    @State private var showAuthorizedLeaderList = false
    @State private var selectedAuthorizedLeader: String = "No Leader Selected"
    @State private var authorizedLeaderAssociatedWithSelectedInterviewType: String = ""
    @State private var selectedCategory: String = ""
    @State private var showCloseButton: Bool = true
    @State private var showDateTimePicker: Bool = false
    @State private var selectedPriesthoodOffice: String = ""
    @State private var onlyBishopBranchOrStakePresident: Bool = false
    @State private var forOrdinances: Bool = false
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var showEditButton: Bool = false

    let iPadLandVStackTopPaddingInterviewIsValid = -135
    let iPadLandVStackTopPaddingInterviewNotValid = -265
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    
    var listHeaderViewTopPadding: CGFloat {
        if showDateTimePicker {
            return CGFloat(-140)
        } else {
            return CGFloat(-150)
        }
    }

    var vStackTopPadding: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                if interviewIsValid {
                    return CGFloat(iPadLandVStackTopPaddingInterviewIsValid)
                } else {
                    return CGFloat(iPadLandVStackTopPaddingInterviewNotValid)
                }
            }

        default:
            break
        }
        
        return 0
    }
    
    init(selectedInterviewType: String = "No Interview Type Selected",
         selectedAuthorizedLeader: String = "No Leader Selected",
         authorizedLeaderAssociatedWithSelectedInterviewType: String = "",
         isPresented: Bool = false,
         membersViewModel: MembersViewModel,
         interviewsViewModel: InterviewsViewModel,
         selectedMember: String = "No Member Selected",
         selectedCategory: String = "",
         forOrdinances: Bool = false,
         showEditButton: Bool = false,
         interviewIsValid: Bool = false,
         memberSelected: Bool = false,
         showMembersList: Bool = false,
         showCloseButton: Bool = true,
//         showConfirmDeleteOrganization: Bool = false,
         showDateTimePicker: Bool = false,
         showInterviewTypesList: Bool = false,
         showAuthorizedLeaderList: Bool = false,
         selectedPriesthoodOffice: String = "",
         onlyBishopBranchOrStakePresident: Bool = false) {
        self.membersViewModel = membersViewModel
        self.interviewsViewModel = interviewsViewModel
        self.selectedInterviewType = selectedInterviewType
        self.selectedAuthorizedLeader = selectedAuthorizedLeader
        self.authorizedLeaderAssociatedWithSelectedInterviewType = authorizedLeaderAssociatedWithSelectedInterviewType
        self.isPresented = isPresented
        self.selectedMember = selectedMember
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showDateTimePicker = showDateTimePicker
        self.selectedCategory = selectedCategory
        self.forOrdinances = forOrdinances
        self.showEditButton = showEditButton
        self.interviewIsValid = interviewIsValid
        self.memberSelected = memberSelected
        self.showMembersList = showMembersList
        self.showInterviewTypesList = showInterviewTypesList
        self.showAuthorizedLeaderList = showAuthorizedLeaderList
        self.selectedPriesthoodOffice = selectedPriesthoodOffice
        self.onlyBishopBranchOrStakePresident = onlyBishopBranchOrStakePresident
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack {
                    Button {
                        showMembersList.toggle()
                        membersViewModel.isSheet = true
                    } label: {
                        Label("Members", systemImage: "person.3.fill")
                            .multilineTextAlignment(.leading)
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 50)
                            .underline()
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.labels)
                    }
                    .frame(height: 20)
                    .sheet(isPresented: $showMembersList, onDismiss: {
                        isSheet = true
                    }, content: {
                        MembersListView(isSheet: true,
                                        membersViewModel: membersViewModel,
                                        orgMbrCallingViewModel: OrgMbrCallingViewModel.shared,
                                        speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                                        conductingSheetViewModel: ConductingSheetViewModel.shared,
                                        prayersViewModel: PrayersViewModel.shared,
                                        showMembersList: $showMembersList,
                                        forOrdinances: $forOrdinances,
                                        showEditButton: $showEditButton) { member in
                            selectedMember = member.name
                            membersViewModel.currentlySelectedMember = member
                            
                            if validateInterview() {
                                interviewIsValid = true
                            }
                            
                            memberSelected = true
                        }
                    })
                    .environment(\.colorScheme, .light)
                    
                    Text(selectedMember)
                        .customText(color: branding.contentTextColor,
                                    font: branding.paragraphTextAndLinks_Regular_17pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 28,
                                    trailPad: 0,
                                    width: 300,
                                    alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .frame(height: 80)
                } // end vstack
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack {
                    Button {
                        showInterviewTypesList.toggle()
                        showAuthorizedLeaderList = false
                    } label: {
                        Label("Types", systemImage: "person.line.dotted.person.fill")
                            .multilineTextAlignment(.leading)
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 50)
                            .underline()
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.labels)
                    }
                    .frame(height: 20)
                    .sheet(isPresented: $showInterviewTypesList) {
                        ListHeaderView(headingTitle: ListHeadingTitles.interviewTypes.rawValue,
                                       showCloseButton: $showCloseButton,
                                       isInnerListHeader: .constant(false),
                                       showConfirmDeleteOrganization: .constant(false),
                                       membersViewModel: membersViewModel,
                                       speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                                       backgroundClr: branding.outerHeaderBackgroundColor,
                                       addButtonAction: {_ in })
                        
                        Form {
                            List(interviewsViewModel.disclosureGroupSectionTitles, id: \.self) { sectionTitle in
                                InterviewDisclosureGroup(sectionTitle: sectionTitle, viewModel: interviewsViewModel) { selectedInterviewDetails in
                                    self.selectedCategory = sectionTitle
                                    self.selectedInterviewType = selectedInterviewDetails.InterviewType
                                    self.selectedPriesthoodOffice = selectedInterviewDetails.Office
                                                                
                                    showInterviewTypesList = false
                                    interviewsViewModel.authorizedLeaderAssociatedWithSelectedInterviewType = interviewsViewModel.getAuthorizedLeader(for: selectedInterviewDetails.InterviewType, in: sectionTitle)
                                    
                                    switch interviewsViewModel.getUnitType() {
                                    case UnitTypes.stake.stringValue:
                                        if interviewsViewModel.authorizedLeaderAssociatedWithSelectedInterviewType == interviewsViewModel.leadership.first {
                                            selectedAuthorizedLeader = LeadershipPositions.stakePresident.stringValue
                                            onlyBishopBranchOrStakePresident = true
                                        } else {
                                            showAuthorizedLeaderList = true
                                            onlyBishopBranchOrStakePresident = false
                                        }
                                    case UnitTypes.ward.stringValue:
                                        if interviewsViewModel.authorizedLeaderAssociatedWithSelectedInterviewType.dropLast() == interviewsViewModel.leadership.first ?? "" {
                                            selectedAuthorizedLeader = LeadershipPositions.bishop.stringValue
                                            onlyBishopBranchOrStakePresident = true
                                        } else {
                                            showAuthorizedLeaderList = true
                                            onlyBishopBranchOrStakePresident = false
                                        }
                                    case UnitTypes.branch.stringValue:
                                        if interviewsViewModel.authorizedLeaderAssociatedWithSelectedInterviewType == interviewsViewModel.leadership.first {
                                            selectedAuthorizedLeader = LeadershipPositions.branchPresident.stringValue
                                            onlyBishopBranchOrStakePresident = true
                                        } else {
                                            showAuthorizedLeaderList = true
                                            onlyBishopBranchOrStakePresident = false
                                        }
                                    default:
                                        showAuthorizedLeaderList = true
                                        onlyBishopBranchOrStakePresident = false
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .cornerRadius(15)
                            .environment(\.colorScheme, .light)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .environment(\.colorScheme, .light)
                    } // end sheet
                    .environment(\.colorScheme, .light)
                    
                    if selectedPriesthoodOffice.isEmpty {
                        Text(selectedInterviewType)
                            .customText(color: branding.contentTextColor,
                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 80,
                                        trailPad: 50,
                                        width: .infinity,
                                        alignment: .leading)
                            .lineLimit(4)
                            .minimumScaleFactor(0.7)
                            .multilineTextAlignment(.leading)
                            .frame(height: 80)
                            .fixedSize(horizontal: false, vertical: false)
                    } else {
                        Text(parseSelectedInterviewDetails(with: selectedPriesthoodOffice, selectedInterviewDetails: selectedInterviewType))
                            .customText(color: branding.contentTextColor,
                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 80,
                                        trailPad: 50,
                                        width: .infinity,
                                        alignment: .leading)
                            .lineLimit(4)
                            .minimumScaleFactor(0.7)
                            .multilineTextAlignment(.leading)
                            .frame(height: 80)
                            .fixedSize(horizontal: false, vertical: false)
                    }
                } // end vstack
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack {
                    Button {
                        if !onlyBishopBranchOrStakePresident {
                            showAuthorizedLeaderList.toggle()
                        }
                    } label: {
                        Label("Leader", systemImage: "person.badge.key.fill")
                            .multilineTextAlignment(.leading)
                            .font(branding.paragraphTextAndLinks_Semibold_17pt)
                            .foregroundColor(branding.labels)
                            .frame(width: 300, alignment: .leading)
                            .padding(.leading, 50)
                            .underline()
                          //  .frame(height: 20)
                    }
                    .sheet(isPresented: $showAuthorizedLeaderList) {
                        ListHeaderView(headingTitle: ListHeadingTitles.leaders.rawValue,
                                       showCloseButton: $showCloseButton,
                                       isInnerListHeader: .constant(false),
                                       showConfirmDeleteOrganization: .constant(false),
                                       membersViewModel: membersViewModel,
                                       speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                                       backgroundClr: branding.innerHeaderBackgroundColor,
                                       addButtonAction: {_ in })
                        .padding(.top, -140)
                        
                        Form {
                            List(interviewsViewModel.leadership, id: \.self) { leader in
                                LeadershipRow(leader: leader) { selectedLeader in
                                    selectedAuthorizedLeader = selectedLeader
                                    showAuthorizedLeaderList = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(15)
                            .environment(\.colorScheme, .light)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .environment(\.colorScheme, .light)
                    }
                    .environment(\.colorScheme, .light)
                    
                    Text(selectedAuthorizedLeader)
                        .customText(color: branding.contentTextColor,
                                    font: branding.paragraphTextAndLinks_Regular_17pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 25,
                                    trailPad: 0,
                                    width: 300,
                                    alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .frame(height: 80)
                } // end vstack
            } // end hstack
            .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button {
                    showDateTimePicker.toggle()
                } label: {
                    Label("Date/Time", systemImage: "calendar.badge.clock")
                        .multilineTextAlignment(.leading)
                        .font(branding.paragraphTextAndLinks_Semibold_17pt)
                        .foregroundColor(branding.labels)
                        .frame(width: 300, alignment: .leading)
                        .padding(.leading, 50)
                }
                
                if showDateTimePicker {
                    DatePicker(selection: $currentTime) {}
                        .frame(width: 300, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.bottom, -140)
                        .onChange(of: currentTime, perform: { newValue in
                            let formattedDateTime = formatDate(currentTime: currentTime)
                            selectedDate = formattedDateTime.date
                            selectedTime = formattedDateTime.time
                            
                            if validateInterview() {
                                interviewIsValid = true
                            }
                        })
                }
            }

            if interviewIsValid {
                Button {
                    interviewsViewModel.isShowingAddInterviewView = false
                    interviewsViewModel.showAddInterviewView = false
                    
                    let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
                    
                    let interview = Interview(id: id, uid: id, name: selectedMember, ldrAssignToDoInterview: selectedAuthorizedLeader, scheduledInterviewDate: selectedDate, scheduledInterviewTime: selectedTime, notes: "", details: selectedInterviewType, ordination: selectedPriesthoodOffice, status: "Interview Scheduled", category: selectedCategory)
                    
                    addInterview(interview: interview)
                    
                    addOrdination(ordination: Ordination(id: interview.id, uid: interview.id ?? UUID().uuidString, name: interview.name, ordinationOffice: interview.ordination, status: interview.status, datePerformed: ""))
                    
                  //  dismiss()
                } label: {
                    Label("Add interview for \(selectedMember) on \(selectedDate) at \(selectedTime)", systemImage: "") // badge.plus.radiowaves.forward
                        .font(branding.paragraphTextAndLinks_Semibold_17pt)
                        .foregroundColor(branding.nonDestructiveButton)
                        .padding([.leading, .trailing], 40)
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 15).stroke(branding.nonDestructiveButton, lineWidth: 1))
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 30)
            } // end if
        } // end vstack
        .onDisappear {
            interviewsViewModel.showAddInterviewView = false
        }
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .frame(maxWidth: .infinity)
        .padding(.top, 0)
    }
    
    func parseSelectedInterviewDetails(with selectedOffice: String, selectedInterviewDetails: String) -> String {
        var resultsString = ""
        
        if InterviewTypeDetails.ordainNewMaleConvertToAPH.stringValue.contains(selectedInterviewDetails) {
            resultsString = selectedInterviewDetails + ", office of \(selectedOffice)"
        } else if InterviewTypeDetails.recommendManToBeOrdainedElderOrHighPriest.stringValue.contains(selectedInterviewDetails) || InterviewTypeDetails.authorizeOfficeOfElderOrHighPriestOrdination.stringValue.contains(selectedInterviewDetails) {
            resultsString = selectedInterviewDetails.replacingOccurrences(of: "an elder or high priest", with: " a " + selectedOffice)
        } else if InterviewTypeDetails.authorizeOfficeOfDeaconTeacherOrdination.stringValue.contains(selectedInterviewDetails) {
            resultsString = selectedInterviewDetails.replacingOccurrences(of: "deacon, teacher or priest", with: selectedOffice)
        }
        
        return resultsString
    }
    
    func addInterview(interview: Interview) {
        interviewsViewModel.addInterviewDocument(interview: interview) {
            if let id = interview.id {
                CoreDataManager.shared.addInterview(interviewModel: interview, id: id) { results in
                    if results.contains("Success") {
                        interviewsViewModel.fetchData {
                            interviewsViewModel.interviews = interviewsViewModel.sortInterviews()
                        }
                    }
                }
            }
        }
    }
    
    func addOrdination(ordination: Ordination) {
        OrdinationsViewModel.shared.addOrdination(ordination: ordination)
    }
        
    func validateInterview() -> Bool {
        if !selectedMember.isEmpty && selectedInterviewType != "" && !selectedDate.isEmpty && !selectedAuthorizedLeader.isEmpty && selectedMember != "No Member Selected" && selectedInterviewType != "No Interview Type Selected" && selectedAuthorizedLeader != "No Leader Selected"{
            return true
        }
        
        return false
    }
}

struct InterviewDisclosureGroup: View {
    @Environment(\.branding) var branding
    
    @ObservedObject var viewModel: InterviewsViewModel
    
    @State private var forOrdinances: Bool = false
    @State private var isExpanded = false
    
    var sectionTitle = ""
    var selectInterviewTypeAction: ((InterviewType: String, Office: String)) -> Void
    
    init(sectionTitle: String = "",
         viewModel: InterviewsViewModel,
         forOrdinances: Bool = false,
         selectInterviewTypeAction: @escaping ((InterviewType: String, Office: String)) -> Void) {
        self.sectionTitle = sectionTitle
        self.viewModel = viewModel
        self.forOrdinances = forOrdinances
        self.selectInterviewTypeAction = selectInterviewTypeAction
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded,
            content: {
                ForEach(Array(viewModel.setInterviewDetailsData(for: sectionTitle).enumerated()), id: \.offset) { (index, interview) in
                    Button {
                        if !interview.showOffice {
                            selectInterviewTypeAction((interview.parsedInterviewType, ""))
                        }
                    } label: {
                        if sectionTitle == interview.category {
                            Text(" " + interview.parsedInterviewType)
                                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                            font: branding.paragraphTextAndLinks_Regular_17pt,
                                            btmPad: 0,
                                            topPad: 0,
                                            leadPad: 0,
                                            trailPad: 0,
                                            width: .infinity,
                                            alignment: .leading)
                                .contentShape(Rectangle())
                                .listRowSeparatorTint(.clear)
                            
                            if interview.showOffice {
                                HStack {
                                    Text("Office")
                                        .customText(color: branding.labels,
                                                    font: branding.paragraphTextAndLinks_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 60,
                                                    trailPad: 0,
                                                    width: .infinity,
                                                    alignment: .leading)
                                        .contentShape(Rectangle())
                                        .listRowSeparatorTint(.clear)
                                    RadioButtonGroupsView(callback: { selected in
                                         selectInterviewTypeAction((interview.parsedInterviewType, selected))

                                    }, groupType: (priesthood: interview.priesthood, office: interview.office), forOrdinances: $forOrdinances, forPreLogin: .constant(false),
                                                          layoutHorizontal: false)
                                    .environment(\.colorScheme, .light)
                                }
                                .onAppear {
                                    forOrdinances = true
                                }
                                .padding()
                            }
                        }
                    }
                    .environment(\.colorScheme, .light)
                }
            },
            label: {
                DisclosureGroupLabelWithChevronsView(sectionTitle: sectionTitle,
                    showExpansionChevrons: false,
                    isExpanded: $isExpanded)
            }
        )
        .environment(\.colorScheme, .light)
    }
}

struct LeadershipRow: View {
    @Environment(\.branding) var branding
    
    var leader: String
    var selectLeaderAction: (String) -> Void
    
    var body: some View {
        Button {
            selectLeaderAction(leader)
        } label: {
            Text(leader)
                .customText(color: branding.contentTextColor,
                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
                .contentShape(Rectangle())
                .listRowSeparatorTint(.clear)
                .environment(\.colorScheme, .light)
        }
    }
}
