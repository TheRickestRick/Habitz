//
//  GoalViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var percentToBeCompleteLabel: UITextField!
    @IBOutlet weak var completedStreakLabel: UITextField!
    
    // passed in by GoalTableViewController or constructed as part of adding a new goal
    var goal: Goal?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("The save button was not pressed, cancelling")
            return
        }
        
        let id = 4
        guard let name = nameLabel.text else {return}
        guard let percentToBeComplete = Int(percentToBeCompleteLabel.text!) else {return}
        let completedStreak = 0
        
        goal = Goal(id: id, name: name, percentToBeComplete: percentToBeComplete, completedStreak: completedStreak)
    }

}
