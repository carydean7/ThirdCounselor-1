//
//  PresidingAuthorityListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/31/23.
//

import SwiftUI

struct PresidingAuthorityListView: View {
    @Environment(\.branding) var branding
    
    @State private var selectMemberAction: (String) -> Void
    @State private var showCloseButton: Bool = true
    
    @Binding var isSheet: Bool
    
    init(/*showConfirmDeleteOrganization: Bool = false,*/
         isSheet: Binding<Bool>,
         selectMemberAction: @escaping (String) -> Void) {
        _isSheet = isSheet
        self.selectMemberAction = selectMemberAction
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.presidingAuthorities.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })
            
            List(LeadersPresidingAtSacrament.allCases, id: \.id) { leader in
                Button {
                    isSheet = true
                    selectMemberAction(leader.rawValue)
                } label: {
                    Text(leader.stringValue)
                        .customText(color: branding.destructiveButton,
                                    font: branding.pageAndModalTitle_Regular_17pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .leading)
                }
            }
            .environment(\.colorScheme, .light)
        }
    }
}
