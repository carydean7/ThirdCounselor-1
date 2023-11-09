//
//  MembersViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/16/22.
//

import Foundation
import UIKit

// MARK: - UITableViewDataSource

//extension MembersViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if shouldAnimateTableView {
//            let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: 40, duration: 0.1, delayFactor: 0.02)
//            let animator = Animator(animation: animation)
//            animator.animate(cell: cell, at: indexPath, in: tableView)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        for title in Constants.sectionTitles[section] {
////            for sectionNotFound in DataManager.shared.sectionsNotFound {
////                if String(title) == sectionNotFound {
////                    return 0
////                }
////            }
//
//            return countOfRowInSection(section: String(title))
//        }
//
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
//        return Constants.sectionTitles[section]
//    }
//
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return Constants.sectionTitles
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//        let sectionTitleLabel = UILabel(frame: headerView.frame)
//        sectionTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .regular)
//        if let sections = sectionIndexTitles(for: tableView) {
//            sectionTitleLabel.text = "  " + sections[section]
//        }
//
//        headerView.addSubview(sectionTitleLabel)
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
//
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        shouldAnimateTableView = true
//        return index
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.overrideUserInterfaceStyle = .light
//
//        let cell: MembersTableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomCellIdentifiers.memberCell.rawValue, for: indexPath) as! MembersTableViewCell
//
//        let memberGroups = MembersViewModel.shared.memberGroups
//
//        if memberGroups.count > 0 {
//            let cellData = [MemberCellLabelTypes.calling.rawValue: ((memberGroups[indexPath.section])[indexPath.row]).callingName, MemberCellLabelTypes.member.rawValue: ((memberGroups[indexPath.section])[indexPath.row]).name]
//
//            if indexPath.row == selectedMemberRow && showCallingInCell && indexPath.section == selectedMemberFromSection {
//                cell.setValues(data: cellData, for: .expand)
//            } else {
//                cell.setValues(data: cellData, for: .collapse)
//            }
//        }
//
//        return cell
//    }
//
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        shouldAnimateTableView = true
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        showCallingInCell = false
//        selectedMemberRow = -1
//        selectedMemberFromSection = -1
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        shouldAnimateTableView = false
//
//        let memberGroups = MembersViewModel.shared.memberGroups
//        selectedMember = memberGroups[indexPath.section][indexPath.row].name
//        selectedMemberCallings = memberGroups[indexPath.section][indexPath.row].callingName
//
//        let cell: MembersTableViewCell = tableView.cellForRow(at: indexPath) as! MembersTableViewCell
//
//        if cell.contentView.backgroundColor == .white {
//            cell.callingNameLabel.isHidden = false
//            showCallingInCell = true
//            selectedMemberRow = indexPath.row
//            selectedMemberFromSection = indexPath.section
//        } else {
//            showCallingInCell = false
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == selectedMemberRow && showCallingInCell && indexPath.section == selectedMemberFromSection {
//            let rowPadding: CGFloat = 60.0
//            let charCount = CGFloat(numberOfCharactersInString(for: selectedMemberCallings))
//            let rowHeight = charCount + rowPadding
//            return rowHeight
//        }
//
//        return 40
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return MembersViewModel.shared.memberGroups.count //Constants.sectionTitles.count
//    }
//
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        // Remove action
//        let remove = UIContextualAction(style: .destructive,
//                                        title: "Remove Member") { [weak self] (action, view, completionHandler) in
//            self?.handleRemoveMember(at: indexPath)
//            completionHandler(true)
//        }
//        remove.backgroundColor = UIColor.systemRed
//
//        let configuration = UISwipeActionsConfiguration(actions: [remove])
//        configuration.performsFirstActionWithFullSwipe = true
//
//        return configuration
//    }
//
//    private func numberOfCharactersInString(for callings: String) -> Int {
//        return callings.count
//    }
//
//    private func countOfRowInSection(section: String) -> Int {
//        var count = 0
//
//        let groups = MembersViewModel.shared.memberGroups
//
//        for group in groups {
//            for member in group {
//                let name = member.name
//
//                if name.prefix(1) == section {
//                    count += 1
//                }
//            }
//        }
//
//        return count
//    }
//
//    func handleRemoveMember(at indexPath: IndexPath) {
//        showRemoveMemberConfirmationAlert(at: indexPath)
//    }
//}

// MARK: - UITextFieldDelegate

//extension MembersViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let _ = self.memberFNameTextField?.text?.isEmpty {
//            if let _ = self.memberLNameTextField?.text?.isEmpty {
//                textField.resignFirstResponder()
//            }
//        }
//
//        return true
//    }
//}

// MARK: - CloseActionSnapShotViewDelegate

extension MembersViewController: CloseActionSnapShotViewDelegate {
    func closeButtonAction(sender: UIButton) {
        tableViewContainerView.isHidden = false
    }
}

// MARK: - CallSetApartActionConflictDelegate

extension MembersViewController: CallSetApartActionConflictDelegate {
    func showActionConflictMessage() {
       // showCallToSetApartConflictAlert()
    }
    
//    func showCallToSetApartConflictAlert() {
//        self.present(showAlertController(title: "Action Out of Sequence", message: "This member has not been called yet and connot be set apart.", style: .alert, hasTableView: false, actionTitle1: "Ok", actionStyle1: .default, actionTitle2: "", actionStyle2: .default, sender: tabBarView, addActionAction: nil), animated: true, completion: nil)
//    }
}

// MARK: - SnapshotTabBarActionDelegate

extension MembersViewController: SnapshotTabBarActionDelegate {
    func tabBarAction(sender: UIButton) {
        if sender.titleLabel?.text == TabbarButtonTitles.assignments.identifierString {
            outstandingLeaderCallingActionsAction()
            
            if actionsSnapShotView != nil {
                actionsSnapShotView.closeButtonDelegate = self
                actionsSnapShotView.actionConflictDelegate = self
                
                actionsSnapShotView.isHidden = false
            }
        }
    }
}

