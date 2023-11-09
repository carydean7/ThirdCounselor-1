//
//  ActionsReportViewController.swift
//  ThirdCounselorPlus
//
//  Created by Dean Wagstaff on 1/5/22.
//

import SwiftUI
import UIKit

class ActionsReportViewController: BaseViewController, InformationAlertDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var noOutstandingActionsLabel: UILabel!
    
    var recommendationsForApproval = [OrgMbrCalling]()
    var callsToBeExtended = [OrgMbrCalling]()
    var toBeSustained = [OrgMbrCalling]()
    var settingAparts = [OrgMbrCalling]()
    var membersNeedingToBeReleased = [OrgMbrCalling]()
    var organization = ""
    var calling = ""
    var member = ""
    var infoAlert: UIAlertController?

    let contentView = UIHostingController(rootView: ActionsReportListView(membersViewModel: MembersViewModel.shared, orgMbrCallingViewModel: OrgMbrCallingViewModel.shared))
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.infoAlertDelegate = self
        
        MembersViewController.membersListLoadedFromMembersViewController = false
        
        addChild(contentView)
        contentView.view.frame = tableViewContainerView.bounds
        tableViewContainerView.addSubview(contentView.view)
        contentView.didMove(toParent: self)
        
        infoContentView.view.layer.cornerRadius = 25.0

        setupConstraints(contentView: contentView.view, top: 0, bottom: 0, left: 0, right: 0, height: 0, needsBottom: true, needsHeight: false, equalToView: self.view)
    }
    
    // MARK: - Internal Methods
    
    func findSection(with tag: Int) -> Int {
        let tagString = String(tag)
        let sectionString = tagString.prefix(1)
        return Int(sectionString) ?? 0
    }
    
    func findRow(with tag: Int) -> Int {
        let tagString = String(tag)
        
        let tensPlaceString = tagString.prefix(2)
        
        var row = 0
        
        if Int(tensPlaceString.suffix(1)) ?? 0 > Int(0) {
            if let tensPlace = Int(tensPlaceString.prefix(1)) {
                if let lastDigit = Int(tensPlaceString.suffix(1)) {
                    row = tensPlace + lastDigit
                }
            }
        } else {
            row = Int(tagString.suffix(1)) ?? 0
        }
        
        return row
    }
    
    func getIndexForSelected(organization: String, calling: String, member: String) -> Int {
        return 0
    }
        
    func setOrgMbrCallingValues(org: String, call: String, mbr: String) {
        organization = org
        calling = call
        member = mbr
    }

    private func handleCancelCall() {
        print("Member needs to be removed")
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
