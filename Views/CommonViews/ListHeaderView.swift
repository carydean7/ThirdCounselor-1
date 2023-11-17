//
//  ListHeaderView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 5/22/23.
//

import Foundation
import SwiftUI

struct ListHeaderView: View {
    enum SubmitAddItemTypes {
        case organization
        case member
        case announcement
        case none
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel
    @ObservedObject var conductingSheetViewModel: ConductingSheetViewModel
    @ObservedObject var interviewsViewModel: InterviewsViewModel
    @ObservedObject var prayersViewModel: PrayersViewModel
    @ObservedObject var announcementsViewModel: AnnouncementsViewModel
    @ObservedObject var organizationsViewModel: OrganizationsViewModel
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var organizationName: String = ""
    @State private var announcement: String = ""
    @State private var showAddToViewModelView: Bool = false
    @State private var showAddSpeakingAssignmentsView = false
    @State private var font: Font = Font.caption
    @State private var showAddTextField: Bool = false
    @State private var showAddAnnouncementAlert: Bool = false
    @State private var currentSubmitAddItemType: SubmitAddItemTypes = .none

    @State private var backgroundClr: Color = Branding.mock.outerHeaderBackgroundColor

    @Binding var showCloseButton: Bool
    @Binding var showConfirmDeleteOrganization: Bool
    @Binding var isInnerListHeader: Bool
        
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    
    var headingTitle: String = ""
    
    var addButtonAction: (Bool) -> Void
        
    var headingTitleTopPadding: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                switch headingTitle {
                case ListHeadingTitles.members.rawValue:
                    if membersViewModel.isSheet {
                        return CGFloat(0)
                    } else {
                        return CGFloat(50)
                    }
                case ListHeadingTitles.leaders.rawValue,
                    ListHeadingTitles.interviewTypes.rawValue,
                    ListHeadingTitles.ordinations.rawValue,
                    ListHeadingTitles.speakingAssignment.rawValue,
                    ListHeadingTitles.callingActions.rawValue,
                    ListHeadingTitles.assignments.rawValue,
                    ListHeadingTitles.conductingSheet.rawValue,
                    ListHeadingTitles.announcements.rawValue:
                    return CGFloat(50)
                case ListHeadingTitles.scheduleNewInterview.rawValue:
                    return CGFloat(-60)
                case ListHeadingTitles.prayers.rawValue:
                    return CGFloat(60)
                case ListHeadingTitles.organizations.rawValue,
                    ListHeadingTitles.interviews.rawValue,
                    ListHeadingTitles.hymns.rawValue:
                    return CGFloat(0)
                case ListHeadingTitles.announcements.rawValue:
                    return CGFloat(0)
                case ListHeadingTitles.interviews.rawValue:
                    return CGFloat(70)
                default:
                    return CGFloat(0)
                }
            }
            
            // portrait
            return CGFloat(0)
        case .phone:
            return CGFloat(0)
        @unknown default:
            return CGFloat(0)
        }
    }
    
    var closeButtonTrailingPadding: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                switch headingTitle {
                case ListHeadingTitles.conductingSheet.rawValue:
                    return CGFloat(10)
                case ListHeadingTitles.assignments.rawValue:
                    return CGFloat(-40)
                case ListHeadingTitles.callingActions.rawValue:
                    return CGFloat(50)
                case ListHeadingTitles.notes.rawValue,
                    ListHeadingTitles.scheduleNewInterview.rawValue:
                    return CGFloat(-60)
                case ListHeadingTitles.hymns.rawValue, ListHeadingTitles.announcements.rawValue:
                    return CGFloat(50)

                default:
                    return CGFloat(0)
                }
            } else {
                // portrait
                return CGFloat(0)
            }
        case .phone:
            if appDelegate.isLandscape {
                switch headingTitle {
                case ListHeadingTitles.conductingSheet.rawValue:
                    return CGFloat(-10)
                case ListHeadingTitles.assignments.rawValue:
                    return CGFloat(-40)
                case ListHeadingTitles.notes.rawValue:
                    return CGFloat(-60)
                case ListHeadingTitles.callingActions.rawValue:
                    return CGFloat(-20)
                case ListHeadingTitles.hymns.rawValue:
                    return CGFloat(-25)

                default:
                    return CGFloat(0)
                }
            } else {
                // portrait
                return CGFloat(0)
            }
        @unknown default:
            return CGFloat(0)
        }
    }
    
    var closeButtonTopPadding: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                if headingTitle == ListHeadingTitles.ordinations.rawValue {
                    return CGFloat(25)
                } else if headingTitle == ListHeadingTitles.speakingAssignment.rawValue
                            || headingTitle == ListHeadingTitles.assignments.rawValue
                            || headingTitle == ListHeadingTitles.callingActions.rawValue
                            || headingTitle == ListHeadingTitles.addSpeakingAssignment.rawValue
                            || headingTitle == ListHeadingTitles.scheduleNewInterview.rawValue
                            || headingTitle == ListHeadingTitles.interviewTypes.rawValue
                            || headingTitle == ListHeadingTitles.leaders.rawValue
                            || headingTitle == ListHeadingTitles.prayers.rawValue
                            || headingTitle == ListHeadingTitles.scheduleNewInterview.rawValue
                            || headingTitle == ListHeadingTitles.conductingSheet.rawValue
                            || headingTitle == ListHeadingTitles.announcements.rawValue
                {
                    return CGFloat(50)
                }
                
                if headingTitle == ListHeadingTitles.hymns.rawValue {
                    return CGFloat(0)
                }
            } else {
                // portrait
                return CGFloat(0)
            }
        case .phone:
            if isInnerListHeader {
                return CGFloat(40)
            } else {
                return CGFloat(130)
            }

        default:
            break
        }
        
        return 0
    }
    
    var frameHeight: CGFloat {
        switch (Constants.deviceIdiom) {
        case .pad:
            if appDelegate.isLandscape {
                if isInnerListHeader {
                    return CGFloat(60)
                }
                
                if headingTitle == ListHeadingTitles.interviews.rawValue {
                    return CGFloat(60)
                }
                
                if headingTitle == ListHeadingTitles.members.rawValue
                    || headingTitle == ListHeadingTitles.speakingAssignment.rawValue
                    || headingTitle == ListHeadingTitles.assignments.rawValue
                    || headingTitle == ListHeadingTitles.callingActions.rawValue
                    || headingTitle == ListHeadingTitles.prayers.rawValue
                    || headingTitle == ListHeadingTitles.organizations.rawValue
                    || headingTitle == ListHeadingTitles.conductingSheet.rawValue
                    || headingTitle == ListHeadingTitles.announcements.rawValue  {
                    if isInnerListHeader {
                        return CGFloat(70)
                    }
                    
                    if (headingTitle == ListHeadingTitles.members.rawValue && membersViewModel.isSheet) || headingTitle == ListHeadingTitles.selectLeader.rawValue {
                        return CGFloat(50)
                    }
                    
                    if headingTitle == ListHeadingTitles.scheduleNewInterview.rawValue {
                        return CGFloat(10)
                    }
                    
                    if headingTitle == ListHeadingTitles.hymns.rawValue {
                        return CGFloat(50)
                    }
                    
                    return CGFloat(110)
                }
            } else {
                // portrait
                return CGFloat(50)
            }
        case .phone:
            if isInnerListHeader {
                return CGFloat(50)
            } else {
                return CGFloat(130)
            }

        default:
            break
        }

        return 50
    }
    
    public init(font: Font = Branding.mock.paragraphTextAndLinks_Regular_17pt,
                headingTitle: String = "",
                announcement: String = "",
                showCloseButton: Binding<Bool>,
                isInnerListHeader: Binding<Bool>,
                showConfirmDeleteOrganization: Binding<Bool>,
                membersViewModel: MembersViewModel = MembersViewModel.shared,
                speakingAssignmentsViewModel: SpeakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared,
                conductingSheetViewModel: ConductingSheetViewModel = ConductingSheetViewModel.shared,
                interviewsViewModel: InterviewsViewModel = InterviewsViewModel.shared,
                prayersViewModel: PrayersViewModel = PrayersViewModel.shared,
                announcementsViewModel: AnnouncementsViewModel = AnnouncementsViewModel.shared,
                organizationsViewModel: OrganizationsViewModel = OrganizationsViewModel.shared,
                backgroundClr: Color = Branding.mock.outerHeaderBackgroundColor,
                showAddTextField: Bool = false,
                showAddAnnouncementAlert: Bool = false,
                addButtonAction: @escaping (Bool) -> Void) {
        self.membersViewModel = membersViewModel
        self.speakingAssignmentsViewModel = speakingAssignmentsViewModel
        self.conductingSheetViewModel = conductingSheetViewModel
        self.interviewsViewModel = interviewsViewModel
        self.prayersViewModel = prayersViewModel
        self.announcementsViewModel = announcementsViewModel
        self.organizationsViewModel = organizationsViewModel
        self._showCloseButton = showCloseButton
        self._isInnerListHeader = isInnerListHeader
        self._showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.addButtonAction = addButtonAction
        self.backgroundClr = backgroundClr
        self.font = font
        self.headingTitle = headingTitle
        self.announcement = announcement
        self.showAddTextField = showAddTextField
        self.showAddAnnouncementAlert = showAddAnnouncementAlert
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if showCloseButton {
                    CloseButtonView(headingTitle: headingTitle)
                        .padding(.trailing, closeButtonTrailingPadding)
                        .padding(.top, closeButtonTopPadding)
                }
                
                Spacer()
                
                Text(headingTitle)
                    .customText(color: .white,
                                font: branding.screenSubTitle_Title2_28pt,
                                btmPad: 0,
                                topPad: headingTitleTopPadding,
                                leadPad: 0,
                                trailPad: 0,
                                width: .infinity,
                                alignment: .center)
                    .minimumScaleFactor(0.5)
                    .fontWeight(.semibold)

                Spacer()
                
                if membersViewModel.shouldShowAddItemButton && headingTitle == ListHeadingTitles.members.rawValue {
                    AddButton(systemImage: "person.crop.circle.badge.plus",
                              hasRoundedRect: false,
                              topPadding: 0,
                              labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                        showAddToViewModelView = true
                    })
                    .padding(.top, 50)
                    .alert("Add Member", isPresented: $showAddToViewModelView) {
                        TextField("First name", text: $firstName) {
                            UIApplication.shared.endEditing()
                        }
                            .foregroundColor(.white)
                            .preferredColorScheme(.light)
                            .font(font)
                            .offset(y: -self.keyboardHeightHelper.keyboardHeight)
                        
                        TextField("Last name", text: $lastName)
                            .foregroundColor(.white)
                            .preferredColorScheme(.light)
                            .font(font)
                            .offset(y: -self.keyboardHeightHelper.keyboardHeight)

                        Button("ADD", role: .destructive, action: submit)
                            .font(font)
                        Button("CANCEL", role: .cancel, action: {
                            membersViewModel.newMemberAdded = false
                        })
                            .font(font)
                    } message: {
                        Text("Enter the first and last name of the member below:")
                            .font(font)
                            .foregroundColor(.black)
                    }
                    .onAppear {
                        currentSubmitAddItemType = .member
                    }
                    .environment(\.colorScheme, .light)
                } else if speakingAssignmentsViewModel.shouldShowAddItemButton && headingTitle == ListHeadingTitles.speakingAssignment.rawValue {
                    AddButton(systemImage: "badge.plus.radiowaves.right",
                              hasRoundedRect: false,
                              topPadding: headingTitleTopPadding,
                              labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                        showAddSpeakingAssignmentsView = true
                    })
                    .sheet(isPresented: $showAddSpeakingAssignmentsView) {
                        AddSpeakingAssignmentView(membersViewModel: membersViewModel, orgMbrCallingViewModel: OrgMbrCallingViewModel.shared, speakingAssignmentsViewModel: speakingAssignmentsViewModel, showAddSpeakingAssignmentsView: .constant(true))
                            .environment(\.colorScheme, .light)
                    }
                    .environment(\.colorScheme, .light)
                }
                else if conductingSheetViewModel.selectedConductingSheetSection.showAddButton && isInnerListHeader {
                    ZStack {
                        AddButton(systemImage: "mic.badge.plus",
                                  hasRoundedRect: false,
                                  topPadding: headingTitleTopPadding,
                                  labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                            if conductingSheetViewModel.selectedConductingSheetSection.sheetSection == ConductingSectionsIndexes.announcements.rawValue || conductingSheetViewModel.selectedConductingSheetSection.sheetSection == ConductingSectionsIndexes.wardBusinessMoveIns.rawValue {
                                showAddTextField = true
                                conductingSheetViewModel.selectedConductingSheetSection.showTextField = showAddTextField
                                addButtonAction(showAddTextField)
                            }
                        })
                    }
                } else if prayersViewModel.shouldShowAddItemButton && headingTitle == ListHeadingTitles.prayers.rawValue {
                    AddButton(systemImage: "hands.sparkles",
                              hasRoundedRect: false,
                              topPadding: headingTitleTopPadding,
                              labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                        prayersViewModel.addButtonDelegate?.addButtonAction()
                    })
                } else if interviewsViewModel.shouldShowAddItemButton && headingTitle == ListHeadingTitles.interviews.rawValue {
                    AddButton(systemImage: "bubble.left.and.bubble.right",
                              hasRoundedRect: false,
                              topPadding: headingTitleTopPadding,
                              labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                        interviewsViewModel.addButtonDelegate?.addButtonAction()
                    })
                } else if organizationsViewModel.shouldShowAddItemButton && headingTitle == ListHeadingTitles.organizations.rawValue && TabBarController.currentlySelectedTab == TabBarTagIdentifiers.callings.rawValue {
                    AddButton(systemImage: "rectangle.stack.badge.plus",
                              hasRoundedRect: false,
                              topPadding: headingTitleTopPadding,
                              labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                        showAddToViewModelView = true
                    })
                    .alert("Add Organization", isPresented: $showAddToViewModelView) {
                        TextField("Organization name", text: $organizationName) {
                            UIApplication.shared.endEditing()
                        }
                            .foregroundColor(.white)
                            .preferredColorScheme(.light)
                            .font(font)
                            .offset(y: -self.keyboardHeightHelper.keyboardHeight)

                        Button("ADD", role: .destructive, action: submit)
                            .font(font)
                        Button("CANCEL", role: .cancel, action: {})
                            .font(font)
                    } message: {
                        Text("Enter the organization name below:")
                            .font(font)
                            .foregroundColor(.black)
                    }
                    .onAppear {
                        currentSubmitAddItemType = .organization
                    }
                    .environment(\.colorScheme, .light)
                    .alert("Are you sure you want to delete this organization?", isPresented: $showConfirmDeleteOrganization) {
                        Button("Yes", role: .destructive) {
                            organizationsViewModel.deleteOrganization(organization: organizationsViewModel.currentlySelectedOrganization)
                        }

                        Button("No", role: .cancel) {}
                    }
                    .font(branding.paragraphTextAndLinks_Semibold_17pt)
                    .tint(branding.nonDestructiveButton)
                    .environment(\.colorScheme, .light)
                } else if headingTitle == ListHeadingTitles.announcements.rawValue {
                        AddButton(systemImage: "note.text.badge.plus",
                                  hasRoundedRect: false,
                                  topPadding: headingTitleTopPadding,
                                  labelText: "", imgScale: .medium, color: .white, selectedAction: { action in
                            showAddAnnouncementAlert = true
                        })
                        .alert("Add Announcement", isPresented: $showAddAnnouncementAlert) {
                            TextField("Announcement", text: $announcement) {
                                UIApplication.shared.endEditing()
                            }
                                .foregroundColor(.white)
                                .preferredColorScheme(.light)
                                .font(font)
                                .offset(y: -self.keyboardHeightHelper.keyboardHeight)

                            Button("ADD", role: .destructive, action: submit)
                                .font(font)
                            Button("CANCEL", role: .cancel, action: {})
                                .font(font)
                        } message: {
                            Text("Enter the announcement below:")
                                .font(font)
                                .foregroundColor(.black)
                        }
                        .onAppear {
                            currentSubmitAddItemType = .announcement
                        }
                        .environment(\.colorScheme, .light)
                }
            }
            .frame(height: frameHeight)
            .background(RoundedCorners(color: isInnerListHeader ? branding.innerHeaderBackgroundColor : branding.backgroundColor, tl: 10, tr: 10, bl: 0, br: 0))
        }
    }
            
    func submit() {
        let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"
        
        switch currentSubmitAddItemType {
        case .announcement:
            let announcement = Announcement(uid: UUID().uuidString, fyi: $announcement.wrappedValue, announced: "N")
            announcementsViewModel.addAnnouncement(announcement: announcement) { results in
                if results.contains("Success") {
                    announcementsViewModel.fetchData {
                        
                    }
                }
            }
        case .organization:
            let organization = Organization(uid: id, name: organizationName)
            organizationsViewModel.addOrganizationDocument(organization: organization) { results in
                if results.contains("Success") {
                    CoreDataManager.shared.addOrganization(organization: organization) { results in
                        if results.contains("Success") {
                            organizationsViewModel.fetchData {}
                        }
                    }
                }
            }
        case .member:
            membersViewModel.newMemberLastNameBeginsWithLetter = String($lastName.wrappedValue.prefix(1))
            let member = Member(id: id, uid: id , name: "\($lastName.wrappedValue), \($firstName.wrappedValue)", welcomed: "N")
            membersViewModel.addMemberDocument(member: member, completion: { results in
                if results.contains("Success") {
                    membersViewModel.newMemberAdded = true
                    CoreDataManager.shared.addMember(member: member) { results in
                        if results.contains("Success") {
                            membersViewModel.fetchData {
                                Task.init {
                                    await membersViewModel.sortMembers()
                                    membersViewModel.indexForName()
                                }
                            }
                        }
                    }
                }
            })
        case .none:
            break
        }
        
//        if organizationName.isEmpty {
//            membersViewModel.newMemberLastNameBeginsWithLetter = String($lastName.wrappedValue.prefix(1))
//            let member = Member(id: id, uid: id , name: "\($lastName.wrappedValue), \($firstName.wrappedValue)", welcomed: "N")
//            membersViewModel.addMemberDocument(member: member, completion: { results in
//                if results.contains("Success") {
//                    membersViewModel.newMemberAdded = true
//                    CoreDataManager.shared.addMember(member: member) { results in
//                        if results.contains("Success") {
//                            membersViewModel.fetchData {
//                                Task.init {
//                                    await membersViewModel.sortMembers()
//                                    membersViewModel.indexForName()
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//        } else {
//            let organization = Organization(uid: id, name: organizationName)
//            organizationsViewModel.addOrganizationDocument(organization: organization) { results in
//                if results.contains("Success") {
//                    CoreDataManager.shared.addOrganization(organization: organization) { results in
//                        if results.contains("Success") {
//                            organizationsViewModel.fetchData {}
//                        }
//                    }
//                }
//            }
//        }
    }
}

struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}

enum AddButtonTypes {
case member
    case organization
    case prayer
    case interview
    case speaker
}

struct AddButton: View {
    @Environment(\.branding) var branding

    var systemImage: String = ""
    var hasRoundedRect: Bool = false
    var topPadding: CGFloat = 0.0
    var labelText: String
    var selectAction: (Bool) -> Void
    var imgScale: Image.Scale
    var color: Color
    
    init(systemImage: String,
         hasRoundedRect: Bool,
         topPadding: CGFloat,
         labelText: String,
         imgScale: Image.Scale,
         color: Color,
         selectedAction: @escaping (Bool) -> Void) {
        self.systemImage = systemImage
        self.hasRoundedRect = hasRoundedRect
        self.topPadding = topPadding
        self.labelText = labelText
        self.imgScale = imgScale
        self.color = color
        self.selectAction = selectedAction
    }
    
    var body: some View {
        Button {
            selectAction(true)
        } label: {
            Label(labelText, systemImage: systemImage)
                .font(branding.formControlsButtonsTextInputs_Semibold_17pt)
                .imageScale(imgScale)
                .foregroundColor(color)
                .frame(width: 15, height: 15)
        }
        .font(branding.formControlsButtonsTextInputs_Semibold_17pt)
        .fontWeight(.semibold)
        .frame(width: 15, height: 15)
        .padding([.top, .bottom], 12)
        .padding(.trailing, 20)
        .padding(.leading, 17)
        .overlay {
            if hasRoundedRect {
                RoundedRectangle(cornerRadius: 25, style: .continuous).strokeBorder(.white, lineWidth: 1.5)
                    .padding(.bottom, 0)
                    .padding(.trailing, 20)
                    .padding(.leading, -65)
                    .padding(.top, topPadding)
            }
        }
        .padding(.bottom, 0)
        .padding(.trailing, 20)
        .padding(.leading, -65)
        .padding(.top, topPadding)
    }
}

struct CloseButtonView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @State private var font: Font = Branding.mock.screenSubTitle_Title2_28pt
  
    var headingTitle: String
            
    init(font: Font = Branding.mock.screenTitle_Title_34pt,
         headingTitle: String = "") {
        self.headingTitle = headingTitle
        self.font = font
    }
        
    var body: some View {
        Button {
            dismiss()
        } label: {
            Label("", systemImage: "xmark")
                .fontWeight(.semibold)
                .font(branding.paragraphTextAndLinks_Semibold_17pt)
                .foregroundColor(.white)
        }
        .cornerRadius(15)
        .padding(.leading, 20)
        .padding(.top, 5)
        .onDisappear {
            if headingTitle == ListHeadingTitles.speakingAssignment.rawValue {
                SpeakingAssignmentsViewModel.shared.shouldShowAddItemButton = true
            }
            
            if MembersViewModel.shared.isSheet {
                MembersViewModel.shared.isSheet = false
            }
            
            if headingTitle == ListHeadingTitles.members.rawValue && !MembersViewModel.shared.isSheet {
                MembersViewModel.shared.shouldShowAddItemButton = true
            }
            
            if headingTitle == ListHeadingTitles.conductingSheet.rawValue && ConductingSheetViewModel.shared.memberListInConductingSheet {
                ConductingSheetViewModel.shared.memberListInConductingSheet = false
            }
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                font = branding.screenTitle_iPad_LargeTitle_40pt
            case .phone:
                font = branding.screenTitle_Title_34pt
            default:
                break
            }
        }
    }
}
