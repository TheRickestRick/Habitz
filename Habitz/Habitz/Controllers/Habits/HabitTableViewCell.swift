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
    
    let goalsAPI = GoalsAPI()
    let habitsAPI = HabitsAPI()
    let completedHabitsAPI = CompletedHabitsAPI()
    
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
        
        
        // for updating goal isComplete status
        // get the goal that owns this habit
        guard let parentGoal = goals.first(where: { (goal) -> Bool in
            return goal.id == habit.goalId
        }) else { return }
        
        
        // mark as complete or incomplete based on the change of state in the checkbox
        if completeCheckBox.on {
            
            // update database for completion status
            habitsAPI.markComplete(habit, completion: {
                
                // check if the goal is completed or not
                // get ALL goals and completed goals belonging to the parent habit
                self.getHabits(for: parentGoal, completion: { (allHabits, completedHabits) in
                    
                    // if the goal is not complete based on its habits
                    // set the isComplete status and update the database
                    if parentGoal.isCompleteHaving(all: allHabits, completed: completedHabits) {
                        parentGoal.isComplete = true
                        self.goalsAPI.markComplete(parentGoal)
                    }
                })
                
            })
            
            // increase habit streak for vc and to database
            self.completedStreakLabel.text = "(\(habit.completedStreak + 1))"
            habit.completedStreak += 1
            habitsAPI.edit(habit: habit)
            
            
            // update table vc for completion status
            habitCompletionUpdateDelegate.toggleCompletion(for: habit)
            
        } else {
            // update database for completion status
            habitsAPI.markIncomplete(habit, completion: {
                
                // check if the goal is completed or not
                // get ALL goals and completed goals belonging to the parent habit
                self.getHabits(for: parentGoal, completion: { (allHabits, completedHabits) in
                    
                    // if the goal is not complete based on its habits
                    // set the isComplete status and update the database
                    if !parentGoal.isCompleteHaving(all: allHabits, completed: completedHabits) {
                        parentGoal.isComplete = false
                        self.goalsAPI.markIncomplete(parentGoal)
                    }
                })
                
            })
            
            // decrease habit streak for vc and to database
            if habit.completedStreak > 0 {
                self.completedStreakLabel.text = "(\(habit.completedStreak - 1))"
                habit.completedStreak -= 1
                habitsAPI.edit(habit: habit)
            }
            
            // update table vc for completion status
            habitCompletionUpdateDelegate.toggleCompletion(for: habit)
        }
    }
    
    //MARK: - Private
    func getHabits(for goal: Goal, completion: @escaping (_ all: [Habit], _ completed: [Habit]) -> ()) {
        // get ALL goals belonging to that habit
        habitsAPI.getAllForGoal(havingId: goal.id!, completion: { (habits) in
            let allHabits = habits
            
            // get only completed goals beloging to that habit
            self.completedHabitsAPI.getTodaysCompletionsForGoal(havingId: goal.id!, completion: { (habits) in
                let completedHabits = habits
                
                completion(allHabits, completedHabits)
            })
        })
    }
    
}
