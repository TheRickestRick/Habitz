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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completeCheckBox: BEMCheckBox!
    @IBOutlet weak var completedStreakCounterView: CounterView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completeCheckBox.isUserInteractionEnabled = false
        
        
        //MARK: Coloring and Styling
        self.backgroundColor = ColorScheme.neutralBackground.value
        
        nameLabel.textColor = ColorScheme.darkText.value
        nameLabel.font = FontScheme.standard.font
        
        completeCheckBox.onTintColor = ColorScheme.success.value
        completeCheckBox.onCheckColor = ColorScheme.success.value
        
        completeCheckBox.tintColor = ColorScheme.neutral.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }

}
