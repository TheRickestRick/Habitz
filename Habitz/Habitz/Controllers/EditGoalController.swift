//
//  EditGoalController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/9/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class EditGoalController: UIViewController {
    var goalToEdit: Goal?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(goalToEdit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Button Methods
    @IBAction func saveChanges(_ sender: UIButton) {
        print("save changes")
    }
    
    @IBAction func cancelChanges(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteGoal(_ sender: UIButton) {
        print("delete this goal")
    }
    
}
