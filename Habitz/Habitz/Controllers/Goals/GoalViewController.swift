//
//  GoalViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import FirebaseAuth

class GoalViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var percentToBeCompleteTextField: UITextField!
    @IBOutlet weak var associatedHabitsTableView: UITableView!
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var associatedGoalsLabel: UILabel!
    
    
    // passed in by GoalTableViewController or constructed as part of adding a new goal
    var goal: Goal?
    var userUid: String?
    
    
    // data for picker to restrict values
    let pickerData = [0, 25, 50, 75, 100]
    let percentToCompletePicker: UIPickerView! = UIPickerView()
    
    
    // providing data for the table view
    var habits: [Habit] = []
    var completions: [Habit] = []
    let habitsManager = HabitsManager()
    var tableViewDelegate: AssociatedHabitsTableViewDelegate?
    var goalsHabitsTabBarController: GoalsHabitsTabBarController = GoalsHabitsTabBarController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get current user uid
        if let user = Auth.auth().currentUser {
            userUid = user.uid
        }
        
        
        // get all associated habits for the selected goal if in edit mode
        if goal != nil {
            associatedHabitsTableView.isHidden = false
            
            // store a reference to the current tab bar controller
            goalsHabitsTabBarController = tabBarController as! GoalsHabitsTabBarController
            
            
            habitsManager.getAllAndCompletedHabits(for: goal!, completion: { (allHabits, completedHabits) in
                self.habits = allHabits
                self.completions = completedHabits
                
                self.habitsManager.compare(allHabits: self.habits, completedHabits: self.completions)
                
                self.habitsManager.resetMissedCompletions(for: self.habits, forUserUid: self.userUid!, completion: {
                    // creating the delegate object and passing the data
                    self.tableViewDelegate = AssociatedHabitsTableViewDelegate(goal: self.goal!,
                                                                               tabBarController: self.goalsHabitsTabBarController,
                                                                               tableView: self.associatedHabitsTableView,
                                                                               allHabits: allHabits,
                                                                               completedHabits: completedHabits)
                    
                    
                    // setting the delegate object to tableView
                    self.associatedHabitsTableView.delegate = self.tableViewDelegate
                    self.associatedHabitsTableView.dataSource = self.tableViewDelegate
                    
                    self.associatedHabitsTableView.reloadData()
                })
            })
        } else {
            associatedHabitsTableView.isHidden = true
        }
        
        // handle the text field's input through delegate callbacks
        nameTextField.delegate = self
        
        // enable save button only if the text field has a valid goal name
        updateSaveButtonState()
        
        
        // handle selecting percentToComplete through delegate callbacks
        percentToCompletePicker.dataSource = self
        percentToCompletePicker.delegate = self
        percentToBeCompleteTextField.inputView = percentToCompletePicker
        
        
        // sets up views if editing an existing goal
        if let goal = goal {
            navigationItem.title = "Goal Details"
            associatedGoalsLabel.isHidden = false
            goalNameLabel.text = goal.name
            nameTextField.text = goal.name
            percentToBeCompleteTextField.text = String(goal.percentToBeComplete)
        } else {
            // sets up views if creating a new goal
            associatedGoalsLabel.isHidden = true
            percentToBeCompleteTextField.text = String(pickerData[0])
        }
        
        
        //MARK: Coloring and Styling
        for view in view.subviews {
            if let subview = view as? UILabel {
                subview.textColor = ColorScheme.darkText.value
                subview.font = FontScheme.heavyOblique.font
            } else if let subview = view as? UITextField {
                subview.textColor = ColorScheme.darkText.value
                subview.font = FontScheme.standard.font
            }
        }
        navigationController?.navigationBar.tintColor = ColorScheme.lightText.value
        navigationController?.navigationBar.barTintColor = ColorScheme.darkText.value
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: FontScheme.heavy.font], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: FontScheme.heavy.font], for: .normal)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ColorScheme.lightText.value,
                                                                   NSAttributedStringKey.font: FontScheme.heavy.font]
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
        
        // set up values for new goal
        guard let name = nameTextField.text else {return}
        guard let percentToBeComplete = Int(percentToBeCompleteTextField.text!) else {return}
        let completedStreak = 0
        let isComplete = false
        
        
        // if an id is present, this means it is being edited so create a new goal instance with the
        // same id, completed streak, and completion status - only allows updates to name and percentToBeComplete
        // otherwise this is creating a new goal, so leave id blank and let vc populate from API post call
        if let id = goal?.id {
            goal = Goal(id: id, name: name, percentToBeComplete: percentToBeComplete, completedStreak: completedStreak, isComplete: isComplete)
        } else {
            goal = Goal(name: name, percentToBeComplete: percentToBeComplete, completedStreak: completedStreak, isComplete: isComplete)
        }
        
        
    }
    
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // depending on style of presentation (modal or push presentation)
        // this view controller needs to be dismissed in two different ways
        let isPresentingInAddGoalMode = presentingViewController is UITabBarController
        
        if isPresentingInAddGoalMode {
            self.dismiss(animated: true, completion: nil)
            
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The GoalViewController is not inside a navigation controller.")
        }
        
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) -> Void {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) -> Void {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // handle what happens when hitting return on a text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
    
    
    //MARK: - UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        percentToBeCompleteTextField.text = String(pickerData[row])
        self.view.endEditing(true)
    }
    
    
    // MARK: - Private Methods
    func updateSaveButtonState() -> Void {
        // disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
