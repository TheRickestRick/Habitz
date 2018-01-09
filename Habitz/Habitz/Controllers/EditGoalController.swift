//
//  EditGoalController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/9/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class EditGoalController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var formGoalName: UITextField!
    @IBOutlet weak var formGoalPercentComplete: UITextField!
    
    // constants
    var goalToEdit: Goal?
    
    var editDelegate: EditGoalDelegate?
    var deleteDelegate: DeleteGoalDelegate?
    
    let pickerData = [0, 25, 50, 75, 100]
    let percentToCompletePicker: UIPickerView! = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        percentToCompletePicker.dataSource = self
        percentToCompletePicker.delegate = self
        
        formGoalPercentComplete.inputView = percentToCompletePicker
        
        
        if let goalToEdit = goalToEdit {
            formGoalPercentComplete.text = String(goalToEdit.percentToBeComplete)
            formGoalName.text = String(goalToEdit.name)
        } else {
            formGoalPercentComplete.text = String(pickerData[0])
            formGoalName.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: - Button Methods
    @IBAction func saveChanges(_ sender: UIButton) {

        guard let editGoalName = formGoalName.text else { return }
        guard let editGoalPercent = formGoalPercentComplete.text else { return }
        guard let editGoalId = goalToEdit?.id else { return }
        
        let editGoal = Goal(id: editGoalId, name: editGoalName, percentToBeComplete: Int(editGoalPercent)!)
        
        editDelegate?.editGoal(for: editGoal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelChanges(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteGoal(_ sender: UIButton) {
        //TODO: prompt before deleting
        guard let goalToDelete = goalToEdit else { return }
        
        deleteDelegate?.deleteGoal(for: goalToDelete)
        
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
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        formGoalPercentComplete.text = String(pickerData[row])
        self.view.endEditing(true)
    }
}
