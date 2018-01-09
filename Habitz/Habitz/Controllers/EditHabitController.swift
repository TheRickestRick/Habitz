//
//  EditHabitController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/9/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class EditHabitController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var habitToEditName: UITextField!
    @IBOutlet weak var habitToEditAssociatedGoal: UITextField!
    
    // constants
    var habitToEdit: Habit?
    
    var editDelegate: EditHabitDelegate?
    var deleteDelegate: DeleteHabitDelegate?
    
    let pickerData = [
        Goal(id: 1, name: "Be healthier in body and mind", percentToBeComplete: 100),
        Goal(id: 2, name: "Strengthen relationships with friends", percentToBeComplete: 50),
        Goal(id: 3, name: "Start a new career is software engineering", percentToBeComplete: 75),
        Goal(id: 4, name: "Spend more time on hobbies", percentToBeComplete: 50)
    ]
    let associatedGoalPicker: UIPickerView! = UIPickerView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        associatedGoalPicker.dataSource = self
        associatedGoalPicker.delegate = self
        
        habitToEditAssociatedGoal.inputView = associatedGoalPicker
        
        
        if let habitToEdit = habitToEdit {
            habitToEditName.text = String(habitToEdit.name)
            
            if let i = pickerData.index(where: { $0.id == habitToEdit.goalId }) {
                habitToEditAssociatedGoal.text = pickerData[i].name
            }
            
        } else {
            habitToEditName.text = ""
            habitToEditAssociatedGoal.text = String(pickerData[0].name)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: - Button Methods
    @IBAction func saveChanges(_ sender: UIButton) {

        guard let editHabitName = habitToEditName.text else { return }
        guard let editHabitId = habitToEdit?.goalId else { return }
        guard let editHabitIsComplete = habitToEdit?.isComplete else { return }
        
        let pickerIndex = associatedGoalPicker.selectedRow(inComponent: 0)
        
        let editedHabit = Habit(id: editHabitId,
                                name: editHabitName,
                                isComplete: editHabitIsComplete,
                                goalId: pickerData[pickerIndex].id)
        
        editDelegate?.editHabit(for: editedHabit)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelChanges(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteHabit(_ sender: UIButton) {
        //TODO: prompt before deleting
        guard let habitToDelete = habitToEdit else { return }
        
        deleteDelegate?.deleteHabit(for: habitToDelete)
        
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
        habitToEditAssociatedGoal.text = String(pickerData[row].name)
        self.view.endEditing(true)
    }
}
