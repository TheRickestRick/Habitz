//
//  GoalViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var percentToBeCompleteTextField: UITextField!
    @IBOutlet weak var completedStreakTextField: UITextField!
    
    // passed in by GoalTableViewController or constructed as part of adding a new goal
    var goal: Goal?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle the text field's input through delegate callbacks
        nameTextField.delegate = self
        
        // sets up views if editing an existing goal
        if let goal = goal {
            navigationItem.title = goal.name
            nameTextField.text = goal.name
            percentToBeCompleteTextField.text = String(goal.percentToBeComplete)
            completedStreakTextField.text = String(goal.completedStreak)
        }
        
        // enable save button only if the text field has a valid goal name
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // depending on style of presentation (modal or push presentation)
        // this view controller needs to be dismissed in two different ways
        let isPresentingInAddGoalMode = presentingViewController is UINavigationController
        
        if isPresentingInAddGoalMode {
            self.dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The GoalViewController is not inside a navigation controller.")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("The save button was not pressed, cancelling")
            return
        }
        
        let id = 4
        guard let name = nameTextField.text else {return}
        guard let percentToBeComplete = Int(percentToBeCompleteTextField.text!) else {return}
        let completedStreak = 0
        
        goal = Goal(id: id, name: name, percentToBeComplete: percentToBeComplete, completedStreak: completedStreak)
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) -> Void {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) -> Void {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    // MARK: - Private Methods
    func updateSaveButtonState() -> Void {
        // disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
