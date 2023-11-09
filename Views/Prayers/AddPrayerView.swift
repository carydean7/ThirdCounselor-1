//
//  AddPrayerView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/24/23.
//

import SwiftUI

struct AddPrayerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding

    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var viewModel: PrayersViewModel

    @State private var headingTitle = ListHeadingTitles.addPrayer.rawValue
    @State private var showCloseButton: Bool = true
    @State private var showMemberListing = false
    @State private var date = NSDate()
    @State private var showAddItemButton = false
    @State private var selectedMemberForInvocation = "No member selected for invocation"
    @State private var selectedMemberForBenediction = "No member selected for benediction"
    @State private var selectedSunday = "No Sunday Selected"
    @State private var sundaySelected = false
    @State private var selectASunday = false
    @State private var memberSelectedForInvocation = false
    @State private var memberSelectedForBenediction = false
    @State private var validationSucceeded = true
    @State private var primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt
    @State private var secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt
    @State private var showMembersListForInvocation = false
    @State private var showMembersListForBenediction = false
    @State private var closeButtonTrailingPadding: CGFloat = 0.0
    @State private var selectedPrayerType: String = ""
    @State private var sundays = [String]()
    @State private var currentDate = Date()
    @State private var forOrdinances: Bool = false
    @State private var showEditButton: Bool = false
    
    var addPrayersActionHandler: ([Prayer]) -> Void
    
    @Binding var currentInvocation: String
    @Binding var currentBenediction: String

    public init(sundays: [String] = [String](),
                selectedSunday: String = "No Sunday Selected",
                headingTitle: String = "",
                closeButtonTrailingPadding: CGFloat = 0.0,
                showCloseButton: Bool = true,
                showMembersListForInvocation: Bool = false,
                showMembersListForBenediction: Bool = false,
                forOrdinances: Bool = false,
                showEditButton: Bool = false,
                date: Date = Date(),
                membersViewModel: MembersViewModel,
                viewModel: PrayersViewModel,
                showAddItemButton: Bool = false,
                selectedMemberForInvocation: String = "No member selected for invocation",
                selectedMemberForBenediction: String = "No member selected for benediction",
                selectASunday: Bool = false,
                memberSelectedForInvocation: Bool = false,
                memberSelectedForBenediction: Bool = false,
                validationSucceeded: Bool = true,
                selectedPrayerType: String = "",
                currentInvocation: Binding<String>,
                currentBenediction: Binding<String>,
                addPrayersActionHandler: @escaping ([Prayer]) -> Void) {
        self.membersViewModel = membersViewModel
        self.addPrayersActionHandler = addPrayersActionHandler
        self.viewModel = viewModel
        self._currentInvocation = currentInvocation
        self._currentBenediction = currentBenediction
        self.headingTitle = headingTitle
        self.closeButtonTrailingPadding = closeButtonTrailingPadding
        self.showCloseButton = showCloseButton
        self.showMembersListForInvocation = showMembersListForInvocation
        self.memberSelectedForBenediction = memberSelectedForBenediction
        self.forOrdinances = forOrdinances
        self.showEditButton = showEditButton
        self.date = date as NSDate
        self.showAddItemButton = showAddItemButton
        self.selectedMemberForInvocation = selectedMemberForInvocation
        self.selectedMemberForBenediction = selectedMemberForBenediction
        self.selectedSunday = selectedSunday
        self.selectASunday = selectASunday
        self.memberSelectedForInvocation = memberSelectedForInvocation
        self.memberSelectedForBenediction = memberSelectedForBenediction
        self.validationSucceeded = validationSucceeded
        self.selectedPrayerType = selectedPrayerType
        self.sundays = sundays
        self.selectedSunday = selectedSunday
    }

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 20)
            VStack(alignment: .center, spacing:20) {
                HStack(alignment: .center, spacing: 40) {
                    Button {
                        showMembersListForInvocation.toggle()
                    } label: {
                        Label("Select Member for Invocation", systemImage: "person.3.fill")
                            .font(primaryFont)
                            .foregroundColor(branding.labels)
                            .underline()
                    }
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $showMembersListForInvocation) {
                        MembersListView(membersViewModel: membersViewModel,
                                        orgMbrCallingViewModel: OrgMbrCallingViewModel.shared,
                                        speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                                        conductingSheetViewModel: ConductingSheetViewModel.shared,
                                        prayersViewModel: viewModel,
                                        showMembersList: $showMembersListForInvocation,
                                        forOrdinances: $forOrdinances,
                                        showEditButton: $showEditButton) { member in
                            selectedMemberForInvocation = member.name
                            memberSelectedForInvocation = true
                            showMemberListing = false
                        }
                    }
                    
                    Button {
                        showMembersListForBenediction.toggle()
                    } label: {
                        Label("Select Member for Benediction", systemImage: "person.3.fill")
                            .font(primaryFont)
                            .foregroundColor(branding.labels)
                            .underline()
                    }
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $showMembersListForBenediction) {
                        MembersListView(membersViewModel: membersViewModel,
                                        orgMbrCallingViewModel: OrgMbrCallingViewModel.shared,
                                        speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                                        conductingSheetViewModel: ConductingSheetViewModel.shared,
                                        prayersViewModel: viewModel,
                                        showMembersList: $showMembersListForBenediction,
                                        forOrdinances: $forOrdinances,
                                        showEditButton: $showEditButton) { member in
                            selectedMemberForBenediction = member.name
                            memberSelectedForBenediction = true
                            showMemberListing = false
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack(alignment: .center, spacing: 40) {
                    Text("Member: \($selectedMemberForInvocation.wrappedValue)")
                        .customText(color: branding.contentTextColor,
                                    font: secondaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                        .italic()
                    Text("Member: \($selectedMemberForBenediction.wrappedValue)")
                        .customText(color: branding.contentTextColor,
                                    font: secondaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .center)
                        .italic()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                    .frame(height: 20)

                Button {
                    membersViewModel.isSheet = false
                    membersViewModel.shouldShowCloseButon = false
                    currentInvocation = $selectedMemberForInvocation.wrappedValue
                    currentBenediction = $selectedMemberForBenediction.wrappedValue

                    viewModel.showAddPrayerView = false
                    
                    if !$selectedMemberForInvocation.wrappedValue.isEmpty || !$selectedMemberForBenediction.wrappedValue.isEmpty {
                        let invId = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"

                        let invocationPrayer = Prayer(uid: invId, name: selectedMemberForInvocation, date: convertToString(date: Date(), with: .short), type: "Invocation")
                        
                        let benId = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"

                        let benedictionPrayer = Prayer(uid: benId, name: selectedMemberForBenediction, date: convertToString(date: Date(), with: .short), type: "Benediction")

                        let prayers = [invocationPrayer, benedictionPrayer]
                        
                        addPrayer(prayers: prayers)
                        
                        addPrayersActionHandler(prayers)
                      //  dismiss()
                    }
                } label: {
                    Label("ADD PRAYER(s)", systemImage: "hands.sparkles.fill")
                        .font(primaryFont)
                        .foregroundColor(branding.nonDestructiveButton)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                    .frame(height: 20)
            }
        }
        .onDisappear {
            membersViewModel.isSheet = false
            viewModel.showAddPrayerView = false
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            viewModel.memberListInAddPrayersSheet = true
        }
    }
    
    func addPrayer(prayers: [Prayer]) {
        for prayer in prayers {
            viewModel.addPrayer(prayer: prayer) { results in
                viewModel.getCurrentOrNextPrayers {
                    viewModel.getMembersGivingCurrentOrNextSundaysPrayByType()
                }
            }
        }
    }
}
