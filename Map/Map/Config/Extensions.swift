//
//  Extensions.swift
//  Map
//
//  Created by faizal on 15/03/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - Static Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func setBorder(of view:UIView, borderColor color:CGColor, borderWidth width:CGFloat , cornerRadius radius:CGFloat) {
        view.layer.borderColor = color
        view.layer.borderWidth = width
        view.layer.cornerRadius = radius
        
    }
    
}
