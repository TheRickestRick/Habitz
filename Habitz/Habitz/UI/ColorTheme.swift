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
            instanceColor = UIColor(hexString: "#1E2641")
            
        case .intermidiateBackground:
            instanceColor = UIColor(hexString: "#569CBE")
            
        case .lightBackground:
            instanceColor = UIColor(hexString: "#F0E1DA")
        
        case .neutralBackground:
            instanceColor = UIColor(hexString: "#FFFFFF")

            
        case .darkText:
            instanceColor = UIColor(hexString: "#1E2641")
            
        case .intermidiateText:
            instanceColor = UIColor(hexString: "#569CBE")
            
        case .lightText:
            instanceColor = UIColor(hexString: "#F0E1DA")
        
            
        case .success:
            instanceColor = UIColor(hexString: "#1A6F4B") //blue
            
        case .affirmation:
            instanceColor = UIColor(hexString: "#5DA661") //green
            
        case .neutral:
            instanceColor = UIColor(hexString: "#92C7DA") //grey
        
        case .warning:
            instanceColor = UIColor(hexString: "#F4BA2D") //yellow
            
        case .negation:
            instanceColor = UIColor(hexString: "#E42116") //red
            
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        
        }
        return instanceColor
    }
}
