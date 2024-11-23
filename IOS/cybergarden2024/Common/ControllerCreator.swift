//
//  ControllerCreator.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import UIKit

class ControllerCreator {
    
    static func createRoot() -> UITabBarController {
        return RootTabBarViewController()
    }
    
    static func createAuthorization() -> ViewController {
        return AuthorizationViewController()
    }
    
    static func createCreateWallet() -> ViewController {
        return CreateWalletViewController()
    }
    
    static func createIntro() -> ViewController {
        return IntroViewController()
    }
    
    static func createProfile() -> ViewController {
        return ProfileViewController()
    }
    
}
