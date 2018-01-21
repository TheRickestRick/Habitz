//
//  EditableTableDelegate.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/21/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation

protocol EditableTableDelegate  {
    func editHabit(for editedHabit: Habit) -> Void
}
