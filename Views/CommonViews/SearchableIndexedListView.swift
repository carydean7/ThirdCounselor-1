//
//  SearchableIndexedListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/13/23.
//

import SwiftUI

struct SearchableIndexedListView: View {
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollProxy in
                    LazyVStack(pinnedViews:[.sectionHeaders]) {
                        ForEach(alphaToMember.filter{ self.searchForSection($0)}, id: \.self) { letter in
                            Section(header: SearchSectionHeaderView(text: letter).frame(width: nil, height: 35, alignment: .leading)) {
                                ForEach(searchResults.filter{ (name) -> Bool in name.prefix(1) == letter && self.searchForMember(name) }, selection: $multiSelection) { member in
                                    MultiSelectMemberRow(member: membersViewModel.getMemberModel(for: member) ?? Member(id: "",
                                                                                                                        uid: "",
                                                                                                                        name: ""),
                                                         isSheet: $isSheet,
                                                         showSelectedRowIcon: $showSelectedRowIcon
                                    ) { selectedMemberName in
                                        handleSelectedMemberAction(member: membersViewModel.getMemberModel(for: memberName) ?? Member(id: "", uid: "", name: ""), with: selectedMemberName)
                                    }
                                    .frame(height: 30)
                                    .padding([.leading, .trailing], 40)
                                    // .contentShape(Rectangle())
                                    //                                .onTapGesture(perform: {
                                    //                                    if !membersViewModel.isSheet {
                                    //                                        expandRow.toggle()
                                    //                                    }
                                    //                                })
                                    //                                .onDisappear {
                                    //                                    if !conductingSheetViewModel.memberListInConductingSheet {
                                    //                                        membersViewModel.shouldShowCloseButon = false
                                    //                                        showCloseButton = false
                                    //                                        if changeInCalling {
                                    //                                            submit(for: .changeInCalling)
                                    //                                        } else if memberAskedToSpeak {
                                    //                                            submit(for: .memberAssignedToSpeak)
                                    //                                        }
                                    //                                    }
                                    //                                }
                                }
                                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
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
            
            Button(action: {
                self.isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Select Multiple")
                    .frame(width: 150, height: 40)
                    .foregroundColor(branding.innerHeaderButtons)
            }
            
            if !multiSelection.isEmpty {
                
                Button("Deselect All"){
                    print("Items: \(multiSelection)")
                    multiSelection.removeAll()
                }
                .transition(AnyTransition.move(edge: .bottom))
            }
        }    }
}

#Preview {
    SearchableIndexedListView()
}
