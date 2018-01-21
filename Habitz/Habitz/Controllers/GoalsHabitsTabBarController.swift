//
//  GoalsHabitsTabController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/18/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

class GoalsHabitsTabBarController: UITabBarController {
    var goals: [Goal] = []
    var habits: [Habit] = []
    
    override func viewDidLoad() {
        self.tabBar.barTintColor = ColorScheme.darkBackground.value
        self.tabBar.tintColor = ColorScheme.lightText.value
    }
}
