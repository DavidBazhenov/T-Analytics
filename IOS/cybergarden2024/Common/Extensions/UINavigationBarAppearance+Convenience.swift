//
//  UINavigationBarAppearance+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

extension UINavigationBarAppearance {
    
    convenience init(
        transparent: Bool,
        color: UIColor,
        titleColor: UIColor = .appBlack,
        buttonColor: UIColor = .hexFF9500
    ) {
        self.init()
        if transparent {
            configureWithTransparentBackground()
        }
        backgroundColor = color
        titleTextAttributes = [.font: UIFont.sFProTextSemibold(ofSize: 17), .foregroundColor: titleColor]
        largeTitleTextAttributes = [.font: UIFont.sFProTextBold(ofSize: 34), .foregroundColor: titleColor]
        
        let button = UIBarButtonItemAppearance()
        [button.normal, button.highlighted].forEach {
            $0.titleTextAttributes = [.foregroundColor: buttonColor, .font: UIFont.sFProText(ofSize: 17)]
        }
        buttonAppearance = button
        doneButtonAppearance = button
        backButtonAppearance = button
    }
    
}
