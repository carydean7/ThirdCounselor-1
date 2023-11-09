//
//  HymnsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/15/23.
//

import SwiftUI

struct HymnsListView: View {
    @EnvironmentObject var conductingSheetViewModel: ConductingSheetViewModel
    @EnvironmentObject var hymnsViewModel: HymnsViewModel

    @Environment(\.dismiss) var dismiss
    @Environment(\.branding) var branding
    
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State private var alphaToHymn = [String]()
    @State private var showCloseButton = true
    @State private var isPresented = false
    @State private var font: Font = Branding.mock.rowLabel_Caption_18pt
    @State private var hymnTitle = ""
    @State private var scrollTarget: String?
//    @State private var showConfirmDeleteOrganization: Bool = false
    @State private var showEditButton: Bool = false
    
    var selectHymnAction: (String) -> Void
    
    public init(alphaToHymn: [String] = [String](),
                showCloseButton: Bool = true,
//                showConfirmDeleteOrganization: Bool = false,
                showEditButton: Bool = false,
                isPresented: Bool = false,
                font: Font = Branding.mock.rowLabel_Caption_18pt,
                selectedHymnAction: @escaping (String) -> Void) {
        self.selectHymnAction = selectedHymnAction
        self.alphaToHymn = alphaToHymn
        self.font = font
        self.isPresented = isPresented
        self.showCloseButton = showCloseButton
//        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showEditButton = showEditButton
    }
    
    //MARK: lettersListView
    
    var lettersListView: some View {
        VStack {
            ForEach(alphaToHymn, id: \.self) { letter in
                HStack {
                    Spacer()
                    Button(action: {
                        if hymnsViewModel.hymns.first(where: { $0.title.prefix(1) == letter }) != nil {
                            withAnimation {
                                scrollTarget = letter
                            }
                        }
                    }, label: {
                        Text(letter)
                            .font(.system(size: 14))
                            .padding(.trailing, 10)
                            .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                    })
                }
            }
        }
    }
    
    //MARK: searchBar
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
            TextField("", text: $hymnTitle)
                .modifier(PlaceholderStyle(showPlaceHolder: hymnTitle.isEmpty, placeholder: "Search"))
                .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                .font(Font.system(size: 21))
                .offset(y: -self.keyboardHeightHelper.keyboardHeight)
        }
        .padding(7)
        .background(branding.nonDestructiveButton)
        .cornerRadius(50)
    }
    
    //MARK: hymnsListView
    
    var hymnsListView: some View {
        ScrollView {
            ScrollViewReader { scrollProxy in
                LazyVStack(pinnedViews:[.sectionHeaders]) {
                    ForEach(alphaToHymn.filter{ self.searchForSection($0)}, id: \.self) { letter in
                        Section(header: SearchSectionHeaderView(text: letter).frame(width: nil, height: 35, alignment: .leading)) {
                            ForEach(hymnsViewModel.hymns.filter{ (hymn) -> Bool in hymn.title.prefix(1) == letter && self.searchForHymn(hymn.title) }) { hymn in
                                HymnRow(hymn: hymn, selectedHymnAction: { selectedHymn in
                                    self.selectHymn(selectedHymn: selectedHymn)
                                    
                                    // need to pass in for which hymn type this is e.g. open song, close
                                    // then just save song data inside selectedConductingsheetSection
                                    if conductingSheetViewModel.isSheet {
                                        dismiss()
                                        isPresented = true
                                    }
                                })
                                .frame(height: 30)
                                .padding([.leading, .trailing], 40)
                                .contentShape(Rectangle())
                            }
                        }
                    }
                }
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        scrollTarget = nil
                        withAnimation {
                            scrollProxy.scrollTo(target, anchor: .topLeading)
                        }
                    }
                }
            }
        }
        .environment(\.colorScheme, .light)
        .preferredColorScheme(.light)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ListHeaderView(headingTitle: ListHeadingTitles.hymns.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: .constant(false),
                           membersViewModel: MembersViewModel.shared,
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })

            searchBar
                .frame(height: 51)
                .padding([.trailing, .leading], 15)
                .background(branding.nonDestructiveButton)
            
            ZStack {
                hymnsListView
                    .padding(.top, 0)
                lettersListView
                    .padding(.top, -30)
            }
        }
        .onAppear() {            
            hymnsViewModel.fetchData {
                sortHymns()
                indexForTitle()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: functions
    private func searchForHymn(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(hymnTitle.lowercased(with: .current)) || hymnTitle.isEmpty)
    }
    
    private func searchForSection(_ txt: String) -> Bool {
        return (txt.prefix(1).lowercased(with: .current).hasPrefix(hymnTitle.prefix(1).lowercased(with: .current)) || hymnTitle.isEmpty)
    }
    
    //MARK: selectCountryCode
    func selectHymn(selectedHymn: (title: String, number: String)){
        switch $conductingSheetViewModel.selectedConductingSheetSection.songForSection.wrappedValue {
        case ConductingSectionsIndexes.openingHymn.rawValue:
            conductingSheetViewModel.selectedConductingSheetSection.openingSong = selectedHymn
            
        case ConductingSectionsIndexes.sacramentMusic.rawValue:
            conductingSheetViewModel.selectedConductingSheetSection.sacramentSong = selectedHymn
            
        case ConductingSectionsIndexes.speakersAndMusic.rawValue:
            conductingSheetViewModel.selectedConductingSheetSection.intermediatMusic = selectedHymn
            
        case ConductingSectionsIndexes.closingHymn.rawValue:
            conductingSheetViewModel.selectedConductingSheetSection.closingSong = selectedHymn
            
        default:
            break
        }
        
        let song = "\(selectedHymn.number) : \(selectedHymn.title)"
        
        conductingSheetViewModel.selectedConductingSheetSection.upperSectionContent = conductingSheetViewModel.selectedConductingSheetSection.upperSectionContent?.replacingOccurrences(of: "<Hymn>", with: song)
    }
    
    func sortHymns() {
        hymnsViewModel.hymns = hymnsViewModel.hymns.sorted { hymn, hymn in
            hymn.title < hymn.title
        }
    }
    
    func indexForTitle() {
        if alphaToHymn.isEmpty {
            for alphabet in fullAlphabet {
                for hymn in hymnsViewModel.hymns {
                    if hymn.title.prefix(1) == alphabet {
                        alphaToHymn.append(alphabet)
                        break
                    }
                }
            }
        }
    }
}

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                .padding(.horizontal, 15)
            }
            content
            .foregroundColor(Color.white)
            .opacity(0.5)
            .padding(5.0)
        }
    }
}
