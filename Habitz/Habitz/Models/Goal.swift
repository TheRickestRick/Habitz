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
    
    init(id: Int, name: String, percentToBeComplete: Int, completedStreak: Int) {
        self.id = id
        self.name = name
        self.percentToBeComplete = percentToBeComplete
        self.completedStreak = completedStreak
    }
    
    // id is omitted for creating new goals, since id will need to be assigned
    // after making a post call to the database
    init(name: String, percentToBeComplete: Int, completedStreak: Int) {
        self.name = name
        self.percentToBeComplete = percentToBeComplete
        self.completedStreak = completedStreak
    }
    
    
    // for parsing results coming from the api
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.percentToBeComplete = json["percent_to_complete"].intValue
        self.completedStreak = json["completed_streak"].intValue
    }
    
    // check if the ratio of completed habits out of all associated habits
    // is greater than the target completion percentage
    func checkIsComplete(allHabits: [Habit], completedHabits: [Habit]) -> Bool {
        return (completedHabits.count / allHabits.count) >= (self.percentToBeComplete / 100)
    }
}

// TODO: startDate, endDate
