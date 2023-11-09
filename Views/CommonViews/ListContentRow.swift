//
//  ListContentRow.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/6/23.
//

import SwiftUI

struct ListContentRow: View {
    @Environment(\.branding) var branding
    
    @State private var primaryFont: Font
    @State private var secondaryFont: Font
    @State private var bottomPadding: CGFloat
    @State private var topPadding: CGFloat
    @State private var leadingPadding: CGFloat
    @State private var trailingPadding: CGFloat
    
    @Binding var alignRowsInHStack: Bool
    
    var contents: [String]
    var rowContentIsRecommendations: Bool
    
    init(contents: [String] = [String](),
         primaryFont: Font = Branding.mock.paragraphTextAndLinks_Semibold_17pt,
         secondaryFont: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt,
         bottomPadding: CGFloat = 5.0,
         topPadding: CGFloat = 0.0,
         leadingPadding: CGFloat = 20.0,
         trailingPadding: CGFloat = 20.0,
         rowContentIsRecommendations: Bool,
         alignRowsInHStack: Binding<Bool>) {
        self.contents = contents
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
        self.bottomPadding = bottomPadding
        self.topPadding = topPadding
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        self.rowContentIsRecommendations = rowContentIsRecommendations
        self._alignRowsInHStack = alignRowsInHStack
    }
    
    var body: some View {
        VStack {
            if alignRowsInHStack {
                HStack(spacing: 60) {
                    ForEach(contents, id: \.self) { content in
                        Text(content)
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: secondaryFont,
                                        btmPad: bottomPadding,
                                        topPad: topPadding,
                                        leadPad: leadingPadding,
                                        trailPad: trailingPadding,
                                        width: .infinity,
                                        alignment: .leading)
//                            .if(rowContentIsRecommendations) { view in
//                                view.italic()
//                            }
                    }
                }
            } else {
                ForEach(contents, id: \.self) { content in
                    Text(content)
                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                    font: secondaryFont,
                                    btmPad: bottomPadding,
                                    topPad: topPadding,
                                    leadPad: leadingPadding,
                                    trailPad: trailingPadding,
                                    width: .infinity,
                                    alignment: .leading)
                }
            }
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
            case .phone:
                primaryFont = branding.primaryListRow_Body_23pt
                secondaryFont = branding.secondaryListRow_Callout_22pt
            default:
                break
            }
        }
    }
}
