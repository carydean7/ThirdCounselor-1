//
//  ReportsViewController_Extension.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/28/22.
//

import Foundation
import UIKit

extension ReportsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportTypes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
        let color = UIColor(Branding.mock.labels)
        cell.createCustomCellDisclosureIndicator(chevronColor: color)
        
        cell.textLabel?.text = ReportTypes.allCases[indexPath.row].stringValue
        cell.textLabel?.textColor = UIColor(Branding.mock.labels)
        cell.accessoryType = .disclosureIndicator
        
        switch (Constants.deviceIdiom) {
        case .pad:
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        case .phone:
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        default:
            break
        }
        
        tableView.separatorColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch ReportTypes.allCases[indexPath.row].stringValue {
        case ReportTypes.callingByOrganization.stringValue:
           // OrganizationsViewModel.organizationsForCallingsIsFocus = false
            performSegue(withIdentifier: Identifiers.organizationalReportViewController.identifierString, sender: self)
        case ReportTypes.callingByActionType.stringValue:
            performSegue(withIdentifier: Identifiers.actionsReportViewController.identifierString, sender: self)
        case ReportTypes.speakingAssignmentsAndTopics.stringValue:
            performSegue(withIdentifier: Identifiers.speakingAssignmentsViewController.identifierString, sender: self)
        case ReportTypes.conducting.stringValue:
            performSegue(withIdentifier: Identifiers.conductingViewController.identifierString, sender: self)
        case ReportTypes.assignments.stringValue:
            performSegue(withIdentifier: Identifiers.assignmentsViewController.identifierString, sender: self)
        case ReportTypes.prayers.stringValue:
            performSegue(withIdentifier: Identifiers.prayersViewController.identifierString, sender: self)
        case ReportTypes.ordinations.stringValue:
            performSegue(withIdentifier: Identifiers.ordinationsViewController.identifierString, sender: self)
        case ReportTypes.announcements.stringValue:
            performSegue(withIdentifier: Identifiers.announcementsViewController.identifierString, sender: self)
        default:
            break
        }
    }
}

extension UITableViewCell {
    func createCustomCellDisclosureIndicator(chevronColor: UIColor) {
        //MARK: Custom Accessory View
        //Chevron img
        if #available(iOS 13.0, *) {
            let chevronConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
            guard let chevronImg = UIImage(systemName: "chevron.right", withConfiguration: chevronConfig)?.withTintColor(chevronColor, renderingMode: .alwaysTemplate) else { return }
            let chevron = UIImageView(image: chevronImg)
            chevron.tintColor = chevronColor
 
            //chevron view
            let accessoryViewHeight = self.frame.height
            let customDisclosureIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: accessoryViewHeight))
            customDisclosureIndicator.addSubview(chevron)
 
            //chevron constraints
            chevron.translatesAutoresizingMaskIntoConstraints = false
            chevron.trailingAnchor.constraint(equalTo: customDisclosureIndicator.trailingAnchor,constant: 0).isActive = true
            chevron.centerYAnchor.constraint(equalTo: customDisclosureIndicator.centerYAnchor).isActive = true
 
            //Assign the custom accessory view to the cell
            customDisclosureIndicator.backgroundColor = .clear
            self.accessoryView = customDisclosureIndicator
        } else {
            self.accessoryType = .disclosureIndicator
            self.accessoryView?.tintColor = chevronColor
        }
    }
}
