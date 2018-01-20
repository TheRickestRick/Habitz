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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    convenience init(startingValue: Int) {
        self.init(frame: CGRect.zero)
        self.counter = startingValue
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.width / 2
        
        self.addLabel()
    }
    
    
    func incrementCounter() -> Void {
        self.counter += 1
    }
    
    func decrementCounter() -> Void {
        self.counter -= 1
    }
    
    
    private func addLabel() -> Void {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
        
        label.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        label.textAlignment = .center
        label.text = "\(self.counter)"
        
        self.addSubview(label)
    }
}

