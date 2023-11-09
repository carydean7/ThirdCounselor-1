//
//  HymnsViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/22/22.
//

import SwiftUI
import UIKit
import WebKit

class CellClass: UITableViewCell {
    
}

class HymnsViewController: BaseViewController, InformationAlertDelegate {
    @IBOutlet weak var loadingProgressView: UIView!
    
    let hymnsViewModel = HymnsViewModel.shared

    var loadingProgressViewView: LoadingProgressView?
    var infoAlert: UIAlertController?
    
    static var userTappedOnUpperLabel = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.infoAlertDelegate = self
        
        MembersViewController.membersListLoadedFromMembersViewController = false
        
        addObservers()        
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDownloadDataProgressView), name: NSNotification.Name(NotificationNames.showDownloadDataProgressNotification.stringValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideDownloadDataProgressView), name: NSNotification.Name(NotificationNames.hideDownloadDataProgressNotification.stringValue), object: nil)
    }
    
    deinit {
        removeObserver(self, forKeyPath: NotificationNames.showDownloadDataProgressNotification.stringValue)
        removeObserver(self, forKeyPath: NotificationNames.hideDownloadDataProgressNotification.stringValue)
    }
    
    @objc func delayedFunction() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.hideDownloadDataProgressNotification.stringValue), object: nil)
    }
    
    // MARK: - OBJC Internal Methods
    
    @objc func showDownloadDataProgressView() {
        DispatchQueue.main.async {
            self.loadingProgressViewView = LoadingProgressView(frame: self.loadingProgressView.frame)
            self.loadingProgressViewView?.delegate?.updateProgressView(start: true)
            self.loadingProgressView.addSubview(self.loadingProgressViewView ?? LoadingProgressView())
            self.loadingProgressView.isHidden = false
            self.loadingProgressView.alpha = 0.5
        }
    }
    
    @objc func hideDownloadDataProgressView() {
        DispatchQueue.main.async {
            if self.loadingProgressViewView != nil {
                self.loadingProgressViewView?.delegate?.updateProgressView(start: false)
                self.loadingProgressViewView?.removeFromSuperview()
            }
            
            self.loadingProgressView.isHidden = true
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
