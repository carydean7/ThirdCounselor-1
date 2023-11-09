//
//  BaseViewController.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/20/23.
//

import SwiftUI
import UIKit

protocol InformationAlertDelegate {
    func showInfoAlert()
}

class BaseViewController: UIViewController {
    static var infoListViewDisplayed = true
    
    @IBOutlet weak var tableViewContainerView: UIView!
    
    var infoButton: UIButton?
    
    var infoAlertDelegate: InformationAlertDelegate?
        
    let defaults = UserDefaults.standard
    
    let infoContentView = UIHostingController(rootView: InfoListView(viewModel: InfoViewModel.shared))

    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
        shouldRotate()
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        supportedInterfaceOrientation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureContainerView(view: tableViewContainerView)
        
        infoButton = UIButton(type: .system)
        infoButton?.frame = CGRect(x: Int(UIScreen.main.bounds.width - 150.0), y: 30, width: 40, height: 40)
        infoButton?.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)

        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let image = UIImage(systemName: "info.circle", withConfiguration: config)
        
        infoButton?.setTitle("Help", for: .normal)
        infoButton?.backgroundColor = UIColor(Branding.mock.backgroundColor)

        infoButton?.configuration = UIButton.Configuration.filled()
        infoButton?.configuration?.image = image
        
        overrideUserInterfaceStyle = .light
        
        self.view.backgroundColor = UIColor(Branding.mock.backgroundColor)
                
        if let infoButton = infoButton {
            self.view.addSubview(infoButton)
        }
    }
    
    @objc func infoButtonAction() {
        self.infoAlertDelegate?.showInfoAlert()
    }
    
    func configureContainerView(view: UIView) {
        view.layer.cornerRadius = 25.0
        view.layer.borderWidth = 0.5
        view.layer.borderColor = CGColor.init(red: 220, green: 100, blue: 50, alpha: 1)
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(Branding.mock.outerHeaderBackgroundColor)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
