//
//  StakeUnitLeaderPositionView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 10/26/23.
//

import SwiftUI

struct StakeUnitLeaderPositionView: View {
    @Environment(\.branding) var branding
        
    @State private var forPreLogin: Bool
    @State private var unitNumber: String = ""
    @State private var selectedLeader = ""
    @State private var selectedUnitType = ""
    @State private var selectedLeaderHasChanged: Bool
    @State private var showSelectedImage: Bool
    @State private var shouldUpdateRadioButton: Bool = false
    @State private var selections: [String] = [String]()
    @State private var showTooManyLeadersSelected: Bool = false
    
    var nextActionHandler: (Bool) -> Void
    
    init(forPreLogin: Bool = true,
         unitNumber: String = "",
         selectedLeader: String = "",
         selectedUnitType: String = "",
         selectedLeaderHadChanged: Bool = false,
         showSelectedImage: Bool = false,
         nextActionHandler: @escaping (Bool) -> Void) {
        self.forPreLogin = forPreLogin
        self.unitNumber = unitNumber
        self.selectedLeader = selectedLeader
        self.selectedUnitType = selectedUnitType
        self.selectedLeaderHasChanged = selectedLeaderHadChanged
        self.showSelectedImage = showSelectedImage
        self.nextActionHandler = nextActionHandler
    }
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("-----")
                    .foregroundColor(branding.labels)
                    .padding(.bottom, -20)
                    .preferredColorScheme(.light)
                
                Text("Unit & Leader Information")
                    .font(branding.paragraphTextAndLinks_Semibold_17pt)
                    .foregroundColor(branding.labels)
                    .padding(.top, 20)
                    .preferredColorScheme(.light)
                
                Text("-----")
                    .foregroundColor(branding.labels)
                    .padding(.bottom, -20)
                    .preferredColorScheme(.light)
            }
            .preferredColorScheme(.light)
            .environment(\.colorScheme, .light)
            
            HStack(spacing: 20) {
                Text("Select Unit Type:")
                    .font(branding.paragraphTextAndLinks_Semibold_17pt)
                    .foregroundColor(branding.labels)
                    .preferredColorScheme(.light)
                
                RadioButtonGroupsView(callback: { selected in
                    selectedUnitType = selected
                }, forOrdinances: .constant(false), forPreLogin: $forPreLogin,
                                      layoutHorizontal: true)
                .preferredColorScheme(.light)
                .environment(\.colorScheme, .light)
                
                Text("Unit Number:")
                    .font(branding.paragraphTextAndLinks_Semibold_17pt)
                    .foregroundColor(branding.labels)
                    .preferredColorScheme(.light)

                
                TextField("Enter Number:", text: $unitNumber) {
                    UIApplication.shared.endEditing()
                }
                    .underlineTextField()
                    .padding(.bottom, 10)
                    .foregroundColor(branding.labels)
                    .frame(width: 200)
                    .foregroundColor(.white)
                    .font(branding.paragraphTextAndLinks_Regular_17pt)
                    .preferredColorScheme(.light)
            }
            .preferredColorScheme(.light)
            .environment(\.colorScheme, .light)
            .frame(maxWidth: .infinity)
            .frame(alignment: .leading)
            .padding(.leading, 20)
                        
            Text("Select Your Leadership Position")
                .padding(.bottom, -30)
                .font(branding.paragraphTextAndLinks_Semibold_17pt)
                .foregroundColor(branding.labels)
                .preferredColorScheme(.light)
            
            NavigationStack {
                List {
                    ForEach(getLeaderPositions(), id: \.self) { leader in
                        RadioButton(shouldUpdateRadioButton: shouldUpdateRadioButton,
                                    labelText: leader, selections: $selections, forRecommendations: false) { selectedLeaderPosition in
                            setUnitLeaderInformation(leader: selectedLeaderPosition, unit: selectedUnitType, number: unitNumber)
                            $selectedLeader.wrappedValue = selectedLeaderPosition
                            
                            selections.append(selectedLeaderPosition)
                            
                            if selections.count > 1 {
                                showTooManyLeadersSelected = true
                            } else {
                                showTooManyLeadersSelected = false
                            }
                        }
                    }
                }
                .alert("Leader Selection Error", isPresented: $showTooManyLeadersSelected) {
                    Button("Ok", role: .cancel, action: {})
                        .font(branding.paragraphTextAndLinks_Semibold_17pt)
                        .foregroundColor(branding.navListAccentOr4GroundTextLiteBlueColor)
                } message: {
                    Text("You have selected more than one Leadership Position.  Deselect the position that does not apply to your current calling.")
                        .font(branding.paragraphTextAndLinks_Regular_17pt)
                        .foregroundColor(branding.contentTextColor)
                }
                .environment(\.colorScheme, .light)
            }
            
            Button {
                processStakeUnitLeaderPositionData() { results in
                    if results {
                        nextActionHandler(results)
                    }
                }
            } label: {
                HStack {
                    Text("Next")
                        .font(branding.paragraphTextAndLinks_Semibold_17pt)
                        .foregroundColor(branding.labels)
                        .preferredColorScheme(.light)
                        .padding(.bottom, 10)
                    
                    Image(systemName: "chevron.right")
                        .font(branding.paragraphTextAndLinks_Semibold_17pt)
                        .foregroundColor(branding.labels)
                        .preferredColorScheme(.light)
                        .padding(.bottom, 10)
                }
                .preferredColorScheme(.light)
            }
            .preferredColorScheme(.light)
        }
        .background(.white)
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .padding(.top, 20)
    }
    
    func getLeaderPositions() -> [String] {
        var positions = [String]()
        
        for leader in LeadershipPositions.allCases {
            positions.append(leader.stringValue)
        }
        
        return positions
    }
    
    func setUnitLeaderInformation(leader: String, unit: String, number: String) {
        let defaults = UserDefaults.standard

        if !leader.isEmpty {
            defaults.set(leader, forKey: UserDefaultKeys.leaderPosition.stringValue)
            AppDelegate.leader = leader
        }
        
        if !unit.isEmpty {
            defaults.set(unit, forKey: UserDefaultKeys.unitType.stringValue)
            AppDelegate.unitType = unit
        }
        
        if !number.isEmpty {
            defaults.set(number, forKey: UserDefaultKeys.unitNumber.stringValue)
            AppDelegate.unitNumber = number
        }
    }
    
    @MainActor func unitLeaderInformationIsValid(completion: @escaping (Bool) -> Void) {
        var isValid = false
        
        if !selectedUnitType.isEmpty && !unitNumber.isEmpty && !AppDelegate.leader.isEmpty {
            StakeViewModel.shared.fetchData {
                if StakeViewModel.shared.stakes.isEmpty {
                    if !StakeViewModel.hasInitialized {
                        StakeViewModel.shared.createStake(from: getDataFromJSON(fileName: "2224580_UnitsInStake")) { results in
                            StakeViewModel.hasInitialized = true
                            
                            if unitTypeAndNumberIsValid(type: selectedUnitType, number: unitNumber) {
                                setUnitLeaderInformation(leader: AppDelegate.leader, unit: selectedUnitType, number: unitNumber)
                                isValid = true
                                
                                OrgMbrCallingViewModel.shared.fetchOrgMbrCallings() { results in
                                    if results {
                                        completion(isValid)
                                    }
                                }
                            }
                        }
                    } else {
                        completion(isValid)
                    }
                }
            }
        }
        
        completion(isValid)
    }
    
    @MainActor func unitTypeAndNumberIsValid(type: String, number: String) -> Bool {
        for stk in StakeViewModel.shared.stakes {
            for unit in stk.units {
                if unit.unitName.contains(type) && unit.unitNumber == number {
                    return true
                }
            }
        }
        
        return false
    }
    
    @MainActor func processStakeUnitLeaderPositionData(completion: @escaping (Bool) -> Void) {
        var isValid = false
        unitLeaderInformationIsValid { results in
            completion(results)
        }
    }
}
