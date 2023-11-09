//
//  SpeakingAssignments12WeekView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/6/23.
//

import SwiftUI

struct SpeakingAssignments12WeekView: View {
    @Environment(\.branding) var branding

    @ObservedObject var viewModel: SpeakingAssignmentsViewModel
    
    @State private var date = ""
    @State private var nextMonth = false
    @State private var previousMonth = false
    @State private var currentlySelectedMonth = ""
    @State private var primaryFont: Font = Branding.mock.primaryListRow_Body_23pt
    @State private var secondaryFont: Font = Branding.mock.secondaryListRow_Callout_22pt
    
    public init(viewModel: SpeakingAssignmentsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                } label: {
                    Label("", systemImage: "arrowtriangle.backward")
                        .font(primaryFont)
                        .frame(width: 40, height: 40)
                        .foregroundColor(branding.destructiveButton)
                }
                .onTapGesture {
                    previousMonth = true
                    nextMonth = false
                    date = viewModel.getPreviousOrNextMonthsDate(currentMonth: date, direction: .previous)
                    getSundays(for: 4, date: convertToDate(stringDate: date)) { sundays in
                        viewModel.fourWeeksOfSundays = sundays
                        viewModel.getSpeakersForNext4Sundays(for: date, direction: .previous)
                    }
                }
                
                Text(currentlySelectedMonth)
                    .customText(color: branding.destructiveButton,
                                font: primaryFont,
                                btmPad: 0,
                                topPad: 0,
                                leadPad: 0,
                                trailPad: 0,
                                width: 150,
                                alignment: .leading)
                    .frame(height: 40)
                
                Button {
                } label: {
                    Label("", systemImage: "arrowtriangle.right")
                        .font(primaryFont)
                        .frame(width: 40, height: 40)
                        .foregroundColor(branding.destructiveButton)
                }
                .onTapGesture {
                    nextMonth = true
                    previousMonth = false
                    date = viewModel.getPreviousOrNextMonthsDate(currentMonth: date, direction: .next)
                    viewModel.getSpeakersForNext4Sundays(for: date, direction: .next)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.top, 40)

            NavigationView {
                List(viewModel.weeklyDisclosureGroupHeadings, id: \.self) { sectionTitle in
                    CustomDisclosureGroupView(isExpanded: true,
                        speakingAssignments: viewModel.getASundaysSpeakers(for: sectionTitle),
                                              sectionTitle: sectionTitle,
                                              headingTitles: viewModel.disclosureGroupColumnHeadings)
                    .listRowSeparatorTint(.clear)
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitleDisplayMode(.automatic)
            }
            .onAppear {
                switch (Constants.deviceIdiom) {
                case .pad:
                    primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                    secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
                case .phone:
                    primaryFont = branding.paragraphTextAndLinks_Semibold_17pt
                    secondaryFont = branding.paragraphTextAndLinks_Regular_17pt
                default:
                    break
                }
                
                let dt = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium //.medium
                
                let formattedDate = dateFormatter.string(from: dt)
                
                $date.wrappedValue = formattedDate

                currentlySelectedMonth = viewModel.getCurrentMonth(from: date)
            }
            .padding(.top, 95)
            .cornerRadius(25.0)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .cornerRadius(25.0)
    }
}
