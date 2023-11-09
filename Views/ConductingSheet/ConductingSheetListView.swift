//
//  ConductingSheetListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/6/23.
//

import SwiftUI

struct ConductingSheetListView: View {
    @StateObject var viewModel: ConductingSheetViewModel = ConductingSheetViewModel.shared
    
    @Environment(\.branding) var branding
    
    @State private var showCloseButton: Bool = true
    @State private var forgroundColor: Color = Branding.mock.nonDestructiveButton
    @State private var backgroundColor: Color = Branding.mock.destructiveButton
    @State private var selectedSheetIndex: Int? = 0
//    @State private var showConfirmDeleteOrganization: Bool = false

    init(showCloseButton: Bool = false,
//         showConfirmDeleteOrganization: Bool = false,
         selectedSheetIndex: Int? = 0) {
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.forgroundColor = forgroundColor
        self.backgroundColor = backgroundColor
        self.selectedSheetIndex = selectedSheetIndex
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.conductingSheet.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })
            
            NavigationView {
                List(0 ..< ConductingSectionsTitles.allCases.count) { section in
                    NavigationLink(destination: ConductingSheetView(selectedSheetIdx: $selectedSheetIndex,
                                                                    selectedSheetSection: section,
                                                                    addAnnouncementButtonTapped: .constant(false),
                                                                    selectConductingSheetSectionAction: { sectionIndex in
                        if let selectedSheetIndex = selectedSheetIndex {
                            viewModel.selectedConductingSheetIndex = selectedSheetIndex
                            viewModel.selectedConductingSheetSection = viewModel.conductingSheetSections[selectedSheetIndex]
                        }
                    }), tag: section, selection: $selectedSheetIndex) {
                        if section == self.$selectedSheetIndex.wrappedValue {
                            Text(viewModel.conductingSheetSections[section].sectionTitle ?? "")
                                .customText(color: branding.outerHeaderBackgroundColor,
                                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                                            btmPad: 0,
                                            topPad: 0,
                                            leadPad: 0,
                                            trailPad: 0,
                                            width: .infinity,
                                            alignment: .leading)
                        } else {
                            Text(viewModel.conductingSheetSections[section].sectionTitle ?? "")
                                .customText(color: branding.destructiveButton,
                                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                                            btmPad: 0,
                                            topPad: 0,
                                            leadPad: 0,
                                            trailPad: 0,
                                            width: .infinity,
                                            alignment: .leading)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listRowSeparator(.hidden)
            }
            .cornerRadius(25.0)
            .padding(.top, 65)
            .padding(.bottom, 100)
            .padding([.leading, .trailing], 10)
        }
        .onAppear {
            if let selectedSheetIndex = selectedSheetIndex {
                viewModel.selectedConductingSheetIndex = selectedSheetIndex
                viewModel.selectedConductingSheetSection = viewModel.conductingSheetSections[selectedSheetIndex]
            }
        }
        .environmentObject(viewModel)
    }
}

struct ConductingSheetListView_Previews: PreviewProvider {
    static var previews: some View {
        ConductingSheetListView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
            .previewDisplayName("iPhone 13 mini")
        
        ConductingSheetListView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Pro 11-inch 4th Generation")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
