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
extension UIViewController {
    
    func showAlert(title:String, message:String, okAction:@escaping ()-> Void)  {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            okAction()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
}
