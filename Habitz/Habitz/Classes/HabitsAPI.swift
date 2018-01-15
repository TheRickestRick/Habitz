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
    let baseURL = "http://localhost:3000/api/habits"
    
    func getAllForUser(havingUid uid: String, completion: @escaping([Habit]) -> ()) -> Void {
        var allHabits: [Habit] = []
        let userHabitsURL = baseURL + "?user_uid=\(uid)"
        
        Alamofire.request(userHabitsURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON: JSON = JSON(response.result.value!)
                
                // loop through all received elements to create goals
                for habit in responseJSON {
                    allHabits.append(Habit(json: habit))
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
            "completed_streak": 0
        ]
        var newHabit: Habit? = nil
        
        Alamofire.request(baseURL, method: .post, parameters: parameters).responseJSON {
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
    
//    func getHabitHaving(id: Int) -> Void {
//        print("get habit at endpoint: ")
//        print(baseURL + "/\(id)")
//    }
    
    func edit(habit: Habit) -> Void {
        let editURL = baseURL + "/\(habit.id!)"
        
        let parameters: Parameters = [
            "name": habit.name,
            "goal_id": habit.goalId,
            "completed_streak": 0
        ]
        
        Alamofire.request(editURL, method: .patch, parameters: parameters).responseJSON { (response) in
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
}

