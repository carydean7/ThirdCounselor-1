//
//  OrganizationalReportViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/16/22.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

//extension OrganizationalReportViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == organizationsTableView {
//            return organizationsTableViewDataSource.count
//        }
//
//        return selectedOrgCalMbr?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.layer.cornerRadius = 15.0
//        tableView.layer.borderWidth = 0.5
//        tableView.layer.borderColor = CGColor.init(red: 220, green: 100, blue: 50, alpha: 1)
//        tableView.layer.masksToBounds = true
//
//        if tableView == organizationsTableView {
//            tableView.layer.cornerRadius = 15.0
//            tableView.layer.borderWidth = 0.5
//            tableView.layer.borderColor = CGColor.init(red: 220, green: 100, blue: 50, alpha: 1)
//            tableView.layer.masksToBounds = true
//
//            let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: 40, duration: 0.35, delayFactor: 0.05)
//            let animator = Animator(animation: animation)
//            animator.animate(cell: cell, at: indexPath, in: tableView)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == organizationsTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = organizationsTableViewDataSource[indexPath.row]
//            return cell
//        }
//
//        guard var cell: ReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
//
//        cell.actionButtonDelegate = self
//        cell.acceptDeclineCallSegmentControlDelegate = self
//
//        cell.actionsButton.tag = indexPath.row
//
//        if let orgCallingsMbrData = selectedOrgCalMbr {
//            if indexPath.row < orgCallingsMbrData.count {
//                if orgCallingsMbrData[indexPath.row].organizationName != selectedOrganization ?? "" {
//                    selectedOrgCalMbr?.removeAll()
//
//                    selectedOrgCalMbr = getOrganizationBy(name: selectedOrganization ?? "Young Women")
//
//                    if let updatedOrgCallingsMbrData = selectedOrgCalMbr {
//                        cell = setValues(for: cell, memberName: updatedOrgCallingsMbrData[indexPath.row].memberName, callingName: updatedOrgCallingsMbrData[indexPath.row].callingName, approvedDate: updatedOrgCallingsMbrData[indexPath.row].approvedDate, calledDate: updatedOrgCallingsMbrData[indexPath.row].calledDate, sustainedDate: updatedOrgCallingsMbrData[indexPath.row].sustainedDate, setApartDate: updatedOrgCallingsMbrData[indexPath.row].setApartDate, releaseDate: updatedOrgCallingsMbrData[indexPath.row].releasedDate, recommendedDate: updatedOrgCallingsMbrData[indexPath.row].recommendedDate, ldrAssignedToCall: updatedOrgCallingsMbrData[indexPath.row].ldrAssignToCall, ldrAssignedToSetApart: updatedOrgCallingsMbrData[indexPath.row].ldrAssignToSetApart, callingPreviouslyFilledDate: updatedOrgCallingsMbrData[indexPath.row].callingPreviouslyFilledDate)
//                    }
//                } else {
//                    cell = setValues(for: cell, memberName: orgCallingsMbrData[indexPath.row].memberName, callingName: orgCallingsMbrData[indexPath.row].callingName, approvedDate: orgCallingsMbrData[indexPath.row].approvedDate, calledDate: orgCallingsMbrData[indexPath.row].calledDate, sustainedDate: orgCallingsMbrData[indexPath.row].sustainedDate, setApartDate: orgCallingsMbrData[indexPath.row].setApartDate, releaseDate: orgCallingsMbrData[indexPath.row].releasedDate, recommendedDate: orgCallingsMbrData[indexPath.row].recommendedDate, ldrAssignedToCall: orgCallingsMbrData[indexPath.row].ldrAssignToCall, ldrAssignedToSetApart: orgCallingsMbrData[indexPath.row].ldrAssignToSetApart, callingPreviouslyFilledDate: orgCallingsMbrData[indexPath.row].callingPreviouslyFilledDate)
//                }
//            }
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == reportTableView {
//            if !cellActionButtonsHiddenState.isEmpty {
//                if cellActionButtonsHiddenState[indexPath.row] {
//                    return 100
//                } else {
//                    return 0
//                }
//            }
//        }
//
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == organizationsTableView {
//            backgroundImageView.alpha = 1.0
//
//          //  allOrgCalMbr = OrgMbrCallingViewModel.shared.getOrgMbrCallings()
//
//            self.selectedOrganization = self.organizationsTableViewDataSource[indexPath.row]
//
//            self.changeOrganizationButton.setTitle(self.selectedOrganization, for: .normal)
//
//            self.selectedOrgCalMbr = self.getOrganizationBy(name: self.selectedOrganization ?? "Young Women")
//
//            validateReportCellRowHeight(for: selectedOrgCalMbr ?? [OrgMbrCalling]())
//
//            reportTableView.isHidden = false
//            tableViewContainerView.isHidden = false
//            titleLabel.isHidden = true
//            changeOrganizationButton.isHidden = false
//            memberTitleLabel.isHidden = false
//            positionTitleLabel.isHidden = false
//            headerTitleUnderlineView.isHidden = false
//
//            organizationsTableView?.removeFromSuperview()
//
//            reportTableView.reloadData()
//
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
//
//    // MARK: - TableViewCell SetValues
//
//    func setValues(for cell: ReportTableViewCell, memberName: String, callingName: String, approvedDate: String, calledDate: String, sustainedDate: String, setApartDate: String, releaseDate: String, recommendedDate: String, ldrAssignedToCall: String, ldrAssignedToSetApart: String, callingPreviouslyFilledDate: String) -> ReportTableViewCell {
//
//        cell.acceptDeclineCallSegmentControl.isHidden = true
//
//        if setApartDate != "" {
//            cell.callingLabel.text = callingName
//            cell.membersLabel.text = memberName
//            cell.actionsButton.isHidden = true
//            cell.ldrAssignToActionLabel.isHidden = true
//        } else {
//            if memberName == "" {
//                cell.actionsButton.isHidden = true
//            } else {
//                cell.actionsButton.isHidden = false
//            }
//
//            if setApartDate == "" {
//                if sustainedDate == "" {
//                    if calledDate == "" {
//                        if approvedDate != "" {
//                            cell.acceptDeclineCallSegmentControl.isHidden = false
//
//                            if callingAcceptedIndex == cell.actionsButton.tag {
//                                cell.actionsButton.isEnabled = true
//                            } else {
//                                cell.actionsButton.isEnabled = false
//                            }
//
//                            cell.actionsButton.setTitle(NextStepActions.called.rawValue, for: .normal)
//                            cell.ldrAssignToActionLabel.text = "Leader To Extended Call: \(ldrAssignedToCall)"
//                            cell.ldrAssignToActionLabel.isHidden = false
//                        } else {
//                            if recommendedDate != "" {
//                                cell.actionsButton.setTitle(NextStepActions.approve.rawValue, for: .normal)
//                                cell.actionsButton.isEnabled = true
//                            }
//                        }
//                    } else {
//                        cell.actionsButton.setTitle(NextStepActions.sustained.rawValue, for: .normal)
//                        cell.actionsButton.isEnabled = true
//                    }
//                } else {
//                    cell.actionsButton.setTitle(NextStepActions.setApart.rawValue, for: .normal)
//                    cell.ldrAssignToActionLabel.text = "Leader To Set Apart: \(ldrAssignedToSetApart)"
//                    cell.ldrAssignToActionLabel.isHidden = false
//                    cell.actionsButton.isEnabled = true
//                }
//            }
//        }
//
//        if cell.actionsButton.isHidden {
//            cell.ldrAssignToActionLabel.isHidden = true
//        }
//
//        cell.membersLabel.text = memberName
//        cell.callingLabel.text = callingName
//
//        return cell
//    }
//}

// MARK: - CloseActionSnapShotViewDelegate

extension OrganizationalReportViewController: CloseActionSnapShotViewDelegate {
    func closeButtonAction(sender: UIButton) {
        tableViewContainerView.isHidden = false
    }
}

// MARK: - CallSetApartActionConflictDelegate

extension OrganizationalReportViewController: CallSetApartActionConflictDelegate {
    func showActionConflictMessage() {
      //  showCallToSetApartConflictAlert()
    }
    
    func showCallToSetApartConflictAlert() {
//        let alert = UIAlertController(title: "Action Out of Sequence", message: "This member has not been called yet and cannot be set apart.", preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
//            //Cancel Action
//        }))
        
//        self.present(showAlertController(title: "Action Out of Sequence", message: "This member has not been called yet and connot be set apart.", style: .alert, hasTableView: false, actionTitle1: "Ok", actionStyle1: .default, actionTitle2: "", actionStyle2: .default, sender: tabBarView, addActionAction: nil), animated: true, completion: nil)
    }
}

// MARK: - SnapshotTabBarActionDelegate

extension OrganizationalReportViewController: SnapshotTabBarActionDelegate {
    func tabBarAction(sender: UIButton) {
        if sender.titleLabel?.text == TabbarButtonTitles.assignments.identifierString {
            outstandingLeaderCallingActionsAction()
        }
    }
}



