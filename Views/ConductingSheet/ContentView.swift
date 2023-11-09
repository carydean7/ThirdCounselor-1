//
//  ContentView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/31/23.
//

import SwiftUI

enum SheetTypes {
    case members
    case hymns
    case leaders
    case none
}

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var viewModel: ConductingSheetViewModel
    
    @State private var showPresidingAuthorityList = false
    @State private var isSheet: Bool = false
    @State private var upperFraction: CGFloat = 0.5
    @State private var lowerFraction: CGFloat = 0.5
    
    @Binding var showHymnsList: Bool
    @Binding var showMembersList: Bool
    @Binding var isUpperContent: Bool
    
    var showListTapGestureAction: (SheetTypes) -> Void
    var upperContent: Bool
    
    public init(viewModel: ConductingSheetViewModel,
                upperContent: Bool,
                showHymnsList: Binding<Bool>,
                showMembersList: Binding<Bool>,
                isUpperContent: Binding<Bool>,
                showListTapGestureAction: @escaping (SheetTypes) -> Void,
                showPresidingAuthorityList: Bool = false,
                isSheet: Bool = false
    ) {
        self.showListTapGestureAction = showListTapGestureAction
        self._showHymnsList = showHymnsList
        self._showMembersList = showMembersList
        self._isUpperContent = isUpperContent
        self.viewModel = viewModel
        self.upperContent = upperContent
        self.showPresidingAuthorityList = showPresidingAuthorityList
        self.isSheet = isSheet
    }
    
    var body: some View {
        if isUpperContent {
            Text(viewModel.selectedConductingSheetSection.upperSectionContent ?? "")
                .customText(color: branding.contentTextColor,
                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
                .minimumScaleFactor(0.5)
                .frame(maxHeight: 400)
                .onAppear {
                    viewModel.memberListInConductingSheet = true
                }
                .onTapGesture {
                    showListTapGestureAction(.hymns)
                }
        } else {
            Text(viewModel.selectedConductingSheetSection.lowerSectionContent ?? "")
                .customText(color: branding.contentTextColor,
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
                .onTapGesture {
                    if viewModel.selectedConductingSheetSection.sheetSection == ConductingSectionsIndexes.welcome.rawValue {
                        showListTapGestureAction(.leaders)
                    } else {
                        if viewModel.selectedConductingSheetSection.sheetSection == ConductingSectionsIndexes.wardBusinessMoveIns.rawValue {
                            showListTapGestureAction(.none)
                        }
                        
                        showListTapGestureAction(.members)
                    }
                }
        }
    }
}
