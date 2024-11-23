//
//  UIBarButtonItem+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

extension UIBarButtonItem {
    
    var view: UIView? {
        return value(forKey: "view") as? UIView
    }
    
    static func space() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    func addTarget(_ target: AnyObject?, action: Selector?) {
        self.target = target
        self.action = action
    }
    
}
