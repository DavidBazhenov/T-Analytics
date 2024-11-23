//
//  AppSetupManager.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit
import Firebase

class AppSetupManager {

    class func setup() {
        FirebaseApp.configure()
        AppOrientationHelper.shared.lockOrientation(.portrait)
        setupAppearance()
    }
    
    // MARK: - Helpers
    
    private class func setupAppearance() {
        let color = UIColor.hexF9F9F9
        let navAppearance = UINavigationBarAppearance(transparent: false, color: color)
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = .hexFF9500
        
        let toolbarApperance = UIToolbarAppearance()
        toolbarApperance.backgroundColor = .hexF9F9F9
        UIToolbar.appearance().standardAppearance = toolbarApperance
        if #available(iOS 15.0, *) {
            UIToolbar.appearance().scrollEdgeAppearance = toolbarApperance
        }
        UIToolbar.appearance().tintColor = .hexFF9500
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = color
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
    }
    
}
