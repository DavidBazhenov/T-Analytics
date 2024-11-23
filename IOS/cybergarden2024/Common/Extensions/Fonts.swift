//
//  Fonts.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

extension UIFont {
    
    static func sFProText(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size)!
    }
    
    static func sFProTextMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size)!
    }
    
    static func sFProTextSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: size)!
    }
    
    static func sFProTextBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Bold", size: size)!
    }
    
    static func interBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Bold", size: size)!
    }
    
    static func interMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium", size: size)!
    }
    
    static func interRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Regular", size: size)!
    }
    
    static func interSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-SemiBold", size: size)!
    }

    static func interDisplayBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "InterDisplay-Bold", size: size)!
    }
    
    static func interDisplayMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "InterDisplay-Medium", size: size)!
    }
    
    static func interDisplayRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "InterDisplay-Regular", size: size)!
    }
    
    static func interDisplaySemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "InterDisplay-SemiBold", size: size)!
    }
    
    static func sFProTextHeavy(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Heavy", size: size) ?? .systemFont(ofSize: size, weight: .heavy)
    }
}
