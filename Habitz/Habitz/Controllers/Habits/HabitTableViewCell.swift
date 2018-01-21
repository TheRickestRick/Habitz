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
    
    let habitsAPI = HabitsAPI()
    let completedHabitsAPI = CompletedHabitsAPI()
    
    var habitCompletionUpdateDelegate: HabitCompletionUpdateDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        completeCheckBox.onAnimationType = BEMAnimationType.bounce
        completeCheckBox.offAnimationType = BEMAnimationType.fade
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
            
            // update database for completed habit
            habitCompletionUpdateDelegate.markHabitCompleteFor(completedHabit: habit, withParent: parentGoal)
            
        } else {
            
            // update database and view for missed habit
            habitCompletionUpdateDelegate.markHabitIncomplete(missedHabit: habit, withParent: parentGoal)
        }
    }
    
    
    //MARK: - Private Methods
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
