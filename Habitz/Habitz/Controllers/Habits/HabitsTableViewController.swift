//
//  HabitsViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import FirebaseAuth

class HabitsTableViewController: UITableViewController, HabitCompletionUpdateDelegate {
    
    // MARK: - Properties
    var habits: [Habit] = []
    let habitsAPI = HabitsAPI()
    
    var userUid: String?
    
    var completions: [Habit] = []
    let completedHabitsAPI = CompletedHabitsAPI()
    
    var goalsHabitsTabBarController: GoalsHabitsTabBarController = GoalsHabitsTabBarController()
    
    // possible values for time of day, and section headers
    enum TableSection: Int {
        case morning = 0, afternoon, evening, total
    }
    
    // track habits sorted by time of day
    var data = [TableSection: [Habit]]()
    
    let sectionHeaderHeight: CGFloat = 25
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // store a reference to the current tab bar controller
        goalsHabitsTabBarController = tabBarController as! GoalsHabitsTabBarController
        
        // get current user uid
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            
            // get all habits to populate table
            habitsAPI.getAllForUser(havingUid: userUid!, completion: { (allHabits) in
                self.habits = allHabits
                
                // get completed habits from TODAY to compare against ALL habits
                self.completedHabitsAPI.getTodaysCompletionsForUser(havingUid: self.userUid!, completion: { (completedHabits) in
                    self.completions = completedHabits
                    
                    // update all habits to have correct completion status based on
                    // comparing against the completed habits array
                    self.compare(allHabits: self.habits, completedHabits: self.completions)
                    
                    
                    // get completed habits from YESTERDAY, to compare to all habits, and
                    // reset streak count to zero if a habit was not completed yesterday
                    self.resetMissedCompletions(for: allHabits, completion: {
                        self.sortData()
                        self.tableView.reloadData()
                    })

                })
                
            })
            
        }
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // total is the last case in the enum so it provides the total number of sections
        return TableSection.total.rawValue
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using Swift's optional lookup we first check if there is a valid section of table.
        // Then we check that for the section there is data that goes with.
        if let tableSection = TableSection(rawValue: section), let habitsData = data[tableSection] {
            return habitsData.count
        }
        return 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // First check if there is a valid section of table.
        // Then we check that for the section there is more than 1 row.
        if let tableSection = TableSection(rawValue: section), let habitsData = data[tableSection], habitsData.count > 0 {
            return sectionHeaderHeight
        }
        return 0
    }
    
    
    // set up header views and properties
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HabitTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HabitTableViewCell else {
            fatalError("The dequeued cell is not an instance of HabitTableViewCell.")
        }
        
        // first check if there is a valid section of table, then we check that for the section there is a row
        if let tableSection = TableSection(rawValue: indexPath.section), let habit = data[tableSection]?[indexPath.row] {
            
            cell.completedStreakLabel.text = "(\(habit.completedStreak))"
            cell.nameLabel.text = habit.name
            cell.completeCheckBox.setOn(habit.isComplete, animated: true)
            
            cell.habit = habit
            cell.habitCompletionUpdateDelegate = self
            
            cell.goals = goalsHabitsTabBarController.goals
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // get section from the index path, and use that to look up
            // the selected habit via the data dictionary
            let deleteSection = TableSection(rawValue: indexPath.section)
            let habitToDelete = data[deleteSection!]![indexPath.row]
            
            deleteHabit(for: habitToDelete)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "createHabit":
            print("create a new habit")
        
        case "showHabitDetail":
            guard let habitDetailViewController = segue.destination as? HabitViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHabitCell = sender as? HabitTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHabitCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            // get the selected habit using the index and section
            // to lookup in the data dictionary
            let selectedSection = TableSection(rawValue: indexPath.section)!
            let selectedHabitId = data[selectedSection]![indexPath.row].id
            
            let selectedHabit = habits.first(where: { (habit) -> Bool in
                return habit.id == selectedHabitId
            })
            
            
            habitDetailViewController.habit = selectedHabit
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
  
    
    //MARK: - Actions
    @IBAction func unwindToHabitlList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            
            if tableView.indexPathForSelectedRow != nil {
                // edit an existing habit in the database and update the table view
                editHabit(for: habit)
            } else {
                // add a new habit to the database and update the table view
                createHabit(for: habit)
            }
        }
    }
    
    
    //MARK: - CompletionUpdateDelegate
    func toggleCompletion(for toggledHabit: Habit) {
        toggledHabit.isComplete = !toggledHabit.isComplete
    }
    
    
    //MARK: - Private Methods
    func compare(allHabits: [Habit], completedHabits: [Habit]) -> Void {
        
        // loop through completed habits
        for habit in allHabits {
            // find the habits in all habits that match the completed ones
            if completedHabits.contains(where: { (completedHabit) -> Bool in
                return completedHabit.name == habit.name
            }) {
                // set that habit to completed in the all habits array
                habit.isComplete = true
            }
        }
    }
    
    func resetMissedCompletions(for allHabits: [Habit], completion: @escaping () -> Void) -> Void {
        completedHabitsAPI.getYesterdaysCompletionsForUser(havingUid: userUid!) { (completedHabits) in
            
            // loop through completed habits from yesterday
            for habit in allHabits {
                
                // find the habits in all habits that are NOT in completed aka they were missed
                if !completedHabits.contains(where: { (completedHabit) -> Bool in
                    return completedHabit.name == habit.name
                }) {
                    
                    // set that habit completed streak to zero in the all habits array
                    if !habit.isComplete {
                        habit.completedStreak = 0
                    }
                }
            }
            completion()
        }
    }
    
    
    // update data array to group all habits by their time of day
    func sortData() {
        data[.morning] = habits.filter({ $0.timeOfDay == "morning" })
        data[.afternoon] = habits.filter({ $0.timeOfDay == "afternoon"})
        data[.evening] = habits.filter({ $0.timeOfDay == "evening" })
    }
    
    
    
    func createHabit(for habit: Habit) -> Void {
        // add new habit to the database
        habitsAPI.create(habit: habit, completion: { (habit) in
            
            // update stored array
            self.habits.append(habit)
            
            // refresh and reload the data in the table view
            self.sortData()
            self.tableView.reloadData()
        })
    }
    
    func editHabit(for editedHabit: Habit) -> Void {
        // edit habit in the database
        habitsAPI.edit(habit: editedHabit)
        
        // updates an existing habit in the array
        let indexToEdit = habits.index { (habit) -> Bool in
            return habit.id == editedHabit.id
        }
        habits[indexToEdit!] = editedHabit
        
        // refresh and reload the data in the table view
        self.sortData()
        self.tableView.reloadData()
    }
    
    func deleteHabit(for deletedHabit: Habit) -> Void {
        // delete habit from database
         habitsAPI.delete(habit: deletedHabit)
        
        // delete the habit from the array
        let indexToDelete = habits.index { (habit) -> Bool in
            return habit.id == deletedHabit.id
        }
        habits.remove(at: indexToDelete!)
        
        // refresh and reload the data in the table view
        self.sortData()
        self.tableView.reloadData()
    }
}
