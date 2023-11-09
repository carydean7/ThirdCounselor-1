//
//  OrgMbrCallingsViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/16/22.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

extension OrgMbrCallingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for title in Constants.sectionTitles[section] {
            return countOfRowInSection(section: String(title))
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let memberGroups = MembersViewModel.shared.memberGroups
        cell.textLabel?.text = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
        
        cell.textLabel?.textColor = .black
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memberGroups = MembersViewModel.shared.memberGroups
        if memberName != (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name {
            
            CallingsViewController.memberCallingChanged = true
            
            let checkmarkConfig = UIImage.SymbolConfiguration(weight: .bold)
            let checkmarkSearch = UIImage(systemName: "checkmark.circle", withConfiguration: checkmarkConfig)
            
            self.cancelDoneButton.setImage(checkmarkSearch, for: .normal)

            memberName = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
        }
        
        memberLabel.text = memberName
        
        alert?.dismiss(animated: true, completion: nil)
        
        if OrgMbrCallingViewModel.shared.orgMbrCallings[selectedCallingEditIndex].callingName == CallSetApartBishopBranchPresidentOnly.president.rawValue || OrgMbrCallingViewModel.shared.orgMbrCallings[selectedCallingEditIndex].callingName == CallSetApartBishopBranchPresidentOnly.firstAssistant.rawValue || OrgMbrCallingViewModel.shared.orgMbrCallings[selectedCallingEditIndex].callingName == CallSetApartBishopBranchPresidentOnly.secondAssistant.rawValue {

            let defaults = UserDefaults.standard
            let unitType = defaults.string(forKey: UserDefaultKeys.unitType.stringValue)
            
            if unitType == UnitTypes.ward.stringValue {
                ldrAssignToCall = LeadershipPositions.bishop.rawValue
                ldrAssignToSetApart = LeadershipPositions.bishop.rawValue
            } else {
                ldrAssignToCall = LeadershipPositions.branchPresident.rawValue
                ldrAssignToSetApart = LeadershipPositions.branchPresident.rawValue
            }
        } else {
            showAssignmentDlog(for: AssignmentActions.extendCall.rawValue, at: cancelDoneButton.tag)
            
            ldrAssignToCall = assignedLeader
            
            if leaderCallAndSetApartSegmentControl.selectedSegmentIndex == 0 { // 0 == Yes
                ldrAssignToSetApart = assignedLeader
            }
        }
    }
    
    func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        return Constants.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let sectionTitleLabel = UILabel(frame: headerView.frame)
        sectionTitleLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        if let sections = sectionIndexTitles(for: tableView) {
            sectionTitleLabel.text = "  " + sections[section]
        }
        
        headerView.addSubview(sectionTitleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == membersTableView {
            tableView.layer.cornerRadius = 15.0
            tableView.layer.borderWidth = 0.5
            tableView.layer.borderColor = CGColor.init(red: 220, green: 100, blue: 50, alpha: 1)
            tableView.layer.masksToBounds = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.sectionTitles.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Constants.sectionTitles
    }
    
    private func countOfRowInSection(section: String) -> Int {
        var count = 0
        
//        let tableViewDataSource = MembersViewModel.shared.tableViewDataSource
        
//        for member in tableViewDataSource {
//            if member.prefix(1) == section {
//                count += 1
//            }
//        }

        return count
    }
}

