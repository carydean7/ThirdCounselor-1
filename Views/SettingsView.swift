//
//  SettingsView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/21/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.branding) var branding

    @State private var showCloseButton = false
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.settings.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: MembersViewModel.shared,
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                           backgroundClr: branding.outerHeaderBackgroundColor,
                           addButtonAction: {_ in })

            Button {
                
            } label: {
                Text("Logout")
                    .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                font: branding.pageAndModalTitle_Regular_17pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 40,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .leading)
            }
            
            Button {
                
            } label: {
                Text("Reset Password")
                    .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                font: branding.pageAndModalTitle_Regular_17pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 40,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .leading)
            }
            
            Divider()
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
