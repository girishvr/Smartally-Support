//
//  Extensions.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

public extension UIView {
    
    func radius(to: CGFloat) {
        self.layer.cornerRadius = to
    }
    
    func border(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
}
