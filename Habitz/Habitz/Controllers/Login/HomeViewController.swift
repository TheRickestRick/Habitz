//
//  HomeViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/10/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // constants
    var userID: String?
    
    let goalsAPI = GoalsAPI()
    let habitsAPI = HabitsAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToHome" {
            let homeViewController = segue.destination as! GoalsHabitsTabBarController
            
            goalsAPI.getAllForUser(havingUserUid: userID!, completion: { (goals) in
                homeViewController.goals = goals
                
                self.habitsAPI.getAllForUser(havingUid: self.userID!, completion: { (habits) in
                    homeViewController.habits = habits
                    
                    Thread.sleep(forTimeInterval: 1)
                    segue.perform()
                })
            })
        }
    }

}
