//
//  HabitsController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/9/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class HabitsController: UIViewController, CreateHabitDelegate, EditHabitDelegate, DeleteHabitDelegate {
    
    // constants
    var habitToEdit: Habit?
    
    // TODO: replace with API call
    var habits: [Habit] = [
        Habit(id: 1, name: "Drink a green smoothie", isComplete: true, goalId: 1),
        Habit(id: 2, name: "Meditate for 15 minutes", isComplete: true, goalId: 1),
        Habit(id: 3, name: "Call or text an old friend", isComplete: true, goalId: 2),
        Habit(id: 4, name: "Go to a networking event", isComplete: true, goalId: 3),
        Habit(id: 5, name: "Send mom an email", isComplete: true, goalId: 2),
        Habit(id: 6, name: "Message a new contact on LinkedIn", isComplete: true, goalId: 3)
    ]
    
    @IBOutlet weak var habitsContainer: UIView!
    @IBOutlet weak var headerContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHabitLabels(for: habits)
        
        // set up swipe gesture recognizer on header
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeHeaderRight(sender:)))
        headerContainer.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeHeaderLeft(sender:)))
        swipeLeft.direction = .left
        headerContainer.addGestureRecognizer(swipeLeft)
        
        headerContainer.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Rendering Methods
    func createHabitLabels(for habits: [Habit]) -> Void {
        //TODO: offset relative to last created label aka goal
        var baseTopOffset: CGFloat = 0.0
        var goalIndex = 0
        
        for habit in habits {
            baseTopOffset += 50.0
            
            let label = UILabel()
            label.textAlignment = .left
            label.text = habit.name
            label.tag = habit.id
            
            label.contentMode = .scaleToFill
            label.numberOfLines = 0
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            label.addGestureRecognizer(tap)
            label.isUserInteractionEnabled = true
            
            habitsContainer.addSubview(label)
            
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
        clearAllLabels(from: habitsContainer)
        createHabitLabels(for: habits)
    }

    
    
    //MARK: - Delegate Methods
    func addNewHabit(forHabit habit: Habit) {
        habits.append(habit)
        
        updateView()
    }
    
    func editHabit(for habit: Habit) {
        print("edit habit")
        print(habit)
    }
    
    func deleteHabit(for habit: Habit) {
        print("delete habit")
        print(habit)
    }

    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createHabit" {
            let createHabitController = segue.destination as! CreateHabitController
            createHabitController.delegate = self
        }
        
        if segue.identifier == "editHabit" {
            let editHabitController = segue.destination as! EditHabitController
            
            editHabitController.habitToEdit = habitToEdit
            
            editHabitController.editDelegate = self
            editHabitController.deleteDelegate = self
        }
    }
    
    
    //MARK: - Gestures Methods
    @objc func handleTap(sender: UITapGestureRecognizer) -> Void {
        guard let tappedView = sender.view else {
            return
        }
        
        if let i = habits.index(where: { $0.id == tappedView.tag }) {
            habitToEdit = habits[i]
        }
        
        performSegue(withIdentifier: "editHabit", sender: self)
    }
    
    @objc func handleSwipeHeaderRight(sender: UISwipeGestureRecognizer) -> Void {
        if sender.state == .ended {
            //TODO: change animation from bottom to top to right to left to match swipe
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSwipeHeaderLeft(sender: UISwipeGestureRecognizer) -> Void {
        if sender.state == .ended {
            print("swiped to the left")
        }
    }
}
