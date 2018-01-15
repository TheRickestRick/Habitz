//
//  CompletionsAPI.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/15/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire


class CompletionsAPI {
    let baseURL = "http://localhost:3000/api/habits"
    
    func markComplete(_ habit: Habit) -> Void {
        let habitCompleteURL = baseURL + "/\(habit.id!)/complete"
        
        Alamofire.request(habitCompleteURL, method: .post).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func markIncomplete(_ habit: Habit) -> Void {
        let habitDeleteURL = baseURL + "/\(habit.id!)/complete"
        
        Alamofire.request(habitDeleteURL, method: .delete).response { (response) in
            if response.error != nil {
                print("Error \(String(describing: response.error))")
            }
        }
    }
}
