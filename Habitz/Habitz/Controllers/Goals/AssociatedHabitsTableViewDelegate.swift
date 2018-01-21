//
//  AssociatedHabitsTableViewDelegate.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class AssociatedHabitsTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource, EditableTableDelegate {
    
    // MARK: - Properties
    let goal: Goal
    var habits: [Habit]
    var completions: [Habit]
    
    let goalsHabitsTabBarController: GoalsHabitsTabBarController
    
    let tableView: UITableView
    
    let habitsManager = HabitsManager()
    
    // possible values for time of day, and section headers
    enum TableSection: Int {
        case morning = 0, afternoon, evening, total
    }
    
    // track habits sorted by time of day
    var data = [TableSection: [Habit]]()
    
    let sectionHeaderHeight: CGFloat = 25
    
    
    
    init(goal: Goal, tabBarController: GoalsHabitsTabBarController, tableView: UITableView, allHabits: [Habit], completedHabits: [Habit]) {
        self.goal = goal
        self.goalsHabitsTabBarController = tabBarController
        self.tableView = tableView
        self.habits = allHabits
        self.completions = completedHabits
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // total is the last case in the enum so it provides the total number of sections
        self.sortData()
        
        return TableSection.total.rawValue
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using Swift's optional lookup we first check if there is a valid section of table.
        // Then we check that for the section there is data that goes with.
        
        
        if let tableSection = TableSection(rawValue: section), let habitsData = data[tableSection] {
            return habitsData.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // First check if there is a valid section of table.
        // Then we check that for the section there is more than 1 row.
        
        if let tableSection = TableSection(rawValue: section), let habitsData = data[tableSection], habitsData.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }
    
    
    // set up header views and properties
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        
        // view.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        view.backgroundColor = ColorScheme.lightBackground.value
        
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        
        // label.textColor = UIColor.black
        label.textColor = ColorScheme.darkText.value
        
        
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .morning:
                label.text = "Morning"
            case .afternoon:
                label.text = "Afternoon"
            case .evening:
                label.text = "Evening"
            default:
                label.text = ""
            }
        }
        view.addSubview(label)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HabitTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HabitTableViewCell else {
            fatalError("The dequeued cell is not an instance of HabitTableViewCell.")
        }
        
        // first check if there is a valid section of table, then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let habit = data[tableSection]?[indexPath.row] {
            
            cell.habit = habit
            
            cell.completedStreakCounter.setCounter(to: habit.completedStreak)
            cell.nameLabel.text = habit.name
            cell.completeCheckBox.setOn(habit.isComplete, animated: true)
            
            cell.habitsManager = habitsManager
            cell.editableTableDelegate = self
            
            
            cell.goals = goalsHabitsTabBarController.goals
        }
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    //MARK: - Private Methods
    // update data array to group all habits by their time of day
    func sortData() {
        data[.morning] = habits.filter({ $0.timeOfDay == "morning" })
        data[.afternoon] = habits.filter({ $0.timeOfDay == "afternoon"})
        data[.evening] = habits.filter({ $0.timeOfDay == "evening" })
    }
    
    
    //MARK: - EditableTableDelegate
    func editHabit(for editedHabit: Habit) -> Void {
        // edit habit in the database
        habitsManager.editHabit(for: editedHabit) { (habit) in }
        
        // updates an existing habit in the array
        let indexToEdit = habits.index { (habit) -> Bool in
            return habit.id == editedHabit.id
        }
        habits[indexToEdit!] = editedHabit
        
        
        //TODO: TODO - update to reload only data at the selected indexPath to prevent all checkboxes from activating
        // refresh and reload the data in the table view
        self.sortData()
        self.tableView.reloadData()
    }
    
}
