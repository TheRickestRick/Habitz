//
//  CompletedHabitsAPI.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/18/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CompletedHabitsAPI {
    let baseURL = "https://hg1bdyur16.execute-api.us-east-1.amazonaws.com/dev/completedhabits"
    
    // find all completions for the current day based on user
    // to help build list of completed and incomplete habits
    func getTodaysCompletionsForUser(havingUid uid: String, completion: @escaping([Habit]) -> ()) -> Void {
        let todaysCompletionsURL = baseURL + "?user_uid=\(uid)"
        
        var completions: [Habit] = []
        
        Alamofire.request(todaysCompletionsURL, method: .get).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            } else {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    for completion in jsonArray {
                        
                        // setup properties for initializing habit
                        let id = completion["id"].intValue
                        let name = completion["name"].stringValue
                        let isComplete = true
                        let goalId = completion["goal_id"].intValue
                        let completedStreak = completion["completed_streak"].intValue
                        
                        completions.append(Habit(id: id, name: name, isComplete: isComplete, goalId: goalId, completedStreak: completedStreak))
                    }
                    completion(completions)
                }
            }
        }
    }
    
    
    // find all completions for the PREVIOUS day based on user
    // to help build list of completed and incomplete habits
    func getYesterdaysCompletionsForUser(havingUid uid: String, completion: @escaping([Habit]) -> ()) -> Void {
        let yesterdaysCompletionsURL = baseURL + "?day=yesterday&user_uid=\(uid)"
        
        var completions: [Habit] = []
        
        Alamofire.request(yesterdaysCompletionsURL, method: .get).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            } else {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    for completion in jsonArray {
                        
                        // setup properties for initializing habit
                        let id = completion["id"].intValue
                        let name = completion["name"].stringValue
                        let isComplete = true
                        let goalId = completion["goal_id"].intValue
                        let completedStreak = completion["completed_streak"].intValue
                        
                        completions.append(Habit(id: id, name: name, isComplete: isComplete, goalId: goalId, completedStreak: completedStreak))
                    }
                    completion(completions)
                }
            }
        }
    }
    
    // find all completions for the current day based on user
    // to help build list of completed and incomplete habits
    func getTodaysCompletionsForGoal(havingId id: Int, completion: @escaping([Habit]) -> ()) -> Void {
        let todaysCompletionsURL = baseURL + "?goal_id=\(id)"
        
        var completions: [Habit] = []
        
        Alamofire.request(todaysCompletionsURL, method: .get).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            } else {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    for completion in jsonArray {
                        
                        // setup properties for initializing habit
                        let id = completion["id"].intValue
                        let name = completion["name"].stringValue
                        let isComplete = true
                        let goalId = completion["goal_id"].intValue
                        let completedStreak = completion["completed_streak"].intValue
                        
                        completions.append(Habit(id: id, name: name, isComplete: isComplete, goalId: goalId, completedStreak: completedStreak))
                    }
                    completion(completions)
                }
            }
        }
    }
    
}
