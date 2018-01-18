//
//  CompletedGoalsAPI.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/18/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CompletedGoalsAPI {
    let baseURL = "https://hg1bdyur16.execute-api.us-east-1.amazonaws.com/dev/completedgoals"
    
    // find all completions for the current day based on user
    func getTodaysCompletionsForUser(havingUid uid: String, completion: @escaping([Goal]) -> ()) -> Void {
        let todaysCompletionsURL = baseURL + "?user_uid=\(uid)"
        
        var completions: [Goal] = []
        
        Alamofire.request(todaysCompletionsURL, method: .get).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            } else {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    for completion in jsonArray {
                        
                        let goal = Goal(json: completion)
                        goal.isComplete = true
                        
                        completions.append(goal)
                    }
                    completion(completions)
                }
            }
        }
    }
    
    
    // find all completions for the PREVIOUS day based on user
    // to help build list of completed and incomplete habits
    func getYesterdaysCompletionsForUser(havingUid uid: String, completion: @escaping([Goal]) -> ()) -> Void {
        let yesterdaysCompletionsURL = baseURL + "?day=yesterday&user_uid=\(uid)"
        
        var completions: [Goal] = []
        
        Alamofire.request(yesterdaysCompletionsURL, method: .get).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            } else {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    for completion in jsonArray {
                        
                        let goal = Goal(json: completion)
                        goal.isComplete = true
                        
                        completions.append(goal)
                    }
                    completion(completions)
                }
            }
        }
    }
    
}
