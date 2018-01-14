//
//  Habit.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation

class Habit {
    let id: Int
    var name: String
    var isComplete: Bool
    var goalId: Int
    var completedStreak: Int
    
    init(id: Int, name: String, isComplete: Bool, goalId: Int, completedStreak: Int) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
        self.goalId = goalId
        self.completedStreak = completedStreak
    }
    
    func createEntry() -> Void {
        print("add this goal to the database")
    }
    
    func editEntry() -> Void {
        print("edit this goal in the database")
    }
    
    func deleteEntry() -> Void {
        print("delete this goal from the database")
    }
}
