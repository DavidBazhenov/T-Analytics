//
//  UIViewController+Containment.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

extension UIViewController {
    
    func addChildController(_ viewController: UIViewController, setupView: (UIView) -> Void) {
        guard viewController.parent == nil else { return }
        viewController.willMove(toParent: self)
        addChild(viewController)
        setupView(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeChildController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
    
}
