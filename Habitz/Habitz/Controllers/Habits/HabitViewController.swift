//
//  HabitViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/13/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var isCompletedTextField: UITextField!
    @IBOutlet weak var completedStreakTextField: UITextField!
    @IBOutlet weak var associatedGoalTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // passed in by HabitTableViewController or constructed as part of adding a new habit
    var habit: Habit?
    
    // data for picker to restrict values
    let pickerData = [
        Goal(id: 1, name: "Be healthier in body and mind", percentToBeComplete: 100, completedStreak: 3),
        Goal(id: 2, name: "Strengthen relationships with friends", percentToBeComplete: 50, completedStreak: 0),
        Goal(id: 3, name: "Start a new career in software engineering", percentToBeComplete: 75, completedStreak: 1),
        Goal(id: 4, name: "Spend more time on hobbies", percentToBeComplete: 50, completedStreak: 0)
    ]
    let goalIdPicker: UIPickerView! = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // handle the text field's input through delegate callbacks
        nameTextField.delegate = self
        
        // handle selecting goalId through delegate callbacks
        goalIdPicker.dataSource = self
        goalIdPicker.delegate = self
        associatedGoalTextField.inputView = goalIdPicker
        
        // setup initial view
        associatedGoalTextField.text = String(pickerData[0].name)
        
        // set up views if editing an existing habit
        if let habit = habit {
            navigationItem.title = habit.name
            nameTextField.text = habit.name
            isCompletedTextField.text = String(habit.isComplete)
            completedStreakTextField.text = String(habit.completedStreak)
            
            if let i = pickerData.index(where: { $0.id == habit.goalId }) {
                associatedGoalTextField.text = pickerData[i].name
            }
        }
        
        // enable save button only if the text field has a valid habit name
        updateSaveButtonState()
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
        let pickerIndex = goalIdPicker.selectedRow(inComponent: 0)
        let goalId = pickerData[pickerIndex].id
        let completedStreak = 0
        
        // if an id is present, this means it is being edited so create a new habit instance with that id
        // otherwise this is creating a new habit, so leave id blank and let vc populate from API post call
        if let id = habit?.id {
            habit = Habit(id: id, name: name, isComplete: isComplete, goalId: goalId!, completedStreak: completedStreak)
        } else {
            habit = Habit(name: name, isComplete: isComplete, goalId: goalId!, completedStreak: completedStreak)
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
    
    
    // MARK: - UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row].name)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        associatedGoalTextField.text = String(pickerData[row].name)
        self.view.endEditing(true)
    }
    
    
    // MARK: - Private Methods
    func updateSaveButtonState() -> Void {
        // disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
