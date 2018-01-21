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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completeCheckBox: BEMCheckBox!
    @IBOutlet weak var completedStreakCounter: CounterView!
    
    var habit: Habit?
    var goals: [Goal] = []
    
    var habitsManager: HabitsManager?
    var editableTableDelegate: EditableTableDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        completeCheckBox.onAnimationType = BEMAnimationType.bounce
        completeCheckBox.offAnimationType = BEMAnimationType.fade
        
        
        //MARK: Coloring and Styling
        self.backgroundColor = ColorScheme.neutralBackground.value
        
        nameLabel.textColor = ColorScheme.darkText.value
        
        completeCheckBox.onTintColor = ColorScheme.success.value
        completeCheckBox.onCheckColor = ColorScheme.success.value
        
        completeCheckBox.tintColor = ColorScheme.neutral.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func toggleCheckBox(_ sender: BEMCheckBox) {
        guard let habit = habit, let habitsManager = habitsManager, let editableTableDelegate = editableTableDelegate else {return}
        
        
        // for updating goal isComplete status
        // get the goal that owns this habit
        guard let parentGoal = goals.first(where: { (goal) -> Bool in
            return goal.id == habit.goalId
        }) else { return }
        
        
        // mark as complete or incomplete based on the change of state in the checkbox
        if completeCheckBox.on {
            
            // update database for completed habit
            habitsManager.markHabitCompleteFor(completedHabit: habit, withParent: parentGoal)
            editableTableDelegate.editHabit(for: habit)
            
        } else {
            
            // update database and view for missed habit
            habitsManager.markHabitIncomplete(missedHabit: habit, withParent: parentGoal)
            editableTableDelegate.editHabit(for: habit)
        }
    }

}
