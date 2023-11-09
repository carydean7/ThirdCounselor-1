//
//  Branding.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/20/23.
//

import Foundation
import SwiftUI

@available(iOS 13, *)
public struct Branding {
    public let primaryListRow_Body_23pt: Font
    public let primaryListRow_iPad_Title_34pt: Font
    public let secondaryListRow_Callout_22pt: Font
    public let secondaryListRow_iPad_Title2_28pt: Font
    public let rowLabel_Caption_18pt: Font
    public let rowLabel_iPad_Subhead_21pt: Font
    public let screenTitle_Title_34pt: Font
    public let screenTitle_iPad_LargeTitle_40pt: Font
    public let screenSubTitle_Title2_28pt: Font
    public let screenSubTitle_iPad_Title_34pt: Font
    public let pageAndModalTitle_Semibold_17pt: Font
    public let pageAndModalTitle_Regular_17pt: Font
    public let paragraphTextAndLinks_Semibold_17pt: Font
    public let paragraphTextAndLinks_Regular_17pt: Font
    public let secondaryText_Regular_17pt: Font
    public let tertiaryTextCaptionsSegmentButtons_Regular_13pt: Font
    public let formControlsButtonsTextInputs_Semibold_17pt: Font
    public let tabbarActionBar_Regular_11pt: Font
    
    public let isSheet: Bool
    
    public let backgroundColor: Color
    public let outerHeaderBackgroundColor: Color
    public let innerHeaderBackgroundColor: Color
    public let contentTextColor: Color
    public let labels: Color
    public let listSectionBackground: Color
    public let nonDestructiveButton: Color
    public let destructiveButton: Color
    public let navListAccentOr4GroundTextLiteBlueColor: Color
    
    public init(
        primaryListRow_Body_23pt: Font,
        primaryListRow_iPad_Title_34pt: Font,
        secondaryListRow_Callout_22pt: Font,
        secondaryListRow_iPad_Title2_28pt: Font,
        rowLabel_Caption_18pt: Font,
        rowLabel_iPad_Subhead_21pt: Font,
        screenTitle_Title_34pt: Font,
        screenTitle_iPad_LargeTitle_40pt: Font,
        screenSubTitle_Title2_28pt: Font,
        screenSubTitle_iPad_Title_34pt: Font,
        pageAndModalTitle_Semibold_17pt: Font,
        pageAndModalTitle_Regular_17pt: Font,
        paragraphTextAndLinks_Semibold_17pt: Font,
        paragraphTextAndLinks_Regular_17pt: Font,
        secondaryText_Regular_17pt: Font,
        tertiaryTextCaptionsSegmentButtons_Regular_13pt: Font,
        formControlsButtonsTextInputs_Semibold_17pt: Font,
        tabbarActionBar_Regular_11pt: Font,
        isSheet: Bool,
        backgroundColor: Color,
        outerHeaderBackgroundColor: Color,
        navListAccentOr4GroundTextLiteBlueColor: Color,
        innerHeaderBackgroundColor: Color,
        contentTextColor: Color,
        labels: Color,
        listSectionBackground: Color,
        nonDestructiveButton: Color,
        destructiveButton: Color
    ) {
        self.primaryListRow_Body_23pt = primaryListRow_Body_23pt
        self.primaryListRow_iPad_Title_34pt = primaryListRow_iPad_Title_34pt
        self.secondaryListRow_Callout_22pt = secondaryListRow_Callout_22pt
        self.secondaryListRow_iPad_Title2_28pt = secondaryListRow_iPad_Title2_28pt
        self.rowLabel_Caption_18pt = rowLabel_Caption_18pt
        self.rowLabel_iPad_Subhead_21pt = rowLabel_iPad_Subhead_21pt
        self.screenTitle_Title_34pt = screenTitle_Title_34pt
        self.screenTitle_iPad_LargeTitle_40pt = screenTitle_iPad_LargeTitle_40pt
        self.screenSubTitle_Title2_28pt = screenSubTitle_Title2_28pt
        self.screenSubTitle_iPad_Title_34pt = screenSubTitle_iPad_Title_34pt
        self.pageAndModalTitle_Semibold_17pt = pageAndModalTitle_Regular_17pt
        self.pageAndModalTitle_Regular_17pt = pageAndModalTitle_Regular_17pt
        self.paragraphTextAndLinks_Semibold_17pt = paragraphTextAndLinks_Semibold_17pt
        self.paragraphTextAndLinks_Regular_17pt = paragraphTextAndLinks_Regular_17pt
        self.secondaryText_Regular_17pt = secondaryText_Regular_17pt
        self.tertiaryTextCaptionsSegmentButtons_Regular_13pt = tertiaryTextCaptionsSegmentButtons_Regular_13pt
        self.formControlsButtonsTextInputs_Semibold_17pt = formControlsButtonsTextInputs_Semibold_17pt
        self.tabbarActionBar_Regular_11pt = tabbarActionBar_Regular_11pt
        self.isSheet = isSheet
        self.backgroundColor = backgroundColor
        self.navListAccentOr4GroundTextLiteBlueColor = navListAccentOr4GroundTextLiteBlueColor
        self.outerHeaderBackgroundColor = outerHeaderBackgroundColor
        self.innerHeaderBackgroundColor = innerHeaderBackgroundColor
        self.contentTextColor = contentTextColor
        self.labels = labels
        self.listSectionBackground = listSectionBackground
        self.nonDestructiveButton = nonDestructiveButton
        self.destructiveButton = destructiveButton
    }
}

extension Branding {
    public static var mock: Self {
        Branding(
            primaryListRow_Body_23pt: Font.body,
            primaryListRow_iPad_Title_34pt: Font.title,
            secondaryListRow_Callout_22pt: Font.callout,
            secondaryListRow_iPad_Title2_28pt: Font.title2,
            rowLabel_Caption_18pt: Font.caption,
            rowLabel_iPad_Subhead_21pt: Font.subheadline,
            screenTitle_Title_34pt: Font.title,
            screenTitle_iPad_LargeTitle_40pt: Font.largeTitle,
            screenSubTitle_Title2_28pt: Font.title2,
            screenSubTitle_iPad_Title_34pt: Font.title,
            pageAndModalTitle_Semibold_17pt: Font.headline,
            pageAndModalTitle_Regular_17pt: Font.body,
            paragraphTextAndLinks_Semibold_17pt: Font.headline,
            paragraphTextAndLinks_Regular_17pt: Font.body,
            secondaryText_Regular_17pt: Font.body,
            tertiaryTextCaptionsSegmentButtons_Regular_13pt: Font.footnote,
            formControlsButtonsTextInputs_Semibold_17pt: Font.headline,
            tabbarActionBar_Regular_11pt: Font.caption2,
            isSheet: true,
            backgroundColor: Color("Background"),
            outerHeaderBackgroundColor: Color("OuterHeaderBackground"),
            navListAccentOr4GroundTextLiteBlueColor: Color("NavListAccentOr4GroundTextLiteBlue"),
            innerHeaderBackgroundColor: Color("InnerHeaderBackground"),
            contentTextColor: Color("Content"),
            labels: Color("Labels"),
            listSectionBackground: Color("ListSectionBackground"),
            nonDestructiveButton: Color("NonDestructiveButton"),
            destructiveButton: Color("DestructiveButton")
        )
    }
}

private struct BrandingKey: EnvironmentKey {
    static let defaultValue = Branding.mock
}

extension EnvironmentValues {
    public var branding: Branding {
        get { self[BrandingKey.self] }
        set { self[BrandingKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func branding(_ branding: Branding) -> some View {
        environment(\.branding, branding)
    }
}

#if canImport(UIKit)
import UIKit

// MARK: UIKit Compatibility
extension Branding {
    public init(
        primaryListRowFont: UIFont,
        secondaryListRowFont: UIFont,
        rowLabelFont: UIFont,
        screenTitleFont: UIFont,
        primaryListRowFontiPad: Font,
        secondaryListRowFontiPad: Font,
        screenTitleFontiPad: Font,
        screenSubTitleFontiPad: Font,
        rowLabelFontiPad: Font,
        isSheet: Bool,
        lightBlueColor: UIColor,
        darkBlueColor: UIColor
    ) {
        self.init(
            primaryListRowFont: primaryListRowFont,
            secondaryListRowFont: secondaryListRowFont,
            rowLabelFont: rowLabelFont,
            screenTitleFont: screenTitleFont,
            primaryListRowFontiPad: primaryListRowFontiPad,
            secondaryListRowFontiPad: secondaryListRowFontiPad,
            screenTitleFontiPad: screenTitleFontiPad,
            screenSubTitleFontiPad: screenSubTitleFontiPad,
            rowLabelFontiPad: rowLabelFontiPad,
            isSheet: isSheet,
            lightBlueColor: UIColor(Color(lightBlueColor)),
            darkBlueColor: UIColor(Color(darkBlueColor))
        )
    }
}
#endif


