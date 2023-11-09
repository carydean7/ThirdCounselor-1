//
//  NotesView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/5/23.
//

import SwiftUI

struct NotesView: View {
    @Environment(\.branding) var branding

    @ObservedObject var membersViewModel: MembersViewModel
    @ObservedObject var notesViewModel: NotesViewModel
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @FocusState private var isFocused: Bool
    
    @State private var notes = ""
    @State private var showNotesTextEditor = false
    @State private var currentlySelectedNote: Note
    @State private var showCloseButton = true
    @State private var showAddItemButton = false
    @State private var font: Font = Branding.mock.primaryListRow_Body_23pt
    @State private var showConfirmDeleteOrganization: Bool = false
    
    var leader: String
    
    public init(notesViewModel: NotesViewModel = NotesViewModel.shared,
                notes: String = "",
                showNotesTextEditor: Bool = false,
                currentlySelectedNote: Note = Note(id: "",
                                                   uid: "",
                                                   content: "",
                                                   leader: ""),
                leader: String,
                showCloseButton: Bool = true,
                showConfirmDeleteOrganization: Bool = false,
                showAddItemButton: Bool = false,
                membersViewModel: MembersViewModel) {
        self.notesViewModel = notesViewModel
        self.notes = notes
        self.showNotesTextEditor = showNotesTextEditor
        self.currentlySelectedNote = currentlySelectedNote
        self.leader = leader
        self.showCloseButton = showCloseButton
        self.showConfirmDeleteOrganization = showConfirmDeleteOrganization
        self.showAddItemButton = showAddItemButton
        self.membersViewModel = membersViewModel
    }
    
    var body: some View {
        VStack {
            ListHeaderView(headingTitle: ListHeadingTitles.notes.rawValue,
                           showCloseButton: $showCloseButton,
                           isInnerListHeader: .constant(false),
                           showConfirmDeleteOrganization: $showConfirmDeleteOrganization,
                           membersViewModel: membersViewModel,
                           speakingAssignmentsViewModel: SpeakingAssignmentsViewModel.shared,
                           backgroundClr: branding.backgroundColor,
                           addButtonAction: {_ in })

            HStack {
                Image(systemName: "pencil") .foregroundColor(branding.destructiveButton)
                .font(font)
                TextField(" Enter note here...", text: $notes, onCommit: {
                    let id = "\(AppDelegate.unitNumber)_\(UUID().uuidString)"

                    let note = Note(id: id, uid: id, content: $notes.wrappedValue, leader: leader)
                    notesViewModel.addNoteDocument(note: note) {
                        CoreDataManager.shared.addNote(noteModel: note)
                        notesViewModel.fetchData(for: leader) {
                            notes = ""
                        }
                    }

                })
                .keyboardType(.asciiCapable) }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(branding.nonDestructiveButton, lineWidth: 1))
                .padding(.horizontal)
                .padding(.top, 80)
                .offset(y: -self.keyboardHeightHelper.keyboardHeight)
            
            NavigationView {
                List {
                    ForEach(notesViewModel.notes, id: \.self) { note in
                        Text(note.content)
                            .customText(color: branding.navListAccentOr4GroundTextLiteBlueColor,
                                        font: font,
                                        btmPad: 0,
                                        topPad: 0,
                                        leadPad: 0,
                                        trailPad: 0,
                                        width: .infinity,
                                        alignment: .leading)
                    }
                    .onDelete(perform: deleteNote)
                }
            }
            .padding(.bottom, 0)
        }
        .onAppear {
            switch (Constants.deviceIdiom) {
            case .pad:
                font = branding.primaryListRow_iPad_Title_34pt
            case .phone:
                font = branding.primaryListRow_Body_23pt
            default:
                break
            }
            
            notesViewModel.fetchData(for: leader) {
                
            }
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        var index = 0
        for idx in offsets {
            index = idx
        }

        let uid = notesViewModel.notes[index].uid
        notesViewModel.deleteNote(note: notesViewModel.notes[index]) {
            CoreDataManager.shared.deleteNote(uid: uid) {
                notesViewModel.fetchData(for: leader) {
                    print("Deleting Note")
                }
            }
        }
    }
}
