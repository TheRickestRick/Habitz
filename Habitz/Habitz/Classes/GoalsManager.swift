//
//  GoalsManager.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation

class GoalsManager  {
    let goalsAPI = GoalsAPI()
        
    // check if the goal is completed or not and make updates to the db necessary
    func updateGoalCompletionStatus(goal: Goal, isComplete: Bool, allHabits: [Habit], completedHabits: [Habit]) -> Void {
        
        if isComplete {
            // if the goal is complete based on its habits, and not currently marked as complete
            if goal.isCompleteHaving(all: allHabits, completed: completedHabits) && !goal.isComplete {
                
                goal.isComplete = true
                goal.completedStreak += 1
                self.goalsAPI.markComplete(goal)
                
            }
        } else {
            // if the goal is not complete based on its habits, and currently marked as complete
            if !goal.isCompleteHaving(all: allHabits, completed: completedHabits) && goal.isComplete {
                
                goal.isComplete = false
                goal.completedStreak -= 1
                self.goalsAPI.markIncomplete(goal)
                
            }
        }
        
        self.goalsAPI.edit(goal: goal)
    }
    
}
