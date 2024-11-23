//
//  Constants.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

class Constants {
    
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
    static let screenHeight = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    static let screenWidth = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    static let isSmallScreen = screenWidth == 320 // 5s, se
    static let isIPhone8AndLess = screenWidth <= 375 && !hasNotch
    static let isBigPhoneScreen = Constants.isIpad ? false : screenHeight >= 896
    static let isProMaxAndPlus = screenHeight >= 896
    static let screenScale = UIScreen.main.scale
    
    static let topSafeArea: CGFloat = {
        return AppNavigator.shared.window?.safeAreaInsets.top ?? 0
    }()
    static let bottomSafeArea: CGFloat = {
        return AppNavigator.shared.window?.safeAreaInsets.bottom ?? 0
    }()
    static let hasNotch = bottomSafeArea > 0
    static let statusBarHeight: CGFloat = {
        return AppNavigator.shared.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }()
    
    static let appBundle = "com.aiweapps.cybergarden2024"
    
}
