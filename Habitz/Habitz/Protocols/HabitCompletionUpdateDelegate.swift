//
//  HabitCompletionUpdateDelegate.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/15/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//
import Foundation

protocol HabitCompletionUpdateDelegate {
    func toggleCompletion(for toggledHabit: Habit)
}
