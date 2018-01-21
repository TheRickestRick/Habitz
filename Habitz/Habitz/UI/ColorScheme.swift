//
//  ColorScheme.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

enum ColorScheme {
    
    case theme
    case border
    case shadow
    
    case darkBackground
    case lightBackground
    case intermidiateBackground
    case neutralBackground
    
    case darkText
    case lightText
    case intermidiateText
    
    case success
    case affirmation
    case neutral
    case warning
    case negation

    case custom(hexString: String, alpha: Double)

    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}
