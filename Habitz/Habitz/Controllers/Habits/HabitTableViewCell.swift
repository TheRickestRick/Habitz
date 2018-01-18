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
        let parentGoal = goals.first(where: { (goal) -> Bool in
            return goal.id == habit.goalId
        })
        
        var goalHabitsAll: [Habit]? = nil
        var goalHabitsCompleted: [Habit]? = nil
        
        
        // mark as complete or incomplete based on the change of state in the checkbox
        if completeCheckBox.on {
            
            // update database for completion status
            habitsAPI.markComplete(habit, completion: {
                
                // get ALL goals belonging to that habit
                self.habitsAPI.getAllForGoal(havingId: parentGoal!.id!, completion: { (habits) in
                    goalHabitsAll = habits
                    
                    guard let goalHabitsCompleted = goalHabitsCompleted else { return }
                    guard let parentGoal = parentGoal else {return}
                    
                    // check if the habit is complete based on all habits and completed habits
                    // but only if both api calls are completed
                    if parentGoal.isCompleteHaving(all: goalHabitsAll!, completed: goalHabitsCompleted) {
                        self.updateGoalCompleteStatus(for: parentGoal, updateTo: true, apiMethod: { (goal) in
                            self.goalsAPI.markComplete(goal)
                        })
                    }
                })
                
                // get only completed goals beloging to that habit
                self.completedHabitsAPI.getTodaysCompletionsForGoal(havingId: parentGoal!.id!, completion: { (completedHabits) in
                    goalHabitsCompleted = completedHabits
                    
                    guard let goalHabitsAll = goalHabitsAll else { return }
                    guard let parentGoal = parentGoal else {return}
                    
                    // check if the habit is complete based on all habits and completed habits
                    // but only if both api calls are completed
                    if parentGoal.isCompleteHaving(all: goalHabitsAll, completed: goalHabitsCompleted!) {
                        self.updateGoalCompleteStatus(for: parentGoal, updateTo: true, apiMethod: { (goal) in
                            self.goalsAPI.markComplete(goal)
                        })
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
                //TODO: TODO - check if the goal is now incompleted
                print("mark as incomplete")
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
    func updateGoalCompleteStatus(for goal: Goal, updateTo isComplete: Bool, apiMethod: (_ goal: Goal) -> Void) {
        goal.isComplete = isComplete
        apiMethod(goal)
    }
}
