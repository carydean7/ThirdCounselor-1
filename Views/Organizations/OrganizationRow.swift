//
//  OrganizationRow.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 3/16/23.
//

import SwiftUI

struct OrganizationRow: View {
    @Environment(\.branding) var branding

    @State private var font: Font

    var organization: Organization
    
    init(font: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt, organization: Organization) {
        self.font = font
        self.organization = organization
    }

    var body: some View {
        VStack {
            Text(organization.name)
                .customText(color: branding.contentTextColor,
                            font: font,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                font = branding.paragraphTextAndLinks_Semibold_17pt
            case .phone:
                font = branding.paragraphTextAndLinks_Regular_17pt
            default:
                break
            }
        }
    }
}
