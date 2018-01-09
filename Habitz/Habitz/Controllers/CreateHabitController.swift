//
//  CreateHabitController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/9/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class CreateHabitController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var newHabitName: UITextField!
    @IBOutlet weak var newHabitAssociatedGoal: UITextField!
    
    // constants
    //TODO: replace with API call for all of a user's goals
    let pickerData = [
        Goal(id: 1, name: "Be healthier in body and mind", percentToBeComplete: 100),
        Goal(id: 2, name: "Strengthen relationships with friends", percentToBeComplete: 50),
        Goal(id: 3, name: "Start a new career is software engineering", percentToBeComplete: 75),
        Goal(id: 4, name: "Spend more time on hobbies", percentToBeComplete: 50)
    ]
    let associatedGoalPicker: UIPickerView! = UIPickerView()
    
    var delegate: CreateHabitDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        associatedGoalPicker.dataSource = self
        associatedGoalPicker.delegate = self
        
        newHabitAssociatedGoal.inputView = associatedGoalPicker
        newHabitAssociatedGoal.text = String(pickerData[0].name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Button Methods
    @IBAction func createNewHabit(_ sender: UIButton) {
        
        guard let newHabitName = newHabitName.text else { return }
        let pickerIndex = associatedGoalPicker.selectedRow(inComponent: 0)
        
        //TODO: update new habit id to come from API
        let newHabit = Habit(id: 7,
                             name: newHabitName,
                             isComplete: false,
                             goalId: pickerData[pickerIndex].id)
        
        delegate?.addNewHabit(forHabit: newHabit)
    }
    
    @IBAction func cancelCreateNewHabit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Picker Delegate Methods
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
        newHabitAssociatedGoal.text = String(pickerData[row].name)
        self.view.endEditing(true)
    }
}
