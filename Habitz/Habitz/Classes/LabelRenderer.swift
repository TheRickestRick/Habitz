////
////  LabelRenderer.swift
////  Habitz
////
////  Created by Ryan Wittrup on 1/9/18.
////  Copyright © 2018 Ryan Wittrup. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class LabelRenderer {
//    let view: UIViewController
//    let labelContainer: UIView
//
//    init(view: UIViewController, labelContainer: UIView) {
//        self.view = view
//        self.labelContainer = labelContainer
//    }
//
//
//    func setupLabelConstraints(for label:UILabel, offsetTopBy topOffset: CGFloat) -> Void {
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        //        label.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
//        label.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
//
//        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: topOffset).isActive = true
//        label.centerXAnchor.constraint(equalTo: label.superview!.centerXAnchor).isActive = true
//
//    }
//
//}
//
//class GoalsLabelRenderer: LabelRenderer {
//    let goals: [Goal]
//
//    init(view: UIViewController, labelContainer: UIView, goals: [Goal]) {
//        self.goals = goals
//        super.init(view: view, labelContainer: labelContainer)
//    }
//
//    func createGoalLabels() -> Void {
//        //TODO: offset relative to last created label aka goal
//        var baseTopOffset: CGFloat = 0.0
//        var goalIndex = 0
//
//        for goal in goals {
//            baseTopOffset += 50.0
//
//            let label = UILabel()
//            label.textAlignment = .left
//            label.text = goal.name
//            label.tag = goal.id
//
//            label.contentMode = .scaleToFill
//            label.numberOfLines = 0
//
//            let tap = UITapGestureRecognizer(target: view, action: #selector(self.handleTap))
//            label.addGestureRecognizer(tap)
//            label.isUserInteractionEnabled = true
//
//            labelContainer.addSubview(label)
//
//            setupLabelConstraints(for: label, offsetTopBy: baseTopOffset)
//
//            goalIndex += 1
//        }
//    }
//
//    @objc func handleTap(sender: UITapGestureRecognizer) -> Void {
//        print("class handleTap")
//        guard let tappedView = sender.view else {
//            return
//        }
//
//        if let i = goals.index(where: { $0.id == tappedView.tag }) {
//            goalToEdit = goals[i]
//        }
//
//        view.performSegue(withIdentifier: "editGoal", sender: self)
//    }
//}

