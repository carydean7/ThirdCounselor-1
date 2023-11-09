//
//  AssignedInterviewsTableViewCell.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/17/22.
//

import UIKit

class AssignedInterviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var labelInterviewType: UILabel!
    @IBOutlet weak var labelAssignedLeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
