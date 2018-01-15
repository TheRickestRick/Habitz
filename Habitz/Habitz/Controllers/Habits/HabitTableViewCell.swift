//
//  HabitViewCell.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import BEMCheckBox

class HabitTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var completedStreakLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completeCheckBox: BEMCheckBox!
    
    var habit: Habit?
    let completionsAPI = CompletionsAPI()
    let habitsAPI = HabitsAPI()
    
    var completionUpdateDelegate: CompletionUpdateDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        completeCheckBox.onAnimationType = BEMAnimationType.bounce
        completeCheckBox.offAnimationType = BEMAnimationType.fade
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleCheckBox(_ sender: BEMCheckBox) {
        guard let habit = habit, let completionUpdateDelegate = completionUpdateDelegate else {return}
        
        // mark as complete or incomplete based on the change of state in the checkbox
        if completeCheckBox.on {
            // update database for completion status
            completionsAPI.markComplete(habit)
            
            
            // increase habit streak for vc and to database
            habit.completedStreak += 1
            habitsAPI.edit(habit: habit)
            
            
            // update table vc for completion status
            completionUpdateDelegate.toggleCompletion(for: habit)
            
        } else {
            // update database for completion status
            completionsAPI.markIncomplete(habit)
            
            
            // decrease habit streak for vc and to database
            if habit.completedStreak > 0 {
                habit.completedStreak -= 1
            }
            habitsAPI.edit(habit: habit)
            
            
            // update table vc for completion status
            completionUpdateDelegate.toggleCompletion(for: habit)
        }
    }
}
