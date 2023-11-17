//
//  HymnRow.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/15/23.
//

import SwiftUI

struct HymnRow: View {
    @EnvironmentObject var model: HymnsViewModel

    @Environment(\.branding) var branding

  //  @Binding var isSheet: Bool
    
    @State private var font: Font = Branding.mock.primaryListRow_Body_23pt
    
    var selectedHymnAction: ((title: String, number: String)) -> Void
    var hymn: Hymn
    
    init(hymn: Hymn,
         selectedHymnAction: @escaping ((title: String, number: String)) -> Void) {
        self.hymn = hymn
        self.selectedHymnAction = selectedHymnAction
    }
    
    var body: some View {
        HStack {
            Button {
                model.isSheet = true
                selectedHymnAction((title: hymn.title, number: hymn.number))
            } label: {
                HStack(spacing: 20) {
                    Text(hymn.title)
                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                    font: branding.paragraphTextAndLinks_Regular_17pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: 0,
                                    trailPad: 0,
                                    width: .infinity,
                                    alignment: .leading)
                        .contentShape(Rectangle())
                    
                    Text(hymn.number)
                        .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                    font: branding.paragraphTextAndLinks_Regular_17pt,
                                    btmPad: 0,
                                    topPad: 0,
                                    leadPad: -160,
                                    trailPad: 20,
                                    width: 60,
                                    alignment: .trailing)
                        .contentShape(Rectangle())
                }
            }
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                font = branding.secondaryListRow_iPad_Title2_28pt
            case .phone:
                font = branding.primaryListRow_Body_23pt
            default:
                break
            }
        }
    }
}
