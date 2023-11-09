//
//  ActionButton.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/23/23.
//

import SwiftUI

struct ActionButton: View {
    @Environment(\.branding) var branding

    @State private var buttonTitle = ""
    @State private var actionType: ActionTypes = .recommendationApproved
    @State private var topPadding: CGFloat = 0.0
    @State private var bottomPadding: CGFloat = 0.0
    @State private var leadingPadding: CGFloat = 0.0
    @State private var trailingPadding: CGFloat = 0.0
    
    @Binding var bishopBranchStakePresidentOnly: Bool
    @Binding var showLeaders: Bool
    
    var color: Color
    var font: Font
    var nextActionTypeMessage: String
    var itemIndex: Int
    var actionHandler: (Int) -> Void
    
    public init(branding: Branding,
                buttonTitle: String,
                actionType: ActionTypes = .noFurtherActionRequired,
                topPadding: CGFloat = 0.0,
                bottomPadding: CGFloat = 0.0,
                leadingPadding: CGFloat = 0.0,
                trailingPadding: CGFloat = 0.0,
                bishopBranchStakePresidentOnly: Binding<Bool>,
                showLeaders: Binding<Bool>,
                color: Color,
                font: Font,
                nextActionTypeMessage: String,
                itemIndex: Int,
                actionHandler: @escaping (Int) -> Void) {
        self.buttonTitle = buttonTitle
        self.actionType = actionType
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        self._bishopBranchStakePresidentOnly = bishopBranchStakePresidentOnly
        self._showLeaders = showLeaders
        self.color = color
        self.font = font
        self.nextActionTypeMessage = nextActionTypeMessage
        self.itemIndex = itemIndex
        self.actionHandler = actionHandler
    }

    var body: some View {
        Button {
            /* intentionally unimplemented */
        } label: {
            Text(buttonTitle)
                .customText(color: .white,
                            font: branding.formControlsButtonsTextInputs_Semibold_17pt,
                            btmPad: bottomPadding,
                            topPad: topPadding,
                            leadPad: leadingPadding,
                            trailPad: trailingPadding,
                            width: 120,
                            alignment: .center)
        }
        .customButton(color: color, font: font)
        .onTapGesture {
            print("pressed this button")
            actionHandler(itemIndex)
        }
    }
}

//struct ActionButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ActionButton()
//    }
//}
