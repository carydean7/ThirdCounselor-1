//
//  ConductingSheetWelcomeSectionTableViewCell.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 7/1/22.
//

import UIKit

class ConductingSheetWelcomeSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var conductingPhraseLabel: UILabel!
    @IBOutlet weak var presidingPhraseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
