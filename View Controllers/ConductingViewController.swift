//
//  ConductingViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/30/22.
//

import SwiftUI
import UIKit

@MainActor class ConductingViewController: BaseViewController, InformationAlertDelegate {
    @IBOutlet weak var backButton: UIButton!
    
    var membersTableView: UITableView?
    var hymnsTableView: UITableView?
    
    var labelUpperSectionContent: UILabel?
    var labelLowerSectionContent: UILabel?
    var sectionTitleLabel: UILabel?

    var editConfig: UIImage.SymbolConfiguration?
    
    var closeButton: UIButton?
    var editButton: UIButton?
    var addAnnouncementButton: UIButton?
    var addNewMemberButton: UIButton?
    var specialMusicOrIntermediateHymnButton: UIButton?
    
    static var containerViewFrame: CGRect = .zero

    var selectedLeaderPosition = ""
    var leaderPickerView: UIPickerView?
    var leader: (organization: String, position: String) = (organization: "", position: "")
    var upperSectionLabels = [UILabel?](repeating: nil, count: 9)
    var lowerSectionLabels = [UILabel?](repeating: nil, count: 9)
    
    var sectionView: UIView?
    var emptyView: UIView?
    var titleUnderlineView: UIView?
    
    var alert: UIAlertController?
    
    var songForSection = 0
    
    var orgMbrCallingViewModel = OrgMbrCallingViewModel.shared
    var membersViewModel = MembersViewModel.shared
    var speakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared
    var conductingSheetViewModel = ConductingSheetViewModel.shared
    var hymnsViewModel = HymnsViewModel.shared

    var showHymnsTableView = false
    var pickerHasPresidingData = false
    var reduceIPadFontSize = false
    var keyboardIsShowing = false
    var announcementsViewCreated = false
    var needsHeight = false
    var needsBottom = false
    var height = 0
    var infoAlert: UIAlertController?
        
    static var selectedCarouselViewIndex = 0
    static var presidingAuthorityName = ""
    
    let originalTableViewFullWidthSize = 260
    let originalTableViewFullHeightSize = 175
    let originalLabelViewFullHeightSize = 125
    let originaliPadTableViewFullHeightSize = 225
    
    let contentView = UIHostingController(rootView: ConductingSheetListView())
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.infoAlertDelegate = self
        
        addChild(contentView)
        contentView.view.frame = tableViewContainerView.bounds
        tableViewContainerView.addSubview(contentView.view)
        contentView.didMove(toParent: self)

        if !appDelegate.isLandscape && Constants.deviceIdiom == .pad {
            contentView.view.layer.cornerRadius = 15.0
            needsHeight = true
            needsBottom = true
            height = Int(tableViewContainerView.frame.height)
        }

        setupConstraints(contentView: contentView.view, top: 0, bottom: 0, left: 0, right: 0, height: 0, needsBottom: needsBottom, needsHeight: needsHeight, equalToView: self.view)
        
        ConductingViewController.containerViewFrame = tableViewContainerView.frame
        
        addObservers()
        createPickers()
                
        speakingAssignmentsViewModel.setSpeakingAssignmentSundayRelatedData()

        conductingSheetViewModel.setSpeakingAssignmentsForCurrentWeekNumber(week: speakingAssignmentsViewModel.currentWeek)
        conductingSheetViewModel.setConductingSheetSection()

        if orgMbrCallingViewModel.membersNeedingToBeReleasedCount == 0 || orgMbrCallingViewModel.membersNeedingToBeSustainedCount == 0 {
            orgMbrCallingViewModel.fetchData {
                self.orgMbrCallingViewModel.getOrgMbrCallingActions(forMe: false,
                                                                    leader: "",
                                                                    byOrganization: false,
                                                                    organization: "") { results in
                }
            }
        }
        
        setViewModelFlags()
    }
        
    func setViewModelFlags() {
        ConductingSheetViewModel.shared.shouldShowAddItemButton = true
        ConductingSheetViewModel.shared.showDeleteMember = false
        ConductingSheetViewModel.shared.isSheet = true
    }
    
    func createPickers() {
        leaderPickerView = UIPickerView(frame: CGRect(x: 5, y: 60, width: 250, height: 140))
    }
    
    func addObservers() {
    //    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        keyboardIsShowing = false
    }
    
    func setFontTextStyle(objectType: FontTextStylesTypes) -> UIFont.TextStyle {
        var fontTextStyle: UIFont.TextStyle = .body

        switch objectType {
        case .buttonTitleLabelFontTextStyle:
            switch (Constants.deviceIdiom) {
            case .pad:
                fontTextStyle = reduceIPadFontSize ? .caption1 : .subheadline
            case .phone:
                fontTextStyle = .footnote
            default:
                print("Unspecified UI idiom")
            }

        case .carouselSectionViewTitleFontTextStyle:
            switch (Constants.deviceIdiom) {
            case .pad:
                fontTextStyle = reduceIPadFontSize ? .footnote : .largeTitle
            case .phone:
                fontTextStyle = .title3
            default:
                print("Unspecified UI idiom")
            }

        case .tableSectionTitleFontTextStyle:
            switch (Constants.deviceIdiom) {
            case .pad:
                fontTextStyle = reduceIPadFontSize ? .footnote : .title3
            case .phone:
                fontTextStyle = .body
            default:
                print("Unspecified UI idiom")
            }

        case .upperLowerLabelFontTextStyle:
            switch (Constants.deviceIdiom) {
            case .pad:
                fontTextStyle = reduceIPadFontSize ? .footnote : .title3
            case .phone:
                fontTextStyle = .body
            default:
                print("Unspecified UI idiom")
            }

        case .tableCellLabelFontTextStyle:
            switch (Constants.deviceIdiom) {
            case .pad:
                fontTextStyle = reduceIPadFontSize ? .footnote : .callout
            case .phone:
                fontTextStyle = .footnote
            default:
                print("Unspecified UI idiom")
            }

        case .pickerLabelFontTextStyle:
            switch (Constants.deviceIdiom) {
            case .pad:
                fontTextStyle = reduceIPadFontSize ? .callout : .title3
            case .phone:
                fontTextStyle = .subheadline
            default:
                print("Unspecified UI idiom")
            }

        }

        return fontTextStyle
    }
        
    func showSelectionAlert(sender: UIView, alertTitle: String, tableView: UITableView) {
        if tableView.isHidden {
            tableView.isHidden = false
        }
        
        alert = UIAlertController(title: "Select a \(alertTitle)\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
                
        if let alert = alert, let alertView = alert.view {
            let widthConstraints = alertView.constraints.filter({ return $0.firstAttribute == .width })
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
            let firstContainer = alert.view.subviews[0]
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
            // Same for the second child with width constraint with 998 priority
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
            
            alertView.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 60.0).isActive = true
            tableView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 20.0).isActive = true
            tableView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -20.0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0.0).isActive = true
        }
        
        createAlertCloseButton()
        
        alert?.view.addSubview(closeButton ?? UIButton())
        
        alert?.overrideUserInterfaceStyle = .light
        
        tableView.reloadData()
        
        switch (Constants.deviceIdiom) {
        case .pad:
            if let alert = alert {
                alert.popoverPresentationController?.backgroundColor = #colorLiteral(red: 0.5731869936, green: 0.6621800661, blue: 0.8088998795, alpha: 1)
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 20.0, width: 800, height: 350)
                alert.popoverPresentationController?.permittedArrowDirections = []
                
                self.present(alert, animated: true)
            }
        case .phone:
            if let presenter = alert?.popoverPresentationController {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
            }
            
            self.present(alert ?? UIAlertController(), animated: true, completion: nil)
        default:
            print("Unspecified UI idiom")
        }
    }
    
    func createAlertCloseButton() {
        closeButton = UIButton(frame: CGRect(x:5, y: 0, width: 40, height: 40))
        
        let closeConfig = UIImage.SymbolConfiguration(weight: .bold)
        let closeSearch = UIImage(systemName: "xmark", withConfiguration: closeConfig)
        
        closeButton?.setImage(closeSearch, for: .normal)
        
        closeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        closeButton?.setTitleColor(.black, for: .normal)
        
        closeButton?.tintColor = .black
        
        closeButton?.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
    }
    
    @objc func closeAlert() {
        alert?.dismiss(animated: true, completion: nil)
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
