//
//  SpeakingAssignmentsViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/27/22.
//

import Foundation
import UIKit
import WebKit

//extension SpeakingAssignmentsViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if shouldAnimateTableView {
//            let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: 40, duration: 0.1, delayFactor: 0.02)
//            let animator = Animator(animation: animation)
//            animator.animate(cell: cell, at: indexPath, in: tableView)
//        }
//    }
//
//    func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
//        return Constants.sectionTitles[section]
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == speakingAssignmentsTableView {
//            if SpeakingAssignmentsViewController.selectedFilteredAction == SpeakingAssignmentFilter.neverHaveSpoken.stringValue {
//                for title in Constants.sectionTitles[section] {
////                    for sectionNotFound in DataManager.shared.sectionsNotFound {
////                        if String(title) == sectionNotFound {
////                            return 0
////                        }
////                    }
//
//                    return countOfRowInSection(section: String(title))
//                }
//            }
//            return SpeakingAssignmentsViewModel.shared.speakerGroups[section].count
//        } else {
//            for title in Constants.sectionTitles[section] {
//                return countOfRowInSection(section: String(title))
//            }
//        }
//
//        return 0
//    }
//
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        if tableView == membersTableView || SpeakingAssignmentsViewController.selectedFilteredAction == SpeakingAssignmentFilter.neverHaveSpoken.stringValue {
//            return Constants.sectionTitles
//        }
//
//        return [String]()
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == speakingAssignmentsTableView {
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//            let sectionTitleLabel = UILabel(frame: headerView.frame)
//            sectionTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .regular)
//
//            if SpeakingAssignmentsViewModel.shared.speakerGroups.count == 0 {
//                sectionTitleLabel.text = "No Speaking Assignments Found"
//            } else {
//                let speakingAssignment = SpeakingAssignmentsViewModel.shared.speakerGroups[section].first
//
//                if let askToSpeakOnDate = speakingAssignment?[EntityAttributeNames.askToSpeakOnDate.rawValue] {
//                    sectionTitleLabel.text = speakingAssignment?[EntityAttributeNames.askToSpeakOnDate.rawValue] as? String
//                }
//            }
//
//            headerView.addSubview(sectionTitleLabel)
//
//            return headerView
//        }
//
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//        let sectionTitleLabel = UILabel(frame: headerView.frame)
//        sectionTitleLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
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
//        if tableView == speakingAssignmentsTableView {
//            let cell: MembersTableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomCellIdentifiers.memberCell.rawValue, for: indexPath) as! MembersTableViewCell
//
//            let speakerGroups = SpeakingAssignmentsViewModel.shared.speakerGroups
//
//            if speakerGroups.count > 0 {
//                if let name = ((speakerGroups[indexPath.section])[indexPath.row])[EntityAttributeNames.name.rawValue] as? String, let topic = ((speakerGroups[indexPath.section])[indexPath.row])[EntityAttributeNames.topic.rawValue] as? String {
//                    let cellData = [EntityAttributeNames.name.rawValue: name, EntityAttributeNames.topic.rawValue: topic]
//                    if indexPath.row == selectedMemberRow && showCallingInCell && indexPath.section == selectedMemberFromSection {
//                        cell.setValues(data: cellData, for: .expand)
//                    } else {
//                        cell.setValues(data: cellData, for: .collapse)
//                    }
//                }
//            }
//
//            return cell
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        let memberGroups = MembersViewModel.shared.memberGroups
//        cell.textLabel?.text = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
//
//        cell.textLabel?.textColor = .black
//
//        cell.backgroundColor = .clear
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
//        if tableView == membersTableView {
//            let memberGroups = MembersViewModel.shared.memberGroups
//            if name != (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name {
//                name = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
//            }
//
//            selectedMemberLabel.text = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
//
//            alert?.dismiss(animated: true, completion: nil)
//        } else {
//            let speakerGroups = SpeakingAssignmentsViewModel.shared.speakerGroups
//
//            if speakerGroups.count > 0 {
//                if let topic = ((speakerGroups[indexPath.section])[indexPath.row])[EntityAttributeNames.topic.rawValue] as? String {
//                    selectedSpeakerTopic = topic
//                }
//            }
//
//            let cell: MembersTableViewCell = tableView.cellForRow(at: indexPath) as! MembersTableViewCell
//
//            if cell.contentView.backgroundColor == .white {
//                cell.callingNameLabel.isHidden = false
//                showCallingInCell = true
//                selectedMemberRow = indexPath.row
//                selectedMemberFromSection = indexPath.section
//            } else {
//                showCallingInCell = false
//            }
//
//            speakingAssignmentsTableView.reloadData()
//
//        }
//    }
//
//    @objc func addSpeaker(name: String) {
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == selectedMemberRow && showCallingInCell && indexPath.section == selectedMemberFromSection {
//            let rowPadding: CGFloat = 60.0
//            let charCount = CGFloat(numberOfCharactersInString(for: selectedSpeakerTopic))
//            let rowHeight = charCount + rowPadding
//            return rowHeight
//        }
//
//        return 40
//
//    }
//
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        // Remove action
//        let remove = UIContextualAction(style: .destructive,
//                                        title: "Edit Speaking Assignment") { [weak self] (action, view, completionHandler) in
//            self?.handleEditSpeakingAssignment(at: indexPath)
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
//    func handleEditSpeakingAssignment(at indexPath: IndexPath) {
//        isEditMode = true
//
//        tableViewContainerView.isHidden = true
//        addSpeakingAssignmentContainerView.isHidden = false
//
//        let speakingAssignment = SpeakingAssignmentsViewModel.shared .speakerGroups[indexPath.section][indexPath.row]
//
//        if let name = speakingAssignment[EntityAttributeNames.name.rawValue] as? String, let topic = speakingAssignment[EntityAttributeNames.topic.rawValue] as? String {
//            selectedMemberLabel.text = name
//            manualEntryTopicTextField.text = topic
//        }
//    }
//
//    func countOfRowInSection(section: String) -> Int {
//        var count = 0
//
////        let tableViewDataSource = MembersViewModel.shared.tableViewDataSource
//
////        for member in tableViewDataSource {
////            if member.prefix(1) == section {
////                count += 1
////            }
////        }
//
//        return count
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == membersTableView || SpeakingAssignmentsViewController.selectedFilteredAction == SpeakingAssignmentFilter.neverHaveSpoken.stringValue{
//            return Constants.sectionTitles.count
//        }
//
//        return SpeakingAssignmentsViewModel.shared.speakerGroups.count
//    }
//}

//extension SpeakingAssignmentsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return sundays.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return sundays[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if row > 0 {
//            selectedSunday = convertToDate(stringDate: sundays[row])
//            selectedDateLabel.text = sundays[row]
//
//            if speakingAssignmentComplete() {
//                let checkmarkConfig = UIImage.SymbolConfiguration(weight: .bold)
//                let checkmarkSearch = UIImage(systemName: "checkmark.circle", withConfiguration: checkmarkConfig)
//
//                self.cancelDoneButton.setImage(checkmarkSearch, for: .normal)
//
////                cancelDoneButton.setTitle("Done", for: .normal)
//            }
//        }
//    }
//}

// MARK: - SnapshotTabBarActionDelegate

//extension SpeakingAssignmentsViewController: SnapshotTabBarActionDelegate {
//    func tabBarAction(sender: UIButton) {
//        if sender.titleLabel?.text == TabbarButtonTitles.assignments.identifierString {
//           // outstandingLeaderCallingActionsAction()
//        }
//    }
//}

// MARK: - UITextFieldDelegate

//extension SpeakingAssignmentsViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let _ = self.manualEntryTopicTextField?.text?.isEmpty {
//            if let _ = self.manualEntryTopicTextField?.text?.isEmpty {
//                textField.resignFirstResponder()
//                
//                addSpeakingAssignmentContainerView.frame = addSpeakingAssignmentContainerViewOriginalFrame ?? .zero
//                
//                datePicker.isHidden = false
//                
//                topicReferenceSegmentControl.selectedSegmentIndex = -1
//                
//                textField.backgroundColor = #colorLiteral(red: 0.6395690441, green: 0.7693509459, blue: 0.9111731648, alpha: 1)
//                textField.textColor = .white
//                textField.isEnabled = false
//            }
//        }
//        
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        addSpeakingAssignmentContainerView.frame = CGRect(x: addSpeakingAssignmentContainerView.frame.origin.x, y: addSpeakingAssignmentContainerView.frame.origin.y - 100.0, width: addSpeakingAssignmentContainerView.frame.size.width, height: addSpeakingAssignmentContainerView.frame.size.height)
//        
//        datePicker.isHidden = true
//    }
//}
