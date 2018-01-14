//
//  Goal.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire
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
    
    // for parsing results back from api
    // they come back as {"1", payload}, {"2", payload} etc, so use the second value in the tuple or .1
    init(json: (String, JSON)) {
        self.id = json.1["id"].intValue
        self.name = json.1["name"].stringValue
        self.percentToBeComplete = json.1["percent_to_complete"].intValue
        self.completedStreak = json.1["completed_streak"].intValue
    }
    
    // for parsing results to get an individual goal, which is as type JSON rather than a tuple
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.percentToBeComplete = json["percent_to_complete"].intValue
        self.completedStreak = json["completed_streak"].intValue
    }
}

// TODO: startDate, endDate
