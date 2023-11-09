//
//  InterviewsViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/16/22.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

//extension InterviewsViewController: UITableViewDelegate, UITableViewDataSource {
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
//        if tableView == membersTableView {
////            for title in Constants.sectionTitles[section] {
////                return countOfRowInSection(section: String(title))
////            }
////            for title in Constants.sectionTitles[section] {
////                for sectionNotFound in DataManager.shared.sectionsNotFound {
////                    if String(title) == sectionNotFound {
////                        return 0
////                    }
////                }
////                
////                return countOfRowInSection(section: String(title))
////            }
//        } else if tableView == interviewTypesTableView {
//            return InterviewsViewModel.shared.interviewTypes.count
//        } else if tableView ==  assignedInterviewsTableView {
//            if InterviewsViewModel.shared.assignedInterviewsDataSource.count == 0 {
//                return 1
//            }
//            
//            return InterviewsViewModel.shared.assignedInterviewsDataSource.count
//        } else if tableView == leadersTableView {
//            return InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.count
//        }
//        
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
//        if tableView == membersTableView {
//            return Constants.sectionTitles[section]
//        } else if tableView == assignedInterviewsTableView {
//            return "Assigned Interviews"
//        }
//        
//        return ""
//    }
//    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        if tableView == membersTableView {
//            return Constants.sectionTitles
//        }
//        
//        return [String]()
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == membersTableView {
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//            let sectionTitleLabel = UILabel(frame: headerView.frame)
//            sectionTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .regular)
//            if let sections = sectionIndexTitles(for: tableView) {
//                sectionTitleLabel.text = "  " + sections[section]
//            }
//            
//            headerView.addSubview(sectionTitleLabel)
//            
//            return headerView
//        }
//        
//        return UIView()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
//    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        if tableView == membersTableView {
//            shouldAnimateTableView = true
//            return index
//        }
//        
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.overrideUserInterfaceStyle = .light
//
//        var memberOrInterviewTypeOrLeaderCell: UITableViewCell?
//
//        if tableView == membersTableView || tableView == interviewTypesTableView || tableView == leadersTableView {
//            memberOrInterviewTypeOrLeaderCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            
//            if tableView == membersTableView {
//                let memberGroups = MembersViewModel.shared.memberGroups
//                
//                if memberGroups.count > 0 {
//                    memberOrInterviewTypeOrLeaderCell?.textLabel?.text = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
//                }
//            } else if tableView == interviewTypesTableView {
//                memberOrInterviewTypeOrLeaderCell?.textLabel?.numberOfLines = 3
//                memberOrInterviewTypeOrLeaderCell?.textLabel?.lineBreakMode = .byWordWrapping
//                memberOrInterviewTypeOrLeaderCell?.textLabel?.text = InterviewsViewModel.shared.interviewTypes[indexPath.row]
//            } else if tableView == leadersTableView {
//                memberOrInterviewTypeOrLeaderCell?.textLabel?.text = InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview[indexPath.row]
//            }
//            
//            memberOrInterviewTypeOrLeaderCell?.textLabel?.textColor = .black
//            memberOrInterviewTypeOrLeaderCell?.backgroundColor = .clear
//            
//            return memberOrInterviewTypeOrLeaderCell ?? UITableViewCell()
//            
//        }  else if tableView == assignedInterviewsTableView {
//            let cell: AssignedInterviewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomCellIdentifiers.assignedInterviewsCell.rawValue, for: indexPath) as! AssignedInterviewsTableViewCell
//            
//            if !InterviewsViewModel.shared.assignedInterviewsDataSource.isEmpty {
//                cell.labelname.text = InterviewsViewModel.shared.assignedInterviewsDataSource[indexPath.row].name
//                cell.labelInterviewType.text = InterviewsViewModel.shared.assignedInterviewsDataSource[indexPath.row].interviewType
//                cell.labelAssignedLeader.text = InterviewsViewModel.shared.assignedInterviewsDataSource[indexPath.row].ldrAssignToDoInterview
//            } else if !name.isEmpty && !selectedInterviewType.isEmpty && !selectedLeader.isEmpty {
//                cell.labelname.text = name
//                cell.labelInterviewType.text = selectedInterviewType
//                cell.labelAssignedLeader.text = selectedLeader
//            }
//            
//            cell.textLabel?.textColor = .black
//            cell.backgroundColor = .clear
//            
//            return cell
//        }
//        
//        return UITableViewCell()
//    }
//    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        shouldAnimateTableView = true
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == membersTableView {
//            return MembersViewModel.shared.memberGroups.count
//        }
//        
//        return 1
//    }
//    
//    private func numberOfCharactersInString(for callings: String) -> Int {
//        return callings.count
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let defaults = UserDefaults.standard
//        let unitType = defaults.string(forKey: "unitType")
//
//        selectionAlert?.dismiss(animated: true, completion: nil)
//        
//        if tableView == membersTableView {
//            let memberGroups = MembersViewModel.shared.memberGroups
//            
//            if name != (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name {
//                name = (memberGroups[indexPath.section] as [(name: String, callingName: String)])[indexPath.row].name
//            }
//            
//            showSelectionAlert(sender: selectMembersButton, title: SelectionAlertTitles.interviewTypes.rawValue, message: SelectionAlertMessages.interviewTypes.rawValue, tableView: interviewTypesTableView ?? UITableView())
//        } else if tableView == interviewTypesTableView {
//            selectionAlert?.dismiss(animated: true, completion: nil)
//
//            selectedInterviewType = InterviewsViewModel.shared.interviewTypes[indexPath.row]
//            
//            selectionAlert?.dismiss(animated: true, completion: nil)
//            
//            labelNoAssignedInterviews.isHidden = true
//            
//            /* Once interview type is selected determine all leader types that can do interview - show list of those leaders for assignement
//             */
//            
//            if InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.isEmpty && InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.count < 3 {
//                if AppDelegate.leader == LeadershipPositions.bishopricFirstCounselor.stringValue || AppDelegate.leader == LeadershipPositions.bishopricSecondCounselor.stringValue || AppDelegate.leader == LeadershipPositions.branchPresidencyFirstCounselor.stringValue || AppDelegate.leader == LeadershipPositions.branchPresidencySecondCounselor.stringValue {
//                                        
//                    if unitType == UnitTypes.ward.stringValue {
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.bishop.stringValue)
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.bishopricFirstCounselor.stringValue)
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.bishopricSecondCounselor.stringValue)
//                    } else {
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.branchPresident.stringValue)
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.branchPresidencyFirstCounselor.stringValue)
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.branchPresidencySecondCounselor.stringValue)
//                    }
//                    
//                } else if AppDelegate.leader == LeadershipPositions.bishop.stringValue || AppDelegate.leader == LeadershipPositions.branchPresident.stringValue {
//                    if unitType == UnitTypes.ward.stringValue {
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.bishop.stringValue)
//                    } else {
//                        InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.branchPresident.stringValue)
//                    }
//                } else if AppDelegate.leader == LeadershipPositions.stakePresidencyFirstCounselor.stringValue || AppDelegate.leader == LeadershipPositions.stakePresidencySecondCounselor.stringValue {
//                    InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.stakePresident.stringValue)
//                    InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.stakePresidencyFirstCounselor.stringValue)
//                    InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.stakePresidencySecondCounselor.stringValue)
//                } else if AppDelegate.leader == LeadershipPositions.stakePresident.stringValue {
//                    InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview.append(LeadershipPositions.stakePresident.stringValue)
//                }
//            }
//            
//            showSelectionAlert(sender: selectMembersButton, title: SelectionAlertTitles.interviewTypes.rawValue, message: SelectionAlertMessages.interviewTypes.rawValue, tableView: interviewTypesTableView ?? UITableView())            
//            leadersTableView?.reloadData()
//        } else if tableView == leadersTableView {
//            selectedLeader = InterviewsViewModel.shared.leaderAuthorizedForSelectedInterview[indexPath.row]
//            
//            Task.init {
//                await InterviewsViewModel.shared.addInterview(dateInterviewed: convertToString(date: Date(), with: .medium), interviewType: selectedInterviewType, ldrAssigntoDoInterview: selectedLeader, name: name, notes: "")
//
////                await InterviewsViewModel.shared.addInterview(dateInterviewed: convertToString(date: Date(), with: .medium), interviewType: selectedInterviewType, ldrAssigntoDoInterview: selectedLeader, name: name, notes: "")
//                
//              //  assignedInterviewsDataSource = await InterviewsViewModel.shared.getInterviewsData()
//                
//                assignedInterviewsTableView.isHidden = false
//                tableViewContainerView.isHidden = false
//                                
//                assignedInterviewsTableView?.reloadData()
//            }
//        }
//        
//      //  tabBarView.isHidden = false
//    }
//            
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        // Remove action
//        let remove = UIContextualAction(style: .destructive,
//                                        title: "Interview Complete") { [weak self] (action, view, completionHandler) in
//            self?.handleInterviewComplete(at: indexPath)
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
//    func handleInterviewComplete(at indexPath: IndexPath) {
//        let interviewData = ["name": name, "row": indexPath.row] as [String : Any]
//        
//        InterviewsViewModel.shared.removeCompletedInterview(data: interviewData)
//    }
//        
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == assignedInterviewsTableView {
//            return 150
//        } else if tableView == interviewTypesTableView {
//            return 80
//        }
//        
//        return 40
//    }
//            
//    func countOfRowInSection(section: String) -> Int {
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
//}

// MARK: - SnapshotTabBarActionDelegate

//extension InterviewsViewController: SnapshotTabBarActionDelegate {
//    func tabBarAction(sender: UIButton) {
//        if sender.titleLabel?.text == TabbarButtonTitles.assignments.identifierString {
//            outstandingLeaderCallingActionsAction()
//
//            if actionsSnapShotView != nil {
//                actionsSnapShotView.closeButtonDelegate = self
//                actionsSnapShotView.actionConflictDelegate = self
//
//                actionsSnapShotView.isHidden = false
//
//                labelNoAssignedInterviews.isHidden = true
//            }
//        }
//    }
//}

// MARK: - CloseActionSnapShotViewDelegate

//extension InterviewsViewController: CloseActionSnapShotViewDelegate {
//    func closeButtonAction(sender: UIButton) {
//        if InterviewsViewModel.shared.interviewTypes.count == 0 || InterviewsViewModel.shared.assignedInterviewsDataSource.count == 0 {
//            labelNoAssignedInterviews.isHidden = false
//        } else {
//            tableViewContainerView.isHidden = false
//        }
//
//        selectMembersButton.isHidden = false
//
//    }
//}

// MARK: - CallSetApartActionConflictDelegate

//extension InterviewsViewController: CallSetApartActionConflictDelegate {
//    func showActionConflictMessage() {
//      //  showCallToSetApartConflictAlert()
//    }
//    
////    func showCallToSetApartConflictAlert() {
////        self.present(showAlertController(title: "Action Out of Sequence", message: "This member has not been called yet and connot be set apart.", style: .alert, hasTableView: false, actionTitle1: "Ok", actionStyle1: .default, actionTitle2: "", actionStyle2: .default, sender: tabBarView, addActionAction: nil), animated: true, completion: nil)
////    }
//}
