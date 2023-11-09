//
//  InfoListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/28/23.
//

import SwiftUI

struct InfoListView: View {
    @Environment(\.branding) var branding

    @ObservedObject var viewModel: InfoViewModel
    
//    @State private var showConfirmDeleteOrganization = false
    @State private var showCloseButton = false
    
    var sectionTitle = ""
    
    init(sectionTitle: String = "",
         viewModel: InfoViewModel) {
        self.sectionTitle = sectionTitle
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ListHeaderView(headingTitle: ListHeadingTitles.help.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: MembersViewModel.shared,
                           backgroundClr: branding.outerHeaderBackgroundColor,
                           addButtonAction: {_ in })
            
            ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: ["\t**SCREENS**"])

            NavigationView {
                List(viewModel.contents, id: \.self) { content in
                    InfoListGroup(content: content)
                        .listRowSeparator(.hidden)
                }
                .cornerRadius(25)
                .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                .listStyle(.insetGrouped)
            }
            .cornerRadius(25.0)
            .navigationViewStyle(StackNavigationViewStyle())
            .padding([.leading, .trailing], 10)
            .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
        }
        .onAppear {
            viewModel.fetchData {
            }
        }
        .cornerRadius(25.0)
        .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
        .environment(\.colorScheme, .light)
    }
}

struct InfoListGroup: View {
    @Environment(\.branding) var branding
    
    @State private var isExpanded = false
    @State private var index = 0
    
    var content: Info
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded,
                        content: {
            ListContentRow(contents: [content.instructions],
                           bottomPadding: 5,
                           topPadding: 0,
                           leadingPadding: 20,
                           trailingPadding: 20,
                           rowContentIsRecommendations: false,
                           alignRowsInHStack: .constant(false))
                .padding([.leading, .trailing], 20)
                .listRowSeparatorTint(.clear)
            
            Divider()
            
            ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: ["**FUNCTIONS**"])
            
            ForEach(content.functions) { infoFunction in
                ExpandedContentView(disclosureGroupLabel: infoFunction.topic,
                                    functions: infoFunction)
            }
        }, label: {
            Text(content.screen)
                .customText(color: branding.labels,
                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 0,
                            trailPad: 0,
                            width: .infinity,
                            alignment: .leading)
        })
        .cornerRadius(25.0)
    }
}

struct ExpandedContentView: View {
    @Environment(\.branding) var branding

    @State private var disclosureGroupLabel = ""
    @State private var isExpanded = false
    @State private var functions: Function

    init(disclosureGroupLabel: String = "",
         functions: Function = Function(id: "",
                                        uid: "",
                                        name: "",
                                        topic: "",
                                        steps: ""),
         isExpanded: Bool = false) {
        self.disclosureGroupLabel = disclosureGroupLabel
        self.functions = functions
        self.isExpanded = isExpanded
    }

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded,
                        content: {
            ContentHeaderView(hstackSpacing: CGFloat(60), headingTitles: ["**STEPS**"])

                ListContentRow(contents: [functions.steps],
                               bottomPadding: 5,
                               topPadding: 0,
                               leadingPadding: 20,
                               trailingPadding: 20,
                               rowContentIsRecommendations: false,
                               alignRowsInHStack: .constant(false))
                    //.frame(height: 130)
                    .listRowSeparatorTint(.clear)
        },label: {
            Text(disclosureGroupLabel)
                .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                            font: branding.paragraphTextAndLinks_Semibold_17pt,
                            btmPad: 0,
                            topPad: 0,
                            leadPad: 20,
                            trailPad: 20,
                            width: .infinity,
                            alignment: .leading)
        })
       // .cornerRadius(25.0)
    }
}
