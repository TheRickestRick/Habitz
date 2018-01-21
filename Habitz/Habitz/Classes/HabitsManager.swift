//
//  HabitsManager.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation

class HabitsManager {
    let habitsAPI = HabitsAPI()
    let completedHabitsAPI = CompletedHabitsAPI()
    
    let goalsManager = GoalsManager()
    
    
    //MARK: - CRUD Operations
    func createHabit(for habit: Habit, completion: @escaping (Habit) -> ()) {
        // add new habit to the database
        habitsAPI.create(habit: habit, completion: { (habit) in
            
            completion(habit)
        })
    }
    
    func editHabit(for editedHabit: Habit, completion: @escaping (Habit) -> ()) {
        // edit habit in the database
        habitsAPI.edit(habit: editedHabit)
        
        completion(editedHabit)
    }
    
    func deleteHabit(for deletedHabit: Habit, completion: @escaping (Habit) -> ()) -> Void {
        // delete habit from database
        habitsAPI.delete(habit: deletedHabit)
        
        completion(deletedHabit)
    }
    
    
    
    func markHabitCompleteFor(completedHabit habit: Habit, withParent goal: Goal) {
        habitsAPI.markComplete(habit, completion: {
            self.goalsManager.updateGoalCompletionStatus(goal: goal, isComplete: true)
        })
        
        // update view for completion status
        habit.completedStreak += 1
        habit.isComplete = true
    }
    
    
    func markHabitIncomplete(missedHabit habit: Habit, withParent goal: Goal) {
        // update database for completion status
        habitsAPI.markIncomplete(habit, completion: {
            self.goalsManager.updateGoalCompletionStatus(goal: goal, isComplete: false)
        })
        
        // update view for completion status
        habit.completedStreak -= 1
        habit.isComplete = false
    }
    
    
    func compare(allHabits: [Habit], completedHabits: [Habit]) -> Void {
        // loop through completed habits
        for habit in allHabits {
            // find the habits in all habits that match the completed ones
            if completedHabits.contains(where: { (completedHabit) -> Bool in
                return completedHabit.name == habit.name
            }) {
                // set that habit to completed in the all habits array
                habit.isComplete = true
            }
        }
    }
    
    
    func resetMissedCompletions(for allHabits: [Habit], forUserUid userUid: String, completion: @escaping () -> Void) -> Void {
        completedHabitsAPI.getYesterdaysCompletionsForUser(havingUid: userUid) { (completedHabits) in
            
            // loop through completed habits from yesterday
            for habit in allHabits {
                
                // find the habits in all habits that are NOT in completed aka they were missed
                if !completedHabits.contains(where: { (completedHabit) -> Bool in
                    return completedHabit.name == habit.name
                }) {
                    
                    // set that habit completed streak to zero in the all habits array
                    if !habit.isComplete {
                        habit.completedStreak = 0
                    }
                }
            }
            completion()
        }
    }
    
    
    func getAllAndCompletedHabits(for goal: Goal, completion: @escaping (_ all: [Habit], _ completed: [Habit]) -> ()) {
        // get ALL goals belonging to that habit
        habitsAPI.getAllForGoal(havingId: goal.id!, completion: { (habits) in
            let allHabits = habits
            
            // get only completed goals belonging to that habit
            self.completedHabitsAPI.getTodaysCompletionsForGoal(havingId: goal.id!, completion: { (habits) in
                let completedHabits = habits
                
                completion(allHabits, completedHabits)
            })
        })
    }
}
