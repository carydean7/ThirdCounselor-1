//
//  ActionsReportViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/16/22.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ActionsReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  var rowsInSection = 0
        
//        switch section {
//        case ACSSSegmentControlSegments.recommended.rawValue:
//          //  rowsInSection = DataManager.shared.recommendationsForApproval.count
//        case ACSSSegmentControlSegments.called.rawValue:
//            rowsInSection = DataManager.shared.callsToBeExtended.count
//        case ACSSSegmentControlSegments.sustained.rawValue:
//            rowsInSection = DataManager.shared.toBeSustained.count
//        case ACSSSegmentControlSegments.setApart.rawValue:
//            rowsInSection = DataManager.shared.settingAparts.count
//        case ACSSSegmentControlSegments.released.rawValue:
//            rowsInSection = DataManager.shared.membersNeedingToBeReleased.count
//        default:
//            break
//        }
        
        return (self.arrayHeader[section] == 0) ? 0 : rowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.overrideUserInterfaceStyle = .light
        
        guard let cell: ActionsReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: "actionsCell", for: indexPath) as? ActionsReportTableViewCell else { return UITableViewCell() }
        
        cell.nextActionButtonDelegate = self
        cell.acceptDeclineCallSegmentControlDelegate = self
        
        cell.acceptDeclineCallSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        
//        switch indexPath.section {
//        case ACSSSegmentControlSegments.recommended.rawValue:
//            setOrgMbrCallingValues(org: "\t" + DataManager.shared.recommendationsForApproval[indexPath.row].organizationName, call: "\t" + DataManager.shared.recommendationsForApproval[indexPath.row].callingName, mbr: "\t" + DataManager.shared.recommendationsForApproval[indexPath.row].memberName)
//
//            cell.configureCell(segCntrlHidden: true, nxtActBtnTitle: NextStepActions.approve.rawValue, nxtActBtnSegCntrlTag: ActionSectionsIdentifiers.recommended.identifierIntValue + indexPath.row, callAcceptedIdx: ActionSectionsIdentifiers.recommended.identifierIntValue + indexPath.row, ldrAssignLblText: "", org: organization, call: calling, mbr: member)
//
//        case ACSSSegmentControlSegments.called.rawValue:
//            setOrgMbrCallingValues(org: "\t" + DataManager.shared.callsToBeExtended[indexPath.row].organizationName, call: "\t" + DataManager.shared.callsToBeExtended[indexPath.row].callingName, mbr: "\t" + DataManager.shared.callsToBeExtended[indexPath.row].memberName)
//
//            if DataManager.shared.callsToBeExtended[indexPath.row].ldrAssignToCall == "" {
//                let defaults = UserDefaults.standard
//
//                if let leader = defaults.string(forKey: UserDefaultKeys.leaderPosition.stringValue) {
//                    DataManager.shared.callsToBeExtended[indexPath.row].ldrAssignToCall = leader
//                }
//            }
//
//            cell.configureCell(segCntrlHidden: false, nxtActBtnTitle: NextStepActions.called.rawValue, nxtActBtnSegCntrlTag: ActionSectionsIdentifiers.called.identifierIntValue + indexPath.row, callAcceptedIdx: callingAcceptedIndex, ldrAssignLblText: "Leader To Extended Call: \(DataManager.shared.callsToBeExtended[indexPath.row].ldrAssignToCall)", org: organization, call: calling, mbr: member)
//
//        case ACSSSegmentControlSegments.sustained.rawValue:
//            setOrgMbrCallingValues(org: "\t" + DataManager.shared.toBeSustained[indexPath.row].organizationName, call: "\t" + DataManager.shared.toBeSustained[indexPath.row].callingName, mbr: "\t" + DataManager.shared.toBeSustained[indexPath.row].memberName)
//
//            cell.configureCell(segCntrlHidden: true, nxtActBtnTitle: NextStepActions.sustained.rawValue, nxtActBtnSegCntrlTag: ActionSectionsIdentifiers.sustained.identifierIntValue + indexPath.row, callAcceptedIdx: ActionSectionsIdentifiers.sustained.identifierIntValue + indexPath.row, ldrAssignLblText: "", org: organization, call: calling, mbr: member)
//
//        case ACSSSegmentControlSegments.setApart.rawValue:
//            setOrgMbrCallingValues(org: "\t" + DataManager.shared.settingAparts[indexPath.row].organizationName, call: "\t" + DataManager.shared.settingAparts[indexPath.row].callingName, mbr: "\t" + DataManager.shared.settingAparts[indexPath.row].memberName)
//
//            if DataManager.shared.settingAparts[indexPath.row].ldrAssignToSetApart == "" {
//                DataManager.shared.settingAparts[indexPath.row].ldrAssignToSetApart = DashboardViewController.leader
//            }
//
//            cell.configureCell(segCntrlHidden: true, nxtActBtnTitle: "Member Set Apart", nxtActBtnSegCntrlTag: ActionSectionsIdentifiers.setApart.identifierIntValue + indexPath.row, callAcceptedIdx: ActionSectionsIdentifiers.setApart.identifierIntValue + indexPath.row, ldrAssignLblText: "Leader To Set Apart: \(DataManager.shared.settingAparts[indexPath.row].ldrAssignToSetApart)", org: organization, call: calling, mbr: member)
//
//        case ACSSSegmentControlSegments.released.rawValue:
//            setOrgMbrCallingValues(org: "\t" + DataManager.shared.membersNeedingToBeReleased[indexPath.row].organizationName, call: "\t" + DataManager.shared.membersNeedingToBeReleased[indexPath.row].callingName, mbr: "\t" + DataManager.shared.membersNeedingToBeReleased[indexPath.row].memberToBeReleased)
//
//            cell.configureCell(segCntrlHidden: true, nxtActBtnTitle: "Member Released", nxtActBtnSegCntrlTag: ActionSectionsIdentifiers.released.identifierIntValue + indexPath.row, callAcceptedIdx: ActionSectionsIdentifiers.released.identifierIntValue + indexPath.row, ldrAssignLblText: "", org: organization, call: calling, mbr: member)
//
//        default:
//            break
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        headerView.backgroundColor = #colorLiteral(red: 0.3728647232, green: 0.4658383727, blue: 0.8314605355, alpha: 1)
        let button = UIButton(type: .custom)
        button.frame = headerView.bounds
        button.tag = section
        button.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
        
        button.setTitle(headers[section], for: .normal)
        
        headerView.addSubview(button)
        
//        if DataManager.shared.recommendationsForApproval.count == 0 && DataManager.shared.callsToBeExtended.count == 0 && DataManager.shared.toBeSustained.count == 0 && DataManager.shared.settingAparts.count == 0 && DataManager.shared.membersNeedingToBeReleased.count == 0 {
//            actionsTableView.alpha = 0
//        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if shouldAnimate {
            let animation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
    }
}

// MARK: - CloseActionSnapShotViewDelegate

extension ActionsReportViewController: CloseActionSnapShotViewDelegate {
    func closeButtonAction(sender: UIButton) {
        actionsTableView.isHidden = false
    }
}

// MARK: - CallSetApartActionConflictDelegate

extension ActionsReportViewController: CallSetApartActionConflictDelegate {
    func showActionConflictMessage() {
        showCallToSetApartConflictAlert()
    }
    
    func showCallToSetApartConflictAlert() {
        self.present(showAlertController(title: "Action Out of Sequence", message: "This member has not been called yet and connot be set apart.", style: .alert, hasTableView: false, actionTitle1: "Ok", actionStyle1: .default, actionTitle2: "", actionStyle2: .default, sender: tabBarView, addActionAction: nil), animated: true, completion: nil)
    }
}

// MARK: - SnapshotTabBarActionDelegate

extension ActionsReportViewController: SnapshotTabBarActionDelegate {
    func tabBarAction(sender: UIButton) {
        if sender.titleLabel?.text == TabbarButtonTitles.snapshot.identifierString {
            outstandingLeaderCallingActionsAction()
        }
    }
}

// MARK: - NextActionButtonDelegate

extension ActionsReportViewController: NextActionButtonDelegate {
    func nextActionButtonAction(sender: UIButton) {
        let section = (findSection(with: sender.tag) - 1)
        let row = findRow(with: sender.tag)
        
        let DataManager = DataManager()
        
//        Task.init {
//            var call = [OrgMbrCallingModel]()
//
//            let successful = true//await DataManager.getOrgMbrCallingActions()
//
//            if successful {
//                switch section {
//                case ACSSSegmentControlSegments.recommended.rawValue:
//                    DataManager.recommendationsForApproval[row].approvedDate = convertToString(date: Date(), with: .medium)
//                    call.append(DataManager.recommendationsForApproval[row])
//
//                    currentOrgMbrCallingModel = DataManager.recommendationsForApproval[row]
//
//                    if DataManager.recommendationsForApproval[row].callingName == CallSetApartBishopBranchPresidentOnly.president.rawValue || DataManager.recommendationsForApproval[row].callingName == CallSetApartBishopBranchPresidentOnly.firstAssistant.rawValue || DataManager.recommendationsForApproval[row].callingName == CallSetApartBishopBranchPresidentOnly.secondAssistant.rawValue {
//
//                        if unitType == UnitTypes.ward.stringValue {
//                            updateSelectedAssignment(actionType: .called, assignedLeader: LeadershipPositions.bishop.rawValue, index: row)
//                        } else {
//                            updateSelectedAssignment(actionType: .called, assignedLeader: LeadershipPositions.branchPresident.rawValue, index: row)
//                        }
//                    }
//
//                case ACSSSegmentControlSegments.called.rawValue:
//                    DataManager.callsToBeExtended[row].calledDate = convertToString(date: Date(), with: .medium)
//
//                    callingAcceptedIndex = row
//
//                    currentOrgMbrCallingModel = DataManager.callsToBeExtended[row]
//
//                    if ldrAssignedToCall != "" {
//                        DataManager.callsToBeExtended[row].ldrAssignToCall = ldrAssignedToCall
//                        ldrAssignedToCall = ""
//                    }
//
//                    call.append(DataManager.callsToBeExtended[row])
//
//                case ACSSSegmentControlSegments.sustained.rawValue:
//                    DataManager.toBeSustained[row].sustainedDate = convertToString(date: Date(), with: .medium)
//
//                    currentOrgMbrCallingModel = DataManager.toBeSustained[row]
//
//                    call.append(DataManager.toBeSustained[row])
//
//                    if DataManager.toBeSustained[row].callingName == CallSetApartBishopBranchPresidentOnly.president.rawValue || DataManager.toBeSustained[row].callingName == CallSetApartBishopBranchPresidentOnly.firstAssistant.rawValue || DataManager.toBeSustained[row].callingName == CallSetApartBishopBranchPresidentOnly.secondAssistant.rawValue {
//                        if unitType == UnitTypes.ward.stringValue {
//                            updateSelectedAssignment(actionType: .setApart, assignedLeader: LeadershipPositions.bishop.rawValue, index: row)
//                        } else {
//                            updateSelectedAssignment(actionType: .setApart, assignedLeader: LeadershipPositions.branchPresident.rawValue, index: row)
//                        }
//                    }
//
//                case ACSSSegmentControlSegments.setApart.rawValue:
//                    let setApartDate = convertToString(date: Date(), with: .medium)
//                    DataManager.settingAparts[row].setApartDate = setApartDate
//
//                    currentOrgMbrCallingModel = DataManager.settingAparts[row]
//
//                    if ldrAssignedToSetApart != "" {
//                        DataManager.settingAparts[row].ldrAssignToSetApart = ldrAssignedToSetApart
//                        ldrAssignedToSetApart = ""
//                    }
//
//                    call.append(DataManager.settingAparts[row])
//
//                case ACSSSegmentControlSegments.released.rawValue:
//                    DataManager.membersNeedingToBeReleased[row].releasedDate = convertToString(date: Date(), with: .medium)
//                    call.append(DataManager.membersNeedingToBeReleased[row])
//
//                    if DataManager.recommendationsForApproval.isEmpty && DataManager.callsToBeExtended.isEmpty && DataManager.toBeSustained.isEmpty && DataManager.settingAparts.isEmpty && DataManager.membersNeedingToBeReleased.isEmpty {
//                        noOutstandingActionsLabel.isHidden = false
//                    }
//                    
//                default:
//                    break
//                }
//
//                OrgMbrCallingViewModel.shared.updateCalling(organizationName: call.first?.organizationName ?? "", callingName: call.first?.callingName ?? "", memberName: call.first?.memberName ?? "", approvedDate: call.first?.approvedDate ?? "", calledDate: call.first?.calledDate ?? "", sustainedDate: call.first?.sustainedDate ?? "", setApartDate: call.first?.setApartDate ?? "", releaseDate: call.first?.releasedDate ?? "", recommendedDate: call.first?.recommendedDate ?? "", memberToBeReleased: call.first?.memberToBeReleased ?? "", ldrAssignToCall: call.first?.ldrAssignToCall ?? "", ldrAssignToSetApart: call.first?.ldrAssignToSetApart ?? "", callingPreviouslyFilledDate: call.first?.callingPreviouslyFilledDate ?? "", callingDisplayIndex: call.first?.callingDisplayIndex ?? "")
//
//                Task.init {
//                    OrgMbrCallingViewModel.shared.orgMbrCallings = await OrgMbrCallingViewModel.shared.getOrgMbrCallings()
//                }
//            }
//        }
    }
}

// MARK: - AcceptDeclineCallSegmentControlDelegate

extension ActionsReportViewController: AcceptDeclineCallSegmentControlDelegate {
    func acceptedOrDeclinedCallSegmentControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == MembersAcceptedCallingResponse.yes.rawValue {
            callingAcceptedIndex = sender.tag
            shouldAnimate = false
            actionsTableView.reloadData()
        } else {
//            callingAcceptedIndex = -1
//            anotherRecommendationNeeded = true
//            shouldAnimate = true
//            
//            let index = getIndexForSelected(organization: callsToBeExtended[findRow(with: sender.tag)].organizationName, calling: callsToBeExtended[findRow(with: sender.tag)].callingName, member: callsToBeExtended[findRow(with: sender.tag)].memberName)
//            
//            OrgMbrCallingViewModel.shared.orgMbrCallings[index].memberName = OrgMbrCallingViewModel.shared.orgMbrCallings[index].memberToBeReleased ?? ""
//            OrgMbrCallingViewModel.shared.orgMbrCallings[index].recommendedDate = OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingPreviouslyFilledDate ?? ""
//            OrgMbrCallingViewModel.shared.orgMbrCallings[index].approvedDate = OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingPreviouslyFilledDate ?? ""
//            OrgMbrCallingViewModel.shared.orgMbrCallings[index].calledDate = OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingPreviouslyFilledDate ?? ""
//            OrgMbrCallingViewModel.shared.orgMbrCallings[index].sustainedDate = OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingPreviouslyFilledDate ?? ""
//            
//            OrgMbrCallingViewModel.shared.updateCalling(organizationName: OrgMbrCallingViewModel.shared.orgMbrCallings[index].organizationName ?? "", callingName: OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingName ?? "", memberName: OrgMbrCallingViewModel.shared.orgMbrCallings[index].memberName ?? "", approvedDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].approvedDate ?? "", calledDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].calledDate ?? "", sustainedDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].sustainedDate ?? "", setApartDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].setApartDate ?? "", releaseDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].releasedDate ?? "", recommendedDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].recommendedDate ?? "", memberToBeReleased: OrgMbrCallingViewModel.shared.orgMbrCallings[index].memberToBeReleased ?? "", ldrAssignToCall: "", ldrAssignToSetApart: "", callingPreviouslyFilledDate: OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingPreviouslyFilledDate ?? "", callingDisplayIndex: OrgMbrCallingViewModel.shared.orgMbrCallings[index].callingDisplayIndex ?? "")
//            
//            callsToBeExtended.remove(at: findRow(with: sender.tag))
//            
//            actionsTableView.reloadData()
        }
    }
}
