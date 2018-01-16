//
//  Habit.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import SwiftyJSON

class Habit {
    var id: Int?
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
    
    // id is omitted for creating new goals, since id will need to be assigned
    // after making a post call to the database
    init(name: String, isComplete: Bool, goalId: Int, completedStreak: Int) {
        self.name = name
        self.isComplete = isComplete
        self.goalId = goalId
        self.completedStreak = completedStreak
    }
    
    // for parsing results back from api
    // they come back as {"1", payload}, {"2", payload} etc, so use the second value in the tuple or .1
    init(json: (String, JSON)) {
        self.id = json.1["id"].intValue
        self.name = json.1["name"].stringValue
        
        
        //TODO: TODO - update to computed value
        self.isComplete = false
        
        
        self.goalId = json.1["goal_id"].intValue
        self.completedStreak = json.1["completed_streak"].intValue
    }
    
    // for parsing results to get an individual goal, which is as type JSON rather than a tuple
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        
        
        //TODO: TODO - update to computed value
        self.isComplete = false
        
        
        self.goalId = json["goal_id"].intValue
        self.completedStreak = json["completed_streak"].intValue
    }
 
    func editEntry() -> Void {
        print("edit this goal in the database")
    }
    
    func deleteEntry() -> Void {
        print("delete this goal from the database")
    }
}
