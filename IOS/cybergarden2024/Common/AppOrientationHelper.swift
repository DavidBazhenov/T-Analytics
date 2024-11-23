//
//  AppOrientationHelper.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

class AppOrientationHelper {
    
    static let shared = AppOrientationHelper()
    
    private(set) var orientationLock = UIInterfaceOrientationMask.portrait
    
    var isLandscape: Bool {
        if #available(iOS 16.0, *), let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.interfaceOrientation.isLandscape
        }
        return UIDevice.current.orientation.isLandscape
    }
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        orientationLock = orientation
    }
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask, rotateTo rotateOrientation: UIInterfaceOrientation) {
        lockOrientation(orientation)
        
        if #available(iOS 16.0, *), let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientationMask = rotateOrientation.isLandscape ? UIInterfaceOrientationMask.landscapeLeft : .portrait
            scene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationMask))
        } else {
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
}
