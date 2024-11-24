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
    
    static func createWallet() -> ViewController {
        return WalletViewController()
    }
    
    static func createAuthorization() -> ViewController {
        return AuthorizationViewController()
    }
    
    static func createIntro() -> ViewController {
        return IntroViewController()
    }
    
    static func createProfile() -> ViewController {
        return ProfileViewController()
    }
    
    static func createOperations() -> ViewController {
        return OperationViewController()
    }
    
    static func createReport() -> ViewController {
        return ReportViewController()
    }
    
    static func createPlan() -> ViewController {
        return PredictViewController()
    }
    
}
