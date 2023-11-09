//
//  SplashScreenViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/7/23.
//

import UIKit
import SwiftUI

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    var secondsRemaining = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let img1 = UIImage(named: "SplashScreen-1.png") else { return }
        guard let img2 = UIImage(named: "SplashScreen-2.png") else { return }
        guard let img3 = UIImage(named: "SplashScreen-3.png") else { return }
        guard let img4 = UIImage(named: "SplashScreen-4.png") else { return }
        
        logoImageView.animationImages = [img1, img2, img3, img4]
        
        logoImageView.animationRepeatCount = 5
        logoImageView.animationDuration = 0.5
        
        logoImageView.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                if AppDelegate.unitType.isEmpty && AppDelegate.leader.isEmpty && AppDelegate.unitNumber.isEmpty {
                    let contentView = UIHostingController(rootView: StakeUnitLeaderPositionView(forPreLogin: true, nextActionHandler: { isValid in
                        if isValid {
                            Timer.invalidate()
                                                        
                            NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.fetchOrgMbrCalling.stringValue), object: nil)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                            vc.modalTransitionStyle = .crossDissolve
                            self.present(vc, animated: true) {
                                
                            }
                        } else {
                            let alertController = UIAlertController(title: "Missing Or Incorrect Information", message: "Unit Type / Number and Leadership Position Required", preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
                            
                            alertController.addAction(OKAction)
                            
                            self.present(alertController, animated: true, completion:nil)
                        }
                    }))
                    
                    self.addChild(contentView)
                    contentView.view.frame = self.view.bounds
                    self.view.addSubview(contentView.view)
                    contentView.didMove(toParent: self)
                    
                    self.setupConstraints(contentView: contentView.view, top: 0, bottom: 0, left: 0, right: 0, height: 0, needsBottom: true, needsHeight: false, equalToView: self.view)
                    
                    Timer.invalidate()
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true) {
                        
                    }
                }
                
                self.secondsRemaining = 3
            }
        }
    }
    
    func setupConstraints(contentView: UIView, top: Int, bottom: Int, left: Int, right: Int, height: Int, needsBottom: Bool, needsHeight: Bool, equalToView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: equalToView.topAnchor, constant: CGFloat(top)).isActive = true
        
        if needsBottom {
            contentView.bottomAnchor.constraint(equalTo: equalToView.bottomAnchor, constant: CGFloat(bottom)).isActive = true
        }
        
        if needsHeight {
            contentView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        }
        
        contentView.leftAnchor.constraint(equalTo: equalToView.leftAnchor, constant: CGFloat(left)).isActive = true
        contentView.rightAnchor.constraint(equalTo: equalToView.rightAnchor, constant: CGFloat(right)).isActive = true
    }
}
