//
//  MemberRow.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 3/16/23.
//

import SwiftUI

struct MemberRow: View {
    @ObservedObject var conductingSheetViewModel: ConductingSheetViewModel
    @ObservedObject var orgMbrCallingViewModel: OrgMbrCallingViewModel
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var prayersViewModel: PrayersViewModel
    
    @Environment(\.branding) var branding
    
    @Binding var expandRow: Bool
    @Binding var isSheet: Bool
    @Binding var newlyAssignedMember: String
    @Binding var showEditMemberRows: Bool
    
    @State private var callings: String
    @State private var primaryFont: Font
    @State private var secondaryFont: Font
    @State private var showAlert = false
    @State private var proceedWithMemberDeletion = false
    @State private var forOrdinances: Bool = false
    
    var selectMemberAction: (Member) -> Void
    var member: Member
    
    init(conductingSheetViewModel: ConductingSheetViewModel,
         orgMbrCallingViewModel: OrgMbrCallingViewModel,
         membersViewModel: MembersViewModel,
         prayersViewModel: PrayersViewModel,
         member: Member,
         newlyAssignedMember: Binding<String>,
         forOrdinances: Bool = false,
         expandRow: Binding<Bool>,
         isSheet: Binding<Bool>,
         showEditMemberRows: Binding<Bool>,
         callings: String,
         primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt,
         secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt,
         selectMemberAction: @escaping (Member) -> Void) {
        self.conductingSheetViewModel = conductingSheetViewModel
        self.orgMbrCallingViewModel = orgMbrCallingViewModel
        self.membersViewModel = membersViewModel
        self.prayersViewModel = prayersViewModel
        self.member = member
        self._newlyAssignedMember = newlyAssignedMember
        self.forOrdinances = forOrdinances
        self._expandRow = expandRow
        self._isSheet = isSheet
        self._showEditMemberRows = showEditMemberRows
        self.callings = callings
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.selectMemberAction = selectMemberAction
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                if !isSheet && !conductingSheetViewModel.memberListInConductingSheet && !prayersViewModel.memberListInAddPrayersSheet {
                    expandRow.toggle()
                }
                
                membersViewModel.currentlySelectedMember = member
                orgMbrCallingViewModel.selectedMember = member.name
                $callings.wrappedValue = getCallings(for: orgMbrCallingViewModel.selectedMember)
                selectMemberAction(member)
            } label: {
                if showEditMemberRows {
                    HStack {
                        Button {
                            showAlert = true
                        } label: {
                            Label("Delete Member", systemImage: "minus.circle.fill")
                                .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                        }
                        .alert("Are you sure you want to delete this member?", isPresented: $showAlert) {
                            Button("Yes", role: .destructive) {
                                membersViewModel.deleteMember(member: member)
                                showEditMemberRows.toggle()
                            }

                            Button("No", role: .cancel) {
                            }
                        }
                        .fontWeight(.regular)
                        .font(primaryFont)
                        .padding(.trailing, 60)

                        Text(member.name)
                            .customText(color: branding.contentTextColor,
                                        font: primaryFont,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .leading)
                            .contentShape(Rectangle())
                    }
                }
                else {
                    Text(member.name)
                        .customText(color: branding.contentTextColor,
                                    font: primaryFont,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .leading)
                        .contentShape(Rectangle())
                }

                if expandRow && !isSheet && !ConductingSheetViewModel.shared.memberListInConductingSheet && member.name == membersViewModel.currentlySelectedMember.name && !membersViewModel.isSheet {
                    HStack(spacing: 20) {
                        Text(callings)
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: -180,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .leading)
                            .contentShape(Rectangle())
                    }
                }
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
    
    func getCallings(for member: String) -> String {
        for  memberAndCallings in orgMbrCallingViewModel.membersAndTheirCallings {
            if memberAndCallings[DictionaryKeys.memberName.rawValue] == member {
                if let callings = memberAndCallings[DictionaryKeys.callingName.rawValue] {
                    return callings
                }
            }
        }
        
        return ""
    }
    
    func callingsForMember(name: String) -> String {
        var callings = ""
        for orgMbrCall in orgMbrCallingViewModel.orgMbrCallings {
            if orgMbrCall.memberName == name {
                callings += orgMbrCall.callingName + " : " + orgMbrCall.organizationName + " | "
            }
        }
        
        if callings.isEmpty {
            callings = "Member without Calling"
        }
        
        return callings
    }
}
