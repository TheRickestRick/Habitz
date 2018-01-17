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
    let baseURL = "https://hg1bdyur16.execute-api.us-east-1.amazonaws.com/dev/goals"
    
    func getAllForUser(havingUserUid uid: String, completion: @escaping([Goal]) -> ()) -> Void {
        var allGoals: [Goal] = []
        let userGoalsURL = baseURL + "?user_uid=\(uid)"
        
        Alamofire.request(userGoalsURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // loop through all received elements to create goals
                for goal in responseJSON {
                    allGoals.append(Goal(json: goal))
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            completion(allGoals)
        }
    }
    
    func createForUser(havingUserUid uid: String, goal: Goal, completion: @escaping(Goal) -> ()) -> Void {
        let parameters: Parameters = [
            "name": goal.name,
            "percent_to_complete": goal.percentToBeComplete,
            "user_uid": uid
        ]
        var newGoal: Goal? = nil
        
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                newGoal = Goal(json: responseJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            completion(newGoal!)
        }
    }
    
//    func getGoalHaving(id: Int) -> Void {
//        print("get goal at endpoint: ")
//        print(baseURL + "/\(id)")
//    }
    
    func edit(goal: Goal) -> Void {
        let editURL = baseURL + "/\(goal.id!)"
        
        let parameters: Parameters = [
            "name": goal.name,
            "percent_to_complete": goal.percentToBeComplete
        ]
        
        Alamofire.request(editURL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func delete(goal: Goal) -> Void {
        let deleteURL = baseURL + "/\(goal.id!)"
        
        Alamofire.request(deleteURL, method: .delete).response { (response) in
            if response.error != nil {
                print("Error \(String(describing: response.error))")
            }
        }
    }
}
