//
//  AppDelegate.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppSetupManager.setup()
        window = UIWindow(frame: UIScreen.main.bounds)
        AppNavigator.shared.setupRootNavigationInWindow(window)
        window?.makeKeyAndVisible()
        return true
    }
    
}
