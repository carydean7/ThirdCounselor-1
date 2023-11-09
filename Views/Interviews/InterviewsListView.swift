//
//  InterviewsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/29/23.
//

import SwiftUI

struct InterviewsListView: View, AddButtonDelegate {
    @Environment(\.branding) var branding
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var interviewsViewModel: InterviewsViewModel
    
    @State private var showAddItemButton: Bool = false
    @State private var showAddToViewModel = false
    @State private var showCloseButton = false
//    @State private var listHeaderTopPadding: CGFloat = 140.0
//    @State private var listHeaderHeight: CGFloat = 40.0
//    @State private var navigationViewTopPadding: CGFloat = 95.0
    
    init(membersViewModel: MembersViewModel,
         interviewsViewModel: InterviewsViewModel,
         showAddItemButton: Bool = false,
         showAddToViewModel: Bool = false,
         showCloseButton: Bool = false/*,
         showConfirmDeleteOrganization: Bool = false*/) {
        self.membersViewModel = membersViewModel
        self.interviewsViewModel = interviewsViewModel
        self.showAddItemButton = showAddItemButton
        self.showAddToViewModel = showAddToViewModel
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.interviewsViewModel.addButtonDelegate = self
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            if interviewsViewModel.interviews.isEmpty {
                VStack(spacing: 30) {
                    ListHeaderView(headingTitle: ListHeadingTitles.interviews.rawValue,
                                   showCloseButton: $showCloseButton,
                                   isInnerListHeader: .constant(false),
                                   showConfirmDeleteOrganization: .constant(false),
                                   membersViewModel: membersViewModel,
                                   backgroundClr: branding.outerHeaderBackgroundColor,
                                   addButtonAction: {_ in })

                    NavigationView {
                        Text("No Scheduled Interviews")
                            .customText(color: branding.contentTextColor,
                                        font: branding.paragraphTextAndLinks_Semibold_17pt,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 60,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .frame(height: 40)
                    }
                    .cornerRadius(25.0)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .padding([.leading, .trailing], 10)
                    .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                }
                .frame(height: 150)
                .padding(.top, -322)
            }
            else {
                VStack(spacing: 20) {
                    ListHeaderView(headingTitle: ListHeadingTitles.interviews.rawValue,
                                   showCloseButton: $showCloseButton,
                                   isInnerListHeader: .constant(false),
                                   showConfirmDeleteOrganization: .constant(false),
                                   membersViewModel: membersViewModel,
                                   backgroundClr: branding.outerHeaderBackgroundColor,
                                   addButtonAction: {_ in })
                    .onAppear {
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate

                        membersViewModel.shouldShowAddItemButton = false

//                        switch (Constants.deviceIdiom) {
//                        case .pad:
//                            if appDelegate.isLandscape {
////                                listHeaderTopPadding = 120
////                                navigationViewTopPadding = 60.0
//                            } else {
//
//                            }
//                        case .phone:
////                            listHeaderTopPadding = 100
////                            listHeaderHeight = 40
////                            navigationViewTopPadding = 60
//                        default:
//                            break
//                        }
                    }
//                    .padding(.top, listHeaderTopPadding)
//                    .frame(height: listHeaderHeight)

                    NavigationView {
                        List(interviewsViewModel.disclosureGroupSectionTitles, id: \.self) {
                            sectionTitle in
                            InterviewListGroup(sectionTitle: sectionTitle,
                                               interviewsViewModel: interviewsViewModel,
                                               membersViewModel: membersViewModel)
                            .listRowSeparator(.hidden)
                        }
                        .cornerRadius(15)
                        .padding(.top, -40)
                        .padding(.bottom, 20)
                        .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                        .listStyle(.insetGrouped)
                        .navigationBarTitleDisplayMode(.automatic)
                    }
                    .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                    .cornerRadius(20.0)
                    .navigationViewStyle(StackNavigationViewStyle())
////                    .padding(.top, navigationViewTopPadding)
//                    .padding([.leading, .trailing], 10)
                }
               // .cornerRadius(25.0)
                .accentColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                .environment(\.colorScheme, .light)
            }
            
            if interviewsViewModel.showAddInterviewView {
                BottomSheetView(isOpen: $interviewsViewModel.showAddInterviewView, maxHeight: UIScreen.main.bounds.height * 0.40) {
                    AddInterviewView(membersViewModel: MembersViewModel.shared, interviewsViewModel: interviewsViewModel)
                        .padding(.bottom, -20)
                        .padding(.top, 20)
                    .background(.white)
                    .preferredColorScheme(.light)
                    .environment(\.colorScheme, .light)
                }
                .padding(.bottom, -20)
               // .cornerRadius(25.0)
                .environment(\.colorScheme, .light)
            }
        }
        .onViewDidLoad {
            interviewsViewModel.showAddInterviewView = false
        }
       // .cornerRadius(25)
        .onAppear {
            interviewsViewModel.fetchData {
                if !interviewsViewModel.interviews.isEmpty {
                    interviewsViewModel.interviews = interviewsViewModel.sortInterviews()
                }
            }
            membersViewModel.shouldShowAddItemButton = false
        }
    }
    
    func addButtonAction() {
        interviewsViewModel.showAddInterviewView = true
    }
}

struct InterviewListGroup: View {
    @Environment(\.branding) var branding
    
    @ObservedObject var interviewsViewModel: InterviewsViewModel
    @ObservedObject var membersViewModel: MembersViewModel
    
    @State private var isExpanded = false

    var sectionTitle = ""
    
    init(sectionTitle: String = "",
         interviewsViewModel: InterviewsViewModel,
         membersViewModel: MembersViewModel) {
        self.sectionTitle = sectionTitle
        self.interviewsViewModel = interviewsViewModel
        self.membersViewModel = membersViewModel
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded,
            content: {
            ContentHeaderView(hstackSpacing: CGFloat(-175), headingTitles: interviewsViewModel.disclosureGroupColumnHeadings)
                
                ForEach(Array(interviewsViewModel.interviews.enumerated()), id: \.offset) { (index, interview) in
                    if sectionTitle == interview.category {
                        ListContentRow(contents: [interview.name, interview.details, interview.scheduledInterviewDate, interview.scheduledInterviewTime, interview.ordination], 
                                       bottomPadding: 5,
                                       topPadding: 0,
                                       leadingPadding: 20,
                                       trailingPadding: 20,
                                       rowContentIsRecommendations: false,
                                       alignRowsInHStack: .constant(true))
                            .listRowSeparatorTint(.clear)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    OrdinationsViewModel.shared.addOrdination(ordination: Ordination(uid: interview.uid, name: interview.name, ordinationOffice: interview.ordination, status: "Interviewed", datePerformed: ""))
                                    interviewsViewModel.deleteInterview(interview: interview)
                                } label: {
                                    Text("Interviewed"~)
                                        .customText(color: branding.nonDestructiveButton,
                                                    font: branding.paragraphTextAndLinks_Semibold_17pt,
                                                    btmPad: 0,
                                                    topPad: 0,
                                                    leadPad: 60,
                                                    trailPad: 0,
                                                    width: .infinity,
                                                    alignment: .leading)
                                }
                                .tint(branding.nonDestructiveButton)
                            }
                    }
                }
            },
            label: {
            Text(sectionTitle)
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
        .onAppear {
            membersViewModel.shouldShowAddItemButton = false
        }
    }
}
