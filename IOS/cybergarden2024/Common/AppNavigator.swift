//
//  AppNavigator.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    private let defaultStatusBarStyle = UIStatusBarStyle.darkContent
    private lazy var statusBarStyle = defaultStatusBarStyle
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return topViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleStatusBarStyleChange(_:)), name: .statusBarStyleDidChange, object: nil)
    }
    
    @objc private func handleStatusBarStyleChange(_ notification: Notification) {
        if let newStyle = notification.userInfo?[NotificationKeys.statusBarStyle] as? UIStatusBarStyle {
            setStatusBarStyle(newStyle)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .statusBarStyleDidChange, object: nil)
    }
    
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setDefaultStatusBarStyle() {
        setStatusBarStyle(defaultStatusBarStyle)
    }
}

class AppNavigator {
    
    static let shared = AppNavigator()
    
    private(set) var window: UIWindow?
    
    var topViewController: UIViewController? {
        return window?.rootViewController?.topViewController()
    }
    
    func setupRootNavigationInWindow(_ window: UIWindow?) {
        self.window = window
        // Add reg or auth
        if let token = UserDefaultsHelper.shared.token {
            showRootTabBarController()
        } else {
            showAuthController()
        }
    }

    // MARK: - Helpers
    
    func showRootTabBarController() {
        window?.rootViewController = ControllerCreator.createRoot()
    }
    
    func showAuthController() {
        window?.rootViewController = UINavigationController(rootViewController: ControllerCreator.createAuthorization())
    }

}

extension UIViewController {
    
    func setNavigationStatusBarStyle(_ style: UIStatusBarStyle) {
        NotificationCenter.default.post(name: .statusBarStyleDidChange, object: nil, userInfo: [NotificationKeys.statusBarStyle: style])
    }
    
    func setNavigationDefaultStatusBarStyle() {
        NotificationCenter.default.post(name: .statusBarStyleDidChange, object: nil, userInfo: [NotificationKeys.statusBarStyle: UIStatusBarStyle.darkContent])
    }
}

// MARK: - Notification Name Extension

extension Notification.Name {
    static let statusBarStyleDidChange = Notification.Name("statusBarStyleDidChange")
}

// MARK: - Notification Keys

struct NotificationKeys {
    static let statusBarStyle = "statusBarStyle"
}

