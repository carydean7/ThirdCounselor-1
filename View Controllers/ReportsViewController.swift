//
//  ReportsViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/27/22.
//

import UIKit

class ReportsViewController: BaseViewController, InformationAlertDelegate {
    @IBOutlet weak var reportsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewTopWhiteView: UIView!
    
    var infoAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.infoAlertDelegate = self
        
        borderViewTopWhiteView.layer.cornerRadius = 15.0
        
        MembersViewController.membersListLoadedFromMembersViewController = false
        
        reportsTableView.overrideUserInterfaceStyle = .light
        
        reportsTableView.delegate = self
        reportsTableView.dataSource = self
        
        reportsTableView.backgroundColor = .clear
        reportsTableView.backgroundView?.backgroundColor = .clear
        reportsTableView.inputView?.backgroundColor = .clear
        reportsTableView.layer.cornerRadius = 15.0
        reportsTableView.layer.borderColor = UIColor.clear.cgColor
        reportsTableView.layer.borderWidth = 0.5
        
        borderView.layer.cornerRadius = 25.0
        
        var index = 0
        for recommendations in OrgMbrCallingViewModel.shared.recommendationsForApproval {
            if recommendations.recommendations.isEmpty {
                OrgMbrCallingViewModel.shared.recommendationsForApproval.remove(at: index)
                index = 0
            }
            
            index += 1
        }
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
