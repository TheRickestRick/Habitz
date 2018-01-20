//
//  ColorTheme.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

extension ColorScheme {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            instanceColor = UIColor(hexString: "#333333")
            
        case .theme:
            instanceColor = UIColor(hexString: "#ffcc00")
            
        case .shadow:
            instanceColor = UIColor(hexString: "#cccccc")
            
        case .darkBackground:
            instanceColor = UIColor(hexString: "#565D96")
            
        case .lightBackground:
            instanceColor = UIColor(hexString: "#FFF1CD")
            
        case .intermidiateBackground:
            instanceColor = UIColor(hexString: "#cccc99")
            
        case .darkText:
            instanceColor = UIColor(hexString: "#565D96")
            
        case .intermidiateText:
            instanceColor = UIColor(hexString: "#999999")
            
        case .lightText:
            instanceColor = UIColor(hexString: "#FFF1CD")
            
        case .affirmation:
            instanceColor = UIColor(hexString: "#00ff66")
            
        case .negation:
            instanceColor = UIColor(hexString: "#ff3300")
            
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}
