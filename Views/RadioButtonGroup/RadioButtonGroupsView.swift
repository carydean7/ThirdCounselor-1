//
//  RadioButtonGroupsView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/29/23.
//

import SwiftUI

//MARK:- Group of Radio Buttons
enum Office: String {
    case deacon = "Deacon"
    case teacher = "Teacher"
    case priest = "Priest"
    case elder = "Elder"
    case highPriest = "High Priest"
    case bishop = "Bishop"
    case patriarch = "Patriarch"
}

enum PrayerType: String {
    case invocation = "Invocation"
    case benediction = "Benediction"
}

enum UnitType: String {
    case branch = "Branch"
    case ward = "Ward"
    case stake = "Stake"
}

struct RadioButtonGroupsView: View {
    @Environment(\.branding) var branding

    let callback: (String) -> ()
    
    @State var selectedId: String = ""
    @State var groupType: (priesthood: String, office: String)
    @State var color: Color = Branding.mock.contentTextColor
    
    @Binding var forOrdinances: Bool
    @Binding var forPreLogin: Bool
    
    var layoutHorizontal: Bool
    
    init(callback: @escaping (String) -> Void,
         selectedId: String = "",
         groupType: (priesthood: String, office: String) = ("",""),
         forOrdinances: Binding<Bool>,
         forPreLogin: Binding<Bool>,
         color: Color = Branding.mock.contentTextColor,
         layoutHorizontal: Bool) {
        self.callback = callback
        self.selectedId = selectedId
        self.groupType = groupType
        self._forOrdinances = forOrdinances
        self._forPreLogin = forPreLogin
        self.color = color
        self.layoutHorizontal = layoutHorizontal
    }
    
    var body: some View {
        if !layoutHorizontal {
            VStack {
                if forOrdinances {
                    if groupType.priesthood == "A" {
                        radioDeaconMajority
                        radioTeacherMajority
                        radioPriestMajority
                    } else if groupType.priesthood == "M" {
                        radioElderMajority
                        radioHighPriestMajority
                    } else if groupType.office == "S" {
                        radioBishopMajority
                        radioPatriarchMajority
                    }
                } else if forPreLogin {
                    radioBranchMajority
                    radioWardMajority
                    radioStakeMajority
                } else {
                    radioInvocationMajority
                    radioBenedictionMajority
                }
            }
        } else {
            HStack(spacing: -60) {
                if forOrdinances {
                    if groupType.priesthood == "A" {
                        radioDeaconMajority
                        radioTeacherMajority
                        radioPriestMajority
                    } else if groupType.priesthood == "M" {
                        radioElderMajority
                        radioHighPriestMajority
                    } else if groupType.office == "S" {
                        radioBishopMajority
                        radioPatriarchMajority
                    }
                } else if forPreLogin {
                    radioBranchMajority
                    radioWardMajority
                    radioStakeMajority
                } else {
                    radioInvocationMajority
                    radioBenedictionMajority
                }
            }
        }
    }
    
    var radioInvocationMajority: some View {
        RadioButtonFieldView (
            id: PrayerType.invocation.rawValue,
            label: PrayerType.invocation.rawValue,
            color: color,
            isMarked: selectedId == PrayerType.invocation.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioBenedictionMajority: some View {
        RadioButtonFieldView (
            id: PrayerType.benediction.rawValue,
            label: PrayerType.benediction.rawValue,
            color: color,
            isMarked: selectedId == PrayerType.benediction.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioDeaconMajority: some View {
        RadioButtonFieldView (
            id: Office.deacon.rawValue,
            label: Office.deacon.rawValue,
            color: color,
            isMarked: selectedId == Office.deacon.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioTeacherMajority: some View {
        RadioButtonFieldView (
            id: Office.teacher.rawValue,
            label: Office.teacher.rawValue,
            color: color,
            isMarked: selectedId == Office.teacher.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioPriestMajority: some View {
        RadioButtonFieldView (
            id: Office.priest.rawValue,
            label: Office.priest.rawValue,
            color: color,
            isMarked: selectedId == Office.priest.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioElderMajority: some View {
        RadioButtonFieldView (
            id: Office.elder.rawValue,
            label: Office.elder.rawValue,
            color: color,
            isMarked: selectedId == Office.elder.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioHighPriestMajority: some View {
        RadioButtonFieldView (
            id: Office.highPriest.rawValue,
            label: Office.highPriest.rawValue,
            color: color,
            isMarked: selectedId == Office.highPriest.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioBishopMajority: some View {
        RadioButtonFieldView (
            id: Office.bishop.rawValue,
            label: Office.bishop.rawValue,
            color: color,
            isMarked: selectedId == Office.bishop.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioPatriarchMajority: some View {
        RadioButtonFieldView (
            id: Office.patriarch.rawValue,
            label: Office.patriarch.rawValue,
            color: color,
            isMarked: selectedId == Office.patriarch.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioBranchMajority: some View {
        RadioButtonFieldView (
            id: UnitType.branch.rawValue,
            label: UnitType.branch.rawValue,
            color: color,
            isMarked: selectedId == UnitType.branch.rawValue ? true : false,
            callback: radioGroupCallback
        )
        .frame(width: 180)
    }
    
    var radioWardMajority: some View {
        RadioButtonFieldView (
            id: UnitType.ward.rawValue,
            label: UnitType.ward.rawValue,
            color: color,
            isMarked: selectedId == UnitType.ward.rawValue ? true : false,
            callback: radioGroupCallback
        )
        .frame(width: 180)
    }
    
    var radioStakeMajority: some View {
        RadioButtonFieldView (
            id: UnitType.stake.rawValue,
            label: UnitType.stake.rawValue,
            color: color,
            isMarked: selectedId == UnitType.stake.rawValue ? true : false,
            callback: radioGroupCallback
        )
        .frame(width: 180)
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}

//struct RadioButtonGroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HStack {
//            RadioButtonGroupsView { selected in
//                print("Selected Aaronic Priesthood Office is: \(selected)")
//            }
//        }
//    }
//}
