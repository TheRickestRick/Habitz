//
//  GoalIdPickerDelegate.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/19/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

class GoalIdPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerData: [Goal]
    var textField: UITextField
    var view: UIView
    
    init(forTextField field: UITextField, withData data: [Goal], forView view: UIView) {
        self.pickerData = data
        self.textField = field
        self.view = view
    }

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
        textField.text = String(pickerData[row].name)
        view.endEditing(true)
    }
}
