//
//  LowerContentView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/31/23.
//

import SwiftUI

struct LowerContentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var viewModel: ConductingSheetViewModel
    
    @State private var showPresidingAuthorityList = false
    @State private var isSheet: Bool = false
    @State private var lowerFraction: CGFloat = 0.5
    
    @Binding var showMembersList: Bool
    
    var showListTapGestureAction: (Bool) -> Void
    
    public init(viewModel: ConductingSheetViewModel,
                showMembersList: Binding<Bool>,
                showListTapGestureAction: @escaping (Bool) -> Void,
                showPresidingAuthorityList: Bool = false,
                isSheet: Bool = false
    ) {
        self.showListTapGestureAction = showListTapGestureAction
        self._showMembersList = showMembersList
        self.viewModel = viewModel
        self.showPresidingAuthorityList = showPresidingAuthorityList
        self.isSheet = isSheet
    }
    
    var lowerEditButton: some View {
        Button {
            handleLowerTapGesture(for: viewModel.selectedConductingSheetSection.sheetSection) { showList in
                showListTapGestureAction(showList)
            }
        } label: {
            Label("Eddit", systemImage: "pencil")
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
    
    var body: some View {
        HStack {
            Text(viewModel.selectedConductingSheetSection.lowerSectionContent ?? "")
                .customText(color: .red/*branding.contentTextColor*/,
                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
                .minimumScaleFactor(0.5)
                .frame(maxHeight: 100)
                .onAppear {
                    viewModel.setConductingSheetSection()
                    viewModel.memberListInConductingSheet = true
                }
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
            
            if viewModel.selectedConductingSheetSection.sheetSection != ConductingSectionsIndexes.wardBusinessMoveIns.rawValue || viewModel.selectedConductingSheetSection.sheetSection != ConductingSectionsIndexes.wardBusinessReleases.rawValue || viewModel.selectedConductingSheetSection.sheetSection != ConductingSectionsIndexes.wardBusinessSustainings.rawValue || viewModel.selectedConductingSheetSection.sheetSection != ConductingSectionsIndexes.wardBusinessOrdinations.rawValue {
                    lowerEditButton
//                Button {
//                    handleLowerTapGesture(for: viewModel.selectedConductingSheetSection.sheetSection) { showList in
//                        showListTapGestureAction(showList)
//                    }
//                } label: {
//                    Label("Edit", systemImage: "pencil")
//                        .multilineTextAlignment(.leading)
//                        .frame(maxWidth: 125, alignment: .trailing)
//                        .padding()
//                        .underline()
//                        .font(branding.paragraphTextAndLinks_Semibold_17pt)
//                        .foregroundColor(branding.destructiveButton)
//                }
//                .frame(maxWidth: 125, alignment: .trailing)
//                .padding(.bottom, 40)
//                .padding(.trailing, 0)
            }
        }
    }
    
    func handleLowerTapGesture(for section: Int, shouldShowList: @escaping (Bool) -> Void) {
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
            
            showMembersList = false
            
        case ConductingSectionsIndexes.closingHymn.rawValue:
            viewModel.selectedConductingSheetSection.lowerSectionContent = Constants.ConductingSheetContents.Lower.closeHymnBenediction
            
            showMembersList = true
            
        default:
            break
        }
    }
}
