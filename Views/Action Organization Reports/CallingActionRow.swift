//
//  CallingActionRow.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/20/23.
//

import SwiftUI

struct CallingActionRow: View {
    @Environment(\.branding) var branding

    var orgMbrCalling: OrgMbrCalling
    var primaryFont: Font
    var secondaryFont: Font
    
    var body: some View {
        Text(orgMbrCalling.callingName)
            .customText(color: branding.labels,
                        font: primaryFont,
                        btmPad: 0,
                        topPad: 0,
                        leadPad: 0,
                        trailPad: 0,
                        width: .infinity,
                        alignment: .leading)
        
        Text(orgMbrCalling.memberName)
            .customText(color: branding.contentTextColor,
                        font: secondaryFont,
                        btmPad: 5,
                        topPad: 0,
                        leadPad: 0,
                        trailPad: 0,
                        width: .infinity,
                        alignment: .leading)
    }
}
