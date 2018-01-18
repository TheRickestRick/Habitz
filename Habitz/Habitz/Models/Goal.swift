//
//  Goal.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import SwiftyJSON

class Goal {
    var id: Int?
    var name: String
    var percentToBeComplete: Int
    var completedStreak: Int
    var isComplete: Bool
    
    init(id: Int, name: String, percentToBeComplete: Int, completedStreak: Int, isComplete: Bool) {
        self.id = id
        self.name = name
        self.percentToBeComplete = percentToBeComplete
        self.completedStreak = completedStreak
        self.isComplete = isComplete
    }
    
    // id is omitted for creating new goals, since id will need to be assigned
    // after making a post call to the database
    init(name: String, percentToBeComplete: Int, completedStreak: Int, isComplete: Bool) {
        self.name = name
        self.percentToBeComplete = percentToBeComplete
        self.completedStreak = completedStreak
        self.isComplete = isComplete
    }
    
    
    // for parsing results coming from the api
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.percentToBeComplete = json["percent_to_complete"].intValue
        self.completedStreak = json["completed_streak"].intValue
        
        // set as false by default
        self.isComplete = false
    }
    
    // check if the ratio of completed habits out of all associated habits
    // is greater than the target completion percentage
    func isCompleteHaving(all: [Habit], completed: [Habit]) -> Bool {
        if all.count == 0 {return false}
        
        return (Double(completed.count) / Double(all.count)) >= (Double(self.percentToBeComplete) / 100.0)
    }
}

// TODO: startDate, endDate
