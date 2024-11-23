//
//  UIColor+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

extension UIColor {
    
    func isCloseToWhite(threshold: CGFloat = 0.1) -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let distanceToWhite = sqrt(pow(1.0 - red, 2) + pow(1.0 - green, 2) + pow(1.0 - blue, 2))
        return distanceToWhite < threshold
    }
    
}
