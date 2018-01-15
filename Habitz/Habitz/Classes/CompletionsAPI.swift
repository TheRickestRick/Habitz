//
//  CompletionsAPI.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/15/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CompletionsAPI {
    let baseURL = "http://localhost:3000/api/habits"
    
    // add completion to database
    func markComplete(_ habit: Habit) -> Void {
        let habitCompleteURL = baseURL + "/\(habit.id!)/complete"
        
        Alamofire.request(habitCompleteURL, method: .post).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    // deletes completion from database
    func markIncomplete(_ habit: Habit) -> Void {
        let habitDeleteURL = baseURL + "/\(habit.id!)/complete"
        
        Alamofire.request(habitDeleteURL, method: .delete).response { (response) in
            if response.error != nil {
                print("Error \(String(describing: response.error))")
            }
        }
    }
    
    
    // find all completions for the current day based on user
    // to help build list of completed and incomplete habits
    func getTodaysCompletionsForUser(havingUid uid: String, completion: @escaping([Habit]) -> ()) -> Void {
        let todaysCompletionsURL = "http://localhost:3000/api/completions?user_uid=\(uid)"
        
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
