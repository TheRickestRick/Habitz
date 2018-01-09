//
//  ViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/8/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AddGoalDelegate, EditGoalDelegate, DeleteGoalDelegate {
    
    // constants
    var goalToEdit: Goal?
    
    // TODO: replace with API call
    var goals = [
        Goal(id: 0, name: "Be healthier in body and mind", percentToBeComplete: 100),
        Goal(id: 1, name: "Strengthen relationships with friends", percentToBeComplete: 50),
        Goal(id: 2, name: "Start a new career is software engineering", percentToBeComplete: 75),
        Goal(id: 3, name: "Spend more time on hobbies", percentToBeComplete: 50)
    ]
    
    
    @IBOutlet weak var oneGoal: UILabel!
    @IBOutlet weak var goalsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGoalLabels(for: goals)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: - Rendering Methods
    func createGoalLabels(for goals: [Goal]) -> Void {
        //TODO: offset relative to last created label aka goal
        var baseTopOffset: CGFloat = 0.0
        var goalIndex = 0
        
        for goal in goals {
            baseTopOffset += 50.0
            
            let label = UILabel()
            label.textAlignment = .left
            label.text = goal.name
            label.tag = goal.id            
            
            label.contentMode = .scaleToFill
            label.numberOfLines = 0
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            label.addGestureRecognizer(tap)
            label.isUserInteractionEnabled = true
            
            goalsContainer.addSubview(label)
            
            setupLabelConstraints(for: label, offsetTopBy: baseTopOffset)
            
            goalIndex += 1
        }
    }

    func setupLabelConstraints(for label:UILabel, offsetTopBy topOffset: CGFloat) -> Void {
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        
        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: topOffset).isActive = true
        label.centerXAnchor.constraint(equalTo: label.superview!.centerXAnchor).isActive = true

    }
    
    func clearAllLabels(from view: UIView) -> Void {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
    
    func updateView() -> Void {
        clearAllLabels(from: goalsContainer)
        createGoalLabels(for: goals)
    }
    
 
    
    //MARK: - Delegate methods
    func addNewGoal(newGoal: Goal) {
        goals.append(newGoal)
                
        updateView()
    }
    
    func editGoal(for goal: Goal) {
        if let i = goals.index(where: { $0.id == goal.id }) {
            goals[i] = goal
        }
        
        updateView()
    }
    
    func deleteGoal(for goal: Goal) {
        if let i = goals.index(where: { $0.id == goal.id }) {
            goals.remove(at: i)
        }
        
        updateView()
    }
    
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGoal" {
            let createGoalController = segue.destination as! CreateGoalController
            createGoalController.delegate = self
        }
        
        if segue.identifier == "editGoal" {
            let editGoalController = segue.destination as! EditGoalController
            editGoalController.goalToEdit = goalToEdit
            editGoalController.editDelegate = self
            editGoalController.deleteDelegate = self
        }
    }

    
    
    //MARK: - Gestures Methods
    @objc func handleTap(sender: UITapGestureRecognizer) -> Void {
        guard let tappedView = sender.view else {
            return
        }
        
        if let i = goals.index(where: { $0.id == tappedView.tag }) {
            goalToEdit = goals[i]
        }
        
        performSegue(withIdentifier: "editGoal", sender: self)
    }
}

