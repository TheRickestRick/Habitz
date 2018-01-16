//
//  HabitsViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import FirebaseAuth

class HabitsTableViewController: UITableViewController, CompletionUpdateDelegate {
    
    // MARK: - Properties
    var habits: [Habit] = []
    let habitsAPI = HabitsAPI()
    
    var userUid: String?
    
    var completions: [Habit] = []
    let completionsAPI = CompletionsAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get current user uid
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            
            // get all habits to populate table
            habitsAPI.getAllForUser(havingUid: userUid!, completion: { (allHabits) in
                self.habits = allHabits
                
                // get completed habits from TODAY to compare against ALL habits
                self.completionsAPI.getTodaysCompletionsForUser(havingUid: self.userUid!, completion: { (completedHabits) in
                    self.completions = completedHabits
                    
                    // update all habits to have correct completion status based on
                    // comparing against the completed habits array
                    self.compare(allHabits: self.habits, completedHabits: self.completions)
                    
                    
                    // get completed habits from YESTERDAY, to compare to all habits, and
                    // reset streak count to zero if a habit was not completed yesterday
                    self.resetMissedCompletions(for: allHabits, completion: {
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HabitTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HabitTableViewCell else {
            fatalError("The dequeued cell is not an instance of HabitTableViewCell.")
        }

        let habit = habits[indexPath.row]

        cell.completedStreakLabel.text = "(\(habit.completedStreak))"
        cell.nameLabel.text = habit.name
        cell.habit = habit
        cell.completionUpdateDelegate = self

        if habit.isComplete {
            cell.completeCheckBox.setOn(true, animated: true)
            
        } else {
            cell.completeCheckBox.setOn(false, animated: true)
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
            
            let habitToDelete = habits[indexPath.row]
            // delete habit from database
            habitsAPI.delete(habit: habitToDelete)
            
            // Delete the row from the data source
            habits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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
            
            let selectedHabit = habits[indexPath.row]
            habitDetailViewController.habit = selectedHabit
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
  
    
    //MARK: - Actions
    @IBAction func unwindToHabitlList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // edit habit in the database
                habitsAPI.edit(habit: habit)
                
                // updates an existing habit in the array and view
                habits[selectedIndexPath.row] = habit
                tableView.reloadRows(at: [selectedIndexPath], with: .none)

                
            } else {
                // add a new habit to the database
                habitsAPI.create(habit: habit, completion: { (habit) in
                    // add a new habit to the habits array and update the view
                    let newIndexPath = IndexPath(row: self.habits.count, section: 0)
                    self.habits.append(habit)
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                })
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
        completionsAPI.getYesterdaysCompletionsForUser(havingUid: userUid!) { (completedHabits) in
            
            // loop through completed habits from yesterday
            for habit in allHabits {
                
                // find the habits in all habits that are NOT in completed aka they were missed
                if !completedHabits.contains(where: { (completedHabit) -> Bool in
                    return completedHabit.name == habit.name
                }) {
                    // set that habit completed streak to zero in the all habits array
                    if habit.isComplete {
                        habit.completedStreak = 1
                    } else {
                        habit.completedStreak = 0
                    }
                }
            }
            completion()
        }
    }
    
}
