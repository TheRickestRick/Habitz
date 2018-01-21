//
//  FontTheme.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/21/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

extension FontScheme {
    
    var fontName: String {
        switch self {
        
        case .standard:
            return "Avenir-Roman"
        
        case .heavy:
            return "Avenir-Heavy"
        
        case .heavyOblique:
            return "Avenir-HeavyOblique"
        }
    }
    
    
    var fontSize: CGFloat {
        switch self {
            
        case .standard:
            return 17.0
            
        case .heavy:
            return 20.0
            
        case .heavyOblique:
            return 18.0
        }
    }
    
    var font: UIFont {
        switch self {
            
        case .standard:
            return UIFont(name: "Avenir-Roman", size: 17.0)!
        
        case .heavy:
            return UIFont(name: "Avenir-Heavy", size: 20.0)!
            
        case .heavyOblique:
            return UIFont(name: "Avenir-HeavyOblique", size: 18.0)!
        }
    }
    
}
