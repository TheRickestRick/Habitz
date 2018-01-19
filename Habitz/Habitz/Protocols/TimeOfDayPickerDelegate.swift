//
//  TimeOfDayPickerDelegate.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/19/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

class TimeOfDayPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let pickerData: [String] = ["morning", "afternoon", "evening"]
    var textField: UITextField
    var view: UIView
    
    init(forTextField field: UITextField, forView view: UIView) {
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
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerData[row]
        view.endEditing(true)
    }
}

