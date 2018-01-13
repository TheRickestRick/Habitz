//
//  Goal.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation

class Goal {
    let id: Int
    var name: String
    var percentToBeComplete: Int
    var completedStreak: Int
    
    init(id: Int, name: String, percentToBeComplete: Int, completedStreak: Int) {
        self.id = id
        self.name = name
        self.percentToBeComplete = percentToBeComplete
        self.completedStreak = completedStreak
    }
}

// TODO: startDate, endDate
