//
//  GoalTableViewCell.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import BEMCheckBox

class GoalTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var completedStreakLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completeCheckBox: BEMCheckBox!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        completeCheckBox.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
