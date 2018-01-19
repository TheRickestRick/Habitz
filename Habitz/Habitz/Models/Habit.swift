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
    var timeOfDay: String
    
    init(id: Int, name: String, isComplete: Bool, goalId: Int, completedStreak: Int, timeOfDay: String) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
        self.goalId = goalId
        self.completedStreak = completedStreak
        self.timeOfDay = timeOfDay
    }
    
    
    // id is omitted for creating new goals, since id will need to be assigned
    // after making a post call to the database
    init(name: String, isComplete: Bool, goalId: Int, completedStreak: Int, timeOfDay: String) {
        self.name = name
        self.isComplete = isComplete
        self.goalId = goalId
        self.completedStreak = completedStreak
        self.timeOfDay = timeOfDay
    }
    
    
    // for parsing results back from the api
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        
        
        //TODO: TODO - update to computed value
        self.isComplete = false
        
        
        self.goalId = json["goal_id"].intValue
        self.completedStreak = json["completed_streak"].intValue
        self.timeOfDay = json["time_of_day"].stringValue
    }
}
