//
//  CreateGoalController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class CreateGoalController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var formNewGoalName: UITextField!
    @IBOutlet weak var formNewGoalPercentText: UITextField!
    
    // constants
    let pickerData = [0, 25, 50, 75, 100]
    let percentToCompletePicker: UIPickerView! = UIPickerView()
    
    var delegate: AddGoalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        percentToCompletePicker.dataSource = self
        percentToCompletePicker.delegate = self
        
        formNewGoalPercentText.inputView = percentToCompletePicker
        formNewGoalPercentText.text = String(pickerData[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Button Methods
    @IBAction func createNewGoal(_ sender: UIButton) {
        guard let newGoalName = formNewGoalName.text else { return }
        let pickerIndex = percentToCompletePicker.selectedRow(inComponent: 0)
        
        //TODO: change from hardcoded id to use API and returned ID
        let newGoal = Goal(id: 5,
                           name: newGoalName,
                           percentToBeComplete: pickerData[pickerIndex],
                           completedStreak: 0)
        
        delegate?.addNewGoal(newGoal: newGoal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelCreateNewGoal(_ sender: UIButton) {
        //TODO: prompt user before canceling if there is any text in the new goal area
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
        formNewGoalPercentText.text = String(pickerData[row])
        self.view.endEditing(true)
    }
    
}
