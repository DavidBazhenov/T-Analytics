//
//  UIAlertAction+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

extension UIAlertAction {
    
    convenience init(title: String, style: UIAlertAction.Style = .default, image: UIImage?, handler: @escaping (UIAlertAction) -> Void) {
        self.init(title: title, style: style, handler: handler)
        setValue(image, forKey: "image")
    }
    
}
