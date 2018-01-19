//
//  HabitsAPI.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/14/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HabitsAPI {
    let baseURL = "https://hg1bdyur16.execute-api.us-east-1.amazonaws.com/dev/habits"
    
    func getAllForUser(havingUid uid: String, completion: @escaping([Habit]) -> ()) -> Void {
        var allHabits: [Habit] = []
        let userHabitsURL = baseURL + "?user_uid=\(uid)"
        
        Alamofire.request(userHabitsURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    // loop through all received elements to create habits
                    for habit in jsonArray {
                        allHabits.append(Habit(json: habit))
                    }
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            completion(allHabits)
        }
    }
    
    func getAllForGoal(havingId id: Int, completion: @escaping([Habit]) -> ()) -> Void {
        var allHabits: [Habit] = []
        let userHabitsURL = baseURL + "?goal_id=\(id)"
        
        Alamofire.request(userHabitsURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // check that the response is an array type for looping
                if let jsonArray = responseJSON.array {
                    // loop through all received elements to create habits
                    for habit in jsonArray {
                        allHabits.append(Habit(json: habit))
                    }
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            completion(allHabits)
        }
    }
    
    
    func create(habit: Habit, completion: @escaping(Habit) -> ()) -> Void {
        let parameters: Parameters = [
            "name": habit.name,
            "goal_id": habit.goalId,
            "completed_streak": 0,
            "time_of_day": habit.timeOfDay
        ]
        var newHabit: Habit? = nil
        
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                newHabit = Habit(json: responseJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            completion(newHabit!)
        }
    }

    
    func edit(habit: Habit) -> Void {
        let editURL = baseURL + "/\(habit.id!)"
        
        let parameters: Parameters = [
            "name": habit.name,
            "goal_id": habit.goalId,
            "completed_streak": habit.completedStreak,
            "time_of_day": habit.timeOfDay
        ]
        
        Alamofire.request(editURL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
  
    
    func delete(habit: Habit) -> Void {
        let deleteURL = baseURL + "/\(habit.id!)"
        
        Alamofire.request(deleteURL, method: .delete).response { (response) in
            if response.error != nil {
                print("Error \(String(describing: response.error))")
            }
        }
    }
    
    
    // add completion to database
    func markComplete(_ habit: Habit, completion: @escaping() -> ()) -> Void {
        let habitCompleteURL = baseURL + "/\(habit.id!)/complete"
        
        Alamofire.request(habitCompleteURL, method: .post).responseJSON { (response) in
            if response.result.isFailure {
                print("Error \(String(describing: response.result.error))")
            }
            completion()
        }
    }
    
    // deletes completion from database
    func markIncomplete(_ habit: Habit, completion: @escaping() -> ()) -> Void {
        let habitDeleteURL = baseURL + "/\(habit.id!)/complete"
        
        Alamofire.request(habitDeleteURL, method: .delete).response { (response) in
            if response.error != nil {
                print("Error \(String(describing: response.error))")
            }
            completion()
        }
    }
    
}

