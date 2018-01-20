//
//  CounterView.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/20/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import Foundation
import UIKit

class CounterView: UIView {
    var counter: Int = 0
    var counterLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.width / 2
        
        self.addLabel()
    }
    
    
    func setCounter(to counter: Int) -> Void {
        self.counter = counter
        self.counterLabel.text = "\(self.counter)"
        self.updateColor()
    }
    
    func incrementCounter() -> Void {
        self.counter += 1
        self.updateColor()
    }
    
    func decrementCounter() -> Void {
        self.counter -= 1
        self.updateColor()
    }
    
    
    // update the background color based on the counter value
    func updateColor() -> Void {
        switch self.counter {
        
        case let x where x < -3:
            self.backgroundColor = ColorScheme.negation.value
        
        case let x where x < 0:
            self.backgroundColor = UIColor.yellow // warning
        
        case let x where x < 10:
            self.backgroundColor = ColorScheme.affirmation.value
        
        case let x where x > 10:
            self.backgroundColor = UIColor.blue // success
        
        default:
            self.backgroundColor = ColorScheme.lightBackground.value
        }
    }
    
    
    private func addLabel() -> Void {
        counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
        
        counterLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        counterLabel.textAlignment = .center
        counterLabel.text = "\(self.counter)"
        
        self.addSubview(counterLabel)
    }
}

