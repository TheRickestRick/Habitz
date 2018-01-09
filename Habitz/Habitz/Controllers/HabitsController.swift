//
//  HabitsController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/9/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit

class HabitsController: UIViewController {

    // constants
    var habitToEdit: Habit?
    
    // TODO: replace with API call
    var habits: [Habit] = [
        Habit(id: 0, name: "Drink a green smoothie", isComplete: true, goalId: 1),
        Habit(id: 0, name: "Meditate for 15 minutes", isComplete: true, goalId: 1),
        Habit(id: 0, name: "Call or text an old friend", isComplete: true, goalId: 2),
        Habit(id: 0, name: "Go to a networking event", isComplete: true, goalId: 3),
        Habit(id: 0, name: "Send mom an email", isComplete: true, goalId: 2),
        Habit(id: 0, name: "Message a new contact on LinkedIn", isComplete: true, goalId: 3)
    ]
    
    @IBOutlet weak var habitsContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHabitLabels(for: habits)
        
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
}
