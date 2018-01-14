//
//  GoalsAPI.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/14/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GoalsAPI {
    let URL = "http://localhost:3000/api/goals"
    
    func getAll() -> Void {
        print("add this goal to the database")
        
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                print(responseJSON)
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func create(goal: Goal) -> Void {
        print("add this goal to the database")
        let parameters: Parameters = [
            "name": goal.name,
            "percent_to_complete": goal.percentToBeComplete,
            "user_uid": "FCewGYWopDh31UsekV8gqgD16lq1"
        ]
        
        Alamofire.request(URL, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                print(responseJSON)
            } else {
                print("Error \(response.result.error)")
            }
        }
    }
}
