//
//  HabitViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import FirebaseAuth

class HabitViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var isCompletedTextField: UITextField!
    @IBOutlet weak var completedStreakTextField: UITextField!
    @IBOutlet weak var associatedGoalTextField: UITextField!
    @IBOutlet weak var timeOfDayTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // passed in by HabitTableViewController or constructed as part of adding a new habit
    var habit: Habit?
    var userUid: String?
    
    // data for picker to restrict values, populated by api call
    let goalIdPicker: UIPickerView! = UIPickerView()
    var goalIdPickerDelegate: GoalIdPickerDelegate?
    
    let timeOfDayPicker: UIPickerView! = UIPickerView()
    var timeOfDayPickerDelegate: TimeOfDayPickerDelegate?

    //
    let goalsAPI = GoalsAPI()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // handle the text field's input through delegate callbacks
        nameTextField.delegate = self
        
        
        // handle selecting goalId through delegate callbacks
        goalIdPickerDelegate = GoalIdPickerDelegate(forTextField: associatedGoalTextField,
                                                        withData: [],
                                                        forView: self.view)
        goalIdPicker.dataSource = goalIdPickerDelegate
        goalIdPicker.delegate = goalIdPickerDelegate
        associatedGoalTextField.inputView = goalIdPicker
        
        
        timeOfDayPickerDelegate = TimeOfDayPickerDelegate(forTextField: timeOfDayTextField,
                                                          forView: self.view)
        timeOfDayPicker.dataSource = timeOfDayPickerDelegate
        timeOfDayPicker.delegate = timeOfDayPickerDelegate
        timeOfDayTextField.inputView = timeOfDayPicker
        
        
        
        // get current user uid
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            
            // get goals from db to populate picker list
            goalsAPI.getAllForUser(havingUserUid: userUid!, completion:  { (goals) in
                self.goalIdPickerDelegate!.pickerData = goals
                
                
                // setup initial view
                self.associatedGoalTextField.text = self.goalIdPickerDelegate!.pickerData[0].name
                
                // set up views if editing an existing habit
                if let habit = self.habit {
                    self.navigationItem.title = habit.name
                    self.nameTextField.text = habit.name
                    self.isCompletedTextField.text = String(habit.isComplete)
                    self.completedStreakTextField.text = String(habit.completedStreak)
                    
                    if let i = self.goalIdPickerDelegate?.pickerData.index(where: { $0.id == habit.goalId }) {
                        self.goalIdPickerDelegate!.textField.text = self.goalIdPickerDelegate!.pickerData[i].name
                    }
                }
                // enable save button only if the text field has a valid habit name
                self.updateSaveButtonState()
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("The save button was not pressed, cancelling")
            return
        }
        
        // setup data for creating new habit
        guard let name = nameTextField.text else { return }
        let isComplete = false
        
        
        let goalIdPickerIndex = goalIdPicker.selectedRow(inComponent: 0)
        let goalId = goalIdPickerDelegate!.pickerData[goalIdPickerIndex].id
        
        
        let timeOfDayPickerIndex = timeOfDayPicker.selectedRow(inComponent: 0)
        let timeOfDay = timeOfDayPickerDelegate!.pickerData[timeOfDayPickerIndex]
        
        
        var completedStreak: Int
        if let completedStreakText = completedStreakTextField.text, let completedStreakInt = Int(completedStreakText) {
            completedStreak = completedStreakInt
        } else {
            completedStreak = 0
        }
        
        
        // if an id is present, this means it is being edited so create a new habit instance with that id
        // otherwise this is creating a new habit, so leave id blank and let vc populate from API post call
        if let editHabit = habit {
            habit = Habit(id: editHabit.id!, name: name, isComplete: editHabit.isComplete, goalId: goalId!, completedStreak: completedStreak, timeOfDay: timeOfDay)
        } else {
            habit = Habit(name: name, isComplete: isComplete, goalId: goalId!, completedStreak: completedStreak, timeOfDay: timeOfDay)
        }
    }

    
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // depending on style of presentation (modal or push presentation)
        // this view controller needs to be dismissed in two different ways
        let isPresentingInAddHabitMode = presentingViewController is UITabBarController
        
        if isPresentingInAddHabitMode {
            self.dismiss(animated: true, completion: nil)
            
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The HabitViewController is not inside a navigation controller.")
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
    
    
    // MARK: - Private Methods
    func updateSaveButtonState() -> Void {
        // disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
