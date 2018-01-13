//
//  GoalsTableViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    // TODO: replace with API call
    var goals = [
        Goal(id: 1, name: "Be healthier in body and mind", percentToBeComplete: 100, completedStreak: 3),
        Goal(id: 2, name: "Strengthen relationships with friends", percentToBeComplete: 50, completedStreak: 0),
        Goal(id: 3, name: "Start a new career in software engineering and web development", percentToBeComplete: 75, completedStreak: 1),
        Goal(id: 4, name: "Spend more time on hobbies", percentToBeComplete: 50, completedStreak: 0)
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.rowHeight = UITableViewAutomaticDimension

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GoalTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoalTableViewCell else {
            fatalError("The dequeued cell is not an instance of GoalTableViewCell.")
        }

        let goal = goals[indexPath.row]
        
        cell.completedStreakLabel.text = "(\(goal.completedStreak))"
        cell.nameLabel.text = goal.name
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            goals.remove(at: indexPath.row)
            
            let goalToDelete = goals[indexPath.row]
            goalToDelete.deleteEntry()
            
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
        
        switch (segue.identifier ?? "") {
        case "createGoal":
            print("creating a new goal")

        case "showGoalDetail":
            guard let goalDetailViewController = segue.destination as? GoalViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedGoalCell = sender as? GoalTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedGoalCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedGoal = goals[indexPath.row]
            
            goalDetailViewController.goal = selectedGoal
        
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: - Actions
    @IBAction func unwindToGoalList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? GoalViewController, let goal = sourceViewController.goal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // updates an existing goal
                goals[selectedIndexPath.row] = goal
                goal.editEntry()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // add a new goal
                let newIndexPath = IndexPath(row: goals.count, section: 0)
                goals.append(goal)
                goal.createEntry()
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

}
