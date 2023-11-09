//
//  AnnouncementsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 11/4/23.
//

import SwiftUI

struct AnnouncementsListView: View {
    @Environment(\.branding) var branding
    
    @ObservedObject var viewModel: AnnouncementsViewModel = AnnouncementsViewModel.shared
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var showAddAnnouncementAlert: Bool = false
    @State private var showCloseButton = true
    @State private var announcement: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            ListHeaderView(headingTitle: ListHeadingTitles.announcements.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: MembersViewModel.shared,
                           prayersViewModel: PrayersViewModel.shared,
                           announcementsViewModel: viewModel,
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })
                        
            if viewModel.announcements.isEmpty {
                Text("No Announcements")
                    .customText(color: branding.labels,
                                font: branding.paragraphTextAndLinks_Semibold_17pt,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 0,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .center)
            } else {
                NavigationView {
                    List(viewModel.announcements, id: \.self) {  announcement in
                        Text(announcement.fyi)
                            .customText(color: branding.contentTextColor,
                                        font: branding.paragraphTextAndLinks_Regular_17pt,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .center)
                            .listRowSeparatorTint(.clear)
                    }
                    .listStyle(SidebarListStyle())
                    .navigationBarTitleDisplayMode(.automatic)
                }
                .cornerRadius(25.0)
                .padding(.top, 65)
                .padding(.bottom, 100)
                .padding([.leading, .trailing], 10)
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onAppear {
            viewModel.fetchData {
            }
        }
    }
}

struct AnnouncementsListView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsListView()
    }
}
