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
    var goals: [Goal] = []
    
    let completedHabitsAPI = CompletedHabitsAPI()
    let habitsAPI = HabitsAPI()
    
    var habitCompletionUpdateDelegate: HabitCompletionUpdateDelegate?
    
    
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
        guard let habit = habit, let habitCompletionUpdateDelegate = habitCompletionUpdateDelegate else {return}
        
        // mark as complete or incomplete based on the change of state in the checkbox
        if completeCheckBox.on {
            // update database for completion status
            habitsAPI.markComplete(habit, completion: { () in
                
                //TODO: TODO - check if the goal is completed
                // get the goal that owns this habit
                let parentGoal = self.goals.first(where: { (goal) -> Bool in
                    return goal.id == habit.goalId
                })
                
                
                // get that goal's associated habits
                var goalHabitsAll: [Habit] = []
                self.habitsAPI.getAllForGoal(havingId: parentGoal!.id!, completion: { (habits) in
                    goalHabitsAll = habits
                })
                
                // get that goal's completed habits
                // let goalHabitsCompleted =
                var goalHabitsCompleted: [Habit] = []
                self.completedHabitsAPI.getTodaysCompletionsForGoal(havingId: parentGoal!.id!, completion: { (completedHabits) in
                    goalHabitsCompleted = completedHabits
                })
                
                // if it is complete
                print(parentGoal?.checkIsComplete(allHabits: goalHabitsAll, completedHabits: goalHabitsCompleted))
                
                // update the goal's isCompleted status
                // parentGoal?.isComplete = true
                
                // update the db
                
                // refresh the goals table
            })
            
            
            // increase habit streak for vc and to database
            self.completedStreakLabel.text = "(\(habit.completedStreak + 1))"
            habit.completedStreak += 1
            habitsAPI.edit(habit: habit)
            
            
            
            // update table vc for completion status
            habitCompletionUpdateDelegate.toggleCompletion(for: habit)
            
        } else {
            // update database for completion status
            habitsAPI.markIncomplete(habit)
            
            
            // decrease habit streak for vc and to database
            if habit.completedStreak > 0 {
                self.completedStreakLabel.text = "(\(habit.completedStreak - 1))"
                habit.completedStreak -= 1
                habitsAPI.edit(habit: habit)
            }
            
            
            
            //TODO: TODO - check if the goal is now incompleted
            
            
            
            // update table vc for completion status
            habitCompletionUpdateDelegate.toggleCompletion(for: habit)
        }
    }
}
