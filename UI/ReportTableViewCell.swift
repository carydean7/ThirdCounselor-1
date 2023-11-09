//
//  ReportTableViewCell.swift
//  3rdCounselor
//
//  Created by Dean Wagstaff on 12/16/21.
//

import UIKit

protocol ActionsButtonDelegate {
    func actionsButtonPressed(button: UIButton) async
}

protocol AcceptedDeclinedCallSegmentControlDelegate {
    func acceptedOrDeclinedCallSegmentControlValueChanged(sender: UISegmentedControl)
}

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var callingLabel: UILabel!
    @IBOutlet weak var actionsButton: UIButton!
    @IBOutlet weak var ldrAssignToActionLabel: UILabel!
    @IBOutlet weak var acceptDeclineCallSegmentControl: UISegmentedControl!
    
    var actionButtonDelegate: ActionsButtonDelegate?
    var acceptDeclineCallSegmentControlDelegate: AcceptedDeclinedCallSegmentControlDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        actionsButton.layer.cornerRadius = 15.0
        actionsButton.layer.borderColor = actionsButton.titleLabel?.textColor.cgColor
        actionsButton.layer.borderWidth = 2.0
    }
    
    @IBAction func acceptDeclineCallSegmentControlValueChanged(_ sender: UISegmentedControl) {
        self.acceptDeclineCallSegmentControlDelegate?.acceptedOrDeclinedCallSegmentControlValueChanged(sender: sender)
    }
    
    @IBAction func actionsButtonPressedAction(_ sender: UIButton) {
        Task.init {
            await self.actionButtonDelegate?.actionsButtonPressed(button: sender)
        }
    }
}
