//
//  AssociatedHabitsTableViewDelegate.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class AssociatedHabitsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data: [Habit]
    
    init(data: [Habit]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HabitTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HabitTableViewCell else {
            fatalError("The dequeued cell is not an instance of HabitTableViewCell.")
        }

        let habit = data[indexPath.row]

        cell.habit = habit

        cell.completedStreakCounter.setCounter(to: habit.completedStreak)
        cell.nameLabel.text = habit.name
        cell.completeCheckBox.setOn(habit.isComplete, animated: true)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a row")
    }
    
}
