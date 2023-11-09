//
//  SearchSectionHeaderView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/3/23.
//

import SwiftUI

struct SearchSectionHeaderView: View {
    @Environment(\.branding) var branding

    let text: String
    
    var body: some View {
        Rectangle()
            .fill(branding.backgroundColor)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .overlay(
                Text(text)
                    .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                font: branding.rowLabel_iPad_Subhead_21pt,
                                btmPad: 15,
                                topPad: 15,
                                leadPad: 17,
                                trailPad: 17,
                                width: 80,
                                alignment: .leading)
                    .fontWeight(.semibold),
//                    .frame(maxWidth: nil, maxHeight: nil, alignment: .leading),
                alignment: .leading
            )
    }
}

//struct SearchSectionHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchSectionHeaderView()
//    }
//}
