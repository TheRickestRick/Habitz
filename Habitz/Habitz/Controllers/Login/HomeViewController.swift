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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print user uid
        if let userID = userID {
            print("any information here is passed via segue")
            print("user is signed in with id:")
            print(userID)
        }
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

}
