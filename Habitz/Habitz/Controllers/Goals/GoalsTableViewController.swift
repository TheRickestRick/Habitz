//
//  GoalsTableViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import FirebaseAuth

class GoalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    var goals: [Goal] = []
    var completedGoals: [Goal] = []
    var userUid: String?
    
    let goalsAPI = GoalsAPI()
    let completedGoalsAPI = CompletedGoalsAPI()
    
    var goalsHabitsTabBarController: GoalsHabitsTabBarController = GoalsHabitsTabBarController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // store the reference to the current tab bar controller
        goalsHabitsTabBarController = self.tabBarController as! GoalsHabitsTabBarController
        
        // get current user uid
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            
            // get all goals to populate table
            goalsAPI.getAllForUser(havingUserUid: userUid!, completion: { (allGoals) in
                self.goals = allGoals
                self.tableView.reloadData()
                
                
                
                // get completed habits from TODAY to compare against ALL habits
                self.completedGoalsAPI.getTodaysCompletionsForUser(havingUid: self.userUid!, completion: { (completedGoals) in
                    self.completedGoals = completedGoals
                    
                    // update all habits to have correct completion status based on
                    // comparing against the completed habits array
                    self.compare(allGoals: self.goals, completedGoals: self.completedGoals)
                    
                    
                    // get completed habits from YESTERDAY, to compare to all habits, and
                    // reset streak count to zero if a habit was not completed yesterday
                    self.resetMissedCompletions(for: allGoals, completion: {
                        self.tableView.reloadData()
                    })
                    
                })
                
                
                
                
                
                // set the goals property on the parent tab bar controller
                self.goalsHabitsTabBarController.goals = allGoals
                
            })
        }
        
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // auto adjust height for goals that have multiple lines of text
        tableView.rowHeight = UITableViewAutomaticDimension

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // to be run each time this tab is clicked
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        
        
        //TODO: TODO - set text based on complete or not
        if goal.isComplete {
            cell.isCompletedLabel.text = "(X)"
        } else {
            cell.isCompletedLabel.text = "(O)"
        }
  
        
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let goalToDelete = goals[indexPath.row]
            
            // delete goal from database
            goalsAPI.delete(goal: goalToDelete)
            
            // Delete the row from the data source
            goals.remove(at: indexPath.row)
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
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedGoalCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            // pass tapped goal to detail vc
            let selectedGoal = goals[indexPath.row]
            goalDetailViewController.goal = selectedGoal
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: - Actions
    @IBAction func unwindToGoalList(sender: UIStoryboardSegue) -> Void {
        
        if let sourceViewController = sender.source as? GoalViewController, let goal = sourceViewController.goal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // edit goal in the database
                goalsAPI.edit(goal: goal)
                
                // updates an existing goal in the array and view
                goals[selectedIndexPath.row] = goal
                self.goalsHabitsTabBarController.goals = self.goals
                
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                
                // add a new goal to the database
                goalsAPI.createForUser(havingUserUid:userUid!, goal: goal, completion: { (goal) in
                    // add a new goal to the goals array and update the view
                    let newIndexPath = IndexPath(row: self.goals.count, section: 0)
                    
                    self.goals.append(goal)
                    self.goalsHabitsTabBarController.goals = self.goals
                    
                    
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                })
            }
        }
    }
    
    
    //MARK: - Private Methods
    //TODO: TODO - these two methods are almost identical, in goals and habits table view
    // either combine or come up with a new API endpoint that returns isComplete
    func compare(allGoals: [Goal], completedGoals: [Goal]) -> Void {
        
        // loop through completed habits
        for goal in allGoals {
            // find the habits in all habits that match the completed ones
            if completedGoals.contains(where: { (completedGoal) -> Bool in
                return completedGoal.id == goal.id
            }) {
                // set that habit to completed in the all habits array
                goal.isComplete = true
            }
        }
    }
    
    func resetMissedCompletions(for allGoals: [Goal], completion: @escaping () -> Void) -> Void {
        completedGoalsAPI.getYesterdaysCompletionsForUser(havingUid: userUid!) { (completedGoals) in
            
            // loop through completed habits from yesterday
            for goal in allGoals {
                
                // find the habits in all habits that are NOT in completed aka they were missed
                if !completedGoals.contains(where: { (completedGoal) -> Bool in
                    return completedGoal.id == goal.id
                }) {
                    // set that habit completed streak to zero in the all habits array
                    if goal.isComplete {
                        goal.completedStreak = 1
                    } else {
                        goal.completedStreak = 0
                    }
                }
            }
            completion()
        }
    }

}
