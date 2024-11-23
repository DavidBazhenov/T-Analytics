//
//  RootTabBarViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

fileprivate extension RootTabBarItem {
    
    var viewController: UIViewController {
        switch self {
        case .operations:
            return IntroViewController()
        case .wallets:
            return IntroViewController()
        case .ai:
            return IntroViewController()
        case .notifications:
            return IntroViewController()
        case .profile:
            return ControllerCreator.createProfile()
        }
    }
    
}

class RootTabBarViewController: UITabBarController {
    
    private let tabBarItemsView = RootTabBarItemsView()
    
    private(set) var selectedTabBarItem = RootTabBarItem.operations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewControllers()
        setupLayout()
        selectTabBarItem(.operations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setTabBarHidden(_ hidden: Bool) {
        super.setTabBarHidden(hidden)
    }
    
    func selectTabBarItem(_ tabBarItem: RootTabBarItem) {
        selectedIndex = tabBarItem.rawValue
        tabBarItemsView.setSelectedTabItem(tabBarItem)
        selectedTabBarItem = tabBarItem
    }
    
    // MARK: - Helpers
    
    private func setupViewControllers() {
        let controllers = RootTabBarItem.allCases.map { $0.viewController }
        viewControllers = controllers.map { controller in
            let navigation = AppNavigationController(rootViewController: controller)
            navigation.delegate = self
            return navigation
        }
    }
    
    private func setupViews() {
        tabBarItemsView.handleTabBarItemSelected = { [weak self] tabBarItem in
            if self?.selectedTabBarItem == tabBarItem {
                let navVc = self?.selectedViewController as? UINavigationController
                navVc?.popToRootViewController(animated: true)
            } else {
                self?.selectTabBarItem(tabBarItem)
            }
        }
    }
    
    private func setupLayout() {
        tabBar.addSubview(tabBarItemsView)
        tabBarItemsView.edgesToSuperview()
    }
    
}

// MARK: - UINavigationControllerDelegate

extension RootTabBarViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard selectedViewController == navigationController else { return }
    }

}
