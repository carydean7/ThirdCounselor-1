//
//  SpeakingAssignmentsViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/27/22.
//

import SwiftUI
import UIKit
import WebKit

class SpeakingAssignmentsViewController: BaseViewController, InformationAlertDelegate {
    @ObservedObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addSpeakingAssignmentContainerView: UIView!
    @IBOutlet weak var speakingAssignmentsTableView: UITableView!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var selectedMemberLabel: UILabel!
    @IBOutlet weak var topicReferenceSegmentControl: UISegmentedControl!
    @IBOutlet weak var manualEntryTopicTextField: UITextField!
    @IBOutlet weak var cancelDoneButton: UIButton!
    @IBOutlet weak var filterMenuButton: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    
    var name = ""
    var alert: UIAlertController?
    var membersTableView: UITableView?
    var closeButton: UIButton?
    var sundays = [String]()
    var selectedSunday = Date()
    var isEditMode = false
    var keyboardIsShowing = false
    var addSpeakingAssignmentContainerViewOriginalFrame: CGRect?
    var assignments = [[String: String]]()
    var filteredMembers = [[[String: Any]]]()
    var shouldAnimateTableView = true
    var showCallingInCell = false
    var selectedMemberRow = -1
    var selectedMemberFromSection = -1
    var selectedSpeakerTopic = ""
    var infoAlert: UIAlertController?
    
    let contentView = UIHostingController(rootView: SpeakingAssignmentsView(orgMbrCallingViewModel: OrgMbrCallingViewModel.shared, membersViewModel: MembersViewModel.shared))
        
    static var selectedFilteredAction = ""
    static var selectedTitle = ""
    static var name = ""
    static var sundaySpeakingDate = Date()
    static var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.infoAlertDelegate = self
        
        MembersViewController.membersListLoadedFromMembersViewController = false
                        
        setViewModelFlags()
        
        addChild(contentView)
        contentView.view.frame = tableViewContainerView.bounds
        tableViewContainerView.addSubview(contentView.view)
        contentView.didMove(toParent: self)
        
        infoContentView.view.layer.cornerRadius = 25.0
        
        setupConstraints(contentView: contentView.view, top: 0, bottom: 0, left: 0, right: 0, height: 0, needsBottom: true, needsHeight: false, equalToView: self.view)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setViewModelFlags() {
        MembersViewModel.shared.shouldShowAddItemButton = false
        MembersViewModel.shared.showDeleteMember = false
        MembersViewModel.shared.isSheet = true
        OrgMbrCallingViewModel.shared.changeInCalling = false
        SpeakingAssignmentsViewModel.shared.memberAskedToSpeak = true
        SpeakingAssignmentsViewModel.shared.shouldShowAddItemButton = true
    }
        
    @objc private func keyboardWillShow(sender: NSNotification) {
        if let _ = self.manualEntryTopicTextField?.text?.isEmpty {
            if let _ = self.manualEntryTopicTextField?.text?.isEmpty {
                if !keyboardIsShowing {
                    self.keyboardIsShowing = true
                }
            } else {
                keyboardIsShowing = false
            }
        }
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        keyboardIsShowing = false
    }
    
    func speakingAssignmentComplete() -> Bool {
        var hasMemberAssigned = false
        var hasSacramentDate = false
        var hasTopic = false
        
        if !(selectedMemberLabel.text?.isEmpty ?? false) {
            hasMemberAssigned = true
        }
        
        if !(manualEntryTopicTextField.text?.isEmpty ?? false) {
            hasTopic = true
        }
        
        if !(selectedDateLabel.text?.isEmpty ?? false) {
            hasSacramentDate = true
        }
        
        if hasMemberAssigned && hasSacramentDate && hasTopic {
            return true
        }
        
        return false
    }
    
    @IBAction func topicTextFieldValueChanged(_ sender: UITextField) {
        if !(sender.text?.isEmpty ?? false) {
            if speakingAssignmentComplete() {
                let checkmarkConfig = UIImage.SymbolConfiguration(weight: .bold)
                let checkmarkSearch = UIImage(systemName: "checkmark.circle", withConfiguration: checkmarkConfig)
                
                self.cancelDoneButton.setImage(checkmarkSearch, for: .normal)
            }
        } else {
            cancelDoneButton.setTitle("Cancel", for: .normal)
        }
    }
    
    
    func showSelectionAlert(sender: UIButton) {
        alert = UIAlertController(title: "Select a Member\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert?.view.frame = CGRect(x: 0, y: 40, width: 250, height: 350)
        alert?.view.addSubview(membersTableView ?? UITableView())
        
        createAlertCloseButton()
        
        alert?.view.addSubview(closeButton ?? UIButton())
        
        alert?.overrideUserInterfaceStyle = .light
        
        membersTableView?.reloadData()
        
        if let presenter = alert?.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        self.present(alert ?? UIAlertController(), animated: true, completion: nil)
    }
    
    func createAlertCloseButton() {
        closeButton = UIButton(frame: CGRect(x: (alert?.view.frame.width ?? 200) + 100, y: 0, width: 40, height: 40))
        
        let closeConfig = UIImage.SymbolConfiguration(weight: .bold)
        let closeSearch = UIImage(systemName: "xmark", withConfiguration: closeConfig)
        
        closeButton?.setImage(closeSearch, for: .normal)
        
        closeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        closeButton?.setTitleColor(.white, for: .normal)
        
        closeButton?.tintColor = .white
        
        closeButton?.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
    }
    
    @objc func closeAlert() {
        alert?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SpeakingAssignmentsViewController.name = selectedMemberLabel.text ?? ""
        SpeakingAssignmentsViewController.sundaySpeakingDate = selectedSunday
        SpeakingAssignmentsViewController.selectedDate = convertToDate(stringDate: selectedDateLabel.text ?? "")
    }
    
    func showInfoAlert() {
        infoAlert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        guard let alertView = infoAlert?.view else { return }
        
        let widthConstraints = alertView.constraints.filter({ return $0.firstAttribute == .width })
        
        alertView.overrideUserInterfaceStyle = .light
        
        alertView.removeConstraints(widthConstraints)
        
        // Here you can enter any width that you want
        let newWidth = UIScreen.main.bounds.width * 0.90
        // Adding constraint for alert base view
        let widthConstraint = NSLayoutConstraint(item: alertView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: newWidth)
        alertView.addConstraint(widthConstraint)
        
        let newHeight = UIScreen.main.bounds.height * 0.70
        let heightConstraint = NSLayoutConstraint(item: alertView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: newHeight)
        
        alertView.addConstraint(heightConstraint)
        
        let firstContainer = alertView.subviews[0]
        
        // Finding first child width constraint
        let constraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        firstContainer.removeConstraints(constraint)
        // And replacing with new constraint equal to alert.view width constraint that we setup earlier
        alertView.addConstraint(NSLayoutConstraint(item: firstContainer,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: alertView,
                                                   attribute: .width,
                                                   multiplier: 1.0,
                                                   constant: 0))
        
        let innerBackground = firstContainer.subviews[0]
        let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
        innerBackground.removeConstraints(innerConstraints)
        firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: firstContainer,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0))
        
        infoAlert?.view.addSubview(infoContentView.view)
        infoAlert?.view.layer.cornerRadius = 25.0
        
        infoContentView.view.translatesAutoresizingMaskIntoConstraints = false
        infoContentView.view.topAnchor.constraint(equalTo: alertView.topAnchor, constant: -80.0).isActive = true
        infoContentView.view.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 0.0).isActive = true
        infoContentView.view.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: 0.0).isActive = true
        infoContentView.view.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -45.0).isActive = true
        
        infoAlert?.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
            self.infoAlert?.dismiss(animated: true)
        }))
                
        //Showing the UIAlertView
        self.present(infoAlert ?? UIAlertController(), animated: true)
    }
}
