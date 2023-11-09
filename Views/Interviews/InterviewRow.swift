//
//  InterviewRow.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/4/23.
//

import SwiftUI

struct InterviewRow: View {
    @Environment(\.branding) var branding

    var model: Interview
    
    var body: some View {
        HStack(alignment: .center, spacing: 100) {
            Text(model.name)
                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                            font: branding.paragraphTextAndLinks_Regular_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 60,
                            trailPad: 0,
                            width: 150,
                            alignment: .leading)
            Text(model.details)
                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                            font: branding.paragraphTextAndLinks_Regular_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 100,
                            trailPad: 0,
                            width: 250,
                            alignment: .leading)
            Text(model.scheduledInterviewDate)
                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                            font: branding.paragraphTextAndLinks_Regular_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 40,
                            trailPad: 0,
                            width: 100,
                            alignment: .leading)
            Text(model.scheduledInterviewTime)
                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                            font: branding.paragraphTextAndLinks_Regular_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: -50,
                            trailPad: 0,
                            width: 100,
                            alignment: .leading)
            Text(model.ordination)
                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                            font: branding.paragraphTextAndLinks_Regular_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 30,
                            trailPad: 0,
                            width: 100,
                            alignment: .leading)
        }
    }
}

struct InterviewRow_Previews: PreviewProvider {
    static var previews: some View {
        InterviewRow(model: Interview(uid: "", name: "Bill Smith", ldrAssignToDoInterview: "Dean Wagstaff", scheduledInterviewDate: "08/06/23", scheduledInterviewTime: "11:30am", notes: "", details: "Temple Recommend", ordination: "", status: "pending", category: InterviewCategories.recommend.rawValue))
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
            .previewDisplayName("iPhone 13 mini")
        
        InterviewRow(model: Interview(uid: "", name: "Bill Smith", ldrAssignToDoInterview: "Dean Wagstaff", scheduledInterviewDate: "08/06/23", scheduledInterviewTime: "11:30am", notes: "", details: "Temple Recommend", ordination: "", status: "pending", category: InterviewCategories.recommend.rawValue))
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Pro 11-inch 4th Generation")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
