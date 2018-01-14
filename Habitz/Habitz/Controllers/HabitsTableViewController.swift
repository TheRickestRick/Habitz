//
//  HabitsViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class HabitsTableViewController: UITableViewController {
    
    // MARK: - Properties
    // TODO: replace with API call
    var habits: [Habit] = [
        Habit(id: 1, name: "Drink a green smoothie", isComplete: true, goalId: 1, completedStreak: 2),
        Habit(id: 2, name: "Meditate for 15 minutes", isComplete: false, goalId: 1, completedStreak: 4),
        Habit(id: 3, name: "Call or text an old friend", isComplete: true, goalId: 2, completedStreak: 0),
        Habit(id: 4, name: "Go to a networking event", isComplete: false, goalId: 3, completedStreak: 1),
        Habit(id: 5, name: "Send mom an email", isComplete: true, goalId: 2, completedStreak: 2),
        Habit(id: 6, name: "Message a new contact on LinkedIn or Facebook", isComplete: false, goalId: 3, completedStreak: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if habit.isComplete {
            cell.isCompleteLabel.text = "(X)"
        } else {
            cell.isCompleteLabel.text = "(O)"
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
            
            // Delete the row from the data source
            let habitToDelete = habits[indexPath.row]
            habitToDelete.deleteEntry()
            
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
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHabitCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHabit = habits[indexPath.row]
            habitDetailViewController.habit = selectedHabit
        
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
  
    
    //MARK: - Actions
    @IBAction func unwindToHabitlList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? HabitViewController, let habit = sourceViewController.habit {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // updates an existing habit
                habits[selectedIndexPath.row] = habit
                habit.editEntry()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // add a new habit
                let newIndexPath = IndexPath(row: habits.count, section: 0)
                habits.append(habit)
                habit.createEntry()
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
