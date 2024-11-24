//
//  AuthorizationViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import RxSwift

class AuthorizationViewController: ViewController {
    
    private let mainView = AuthorizationView()
    private let viewModel = AuthorizationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
    }
    
    private func setupBindings() {
        viewModel.registerUserLoad.observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                AppNavigator.shared.showRootTabBarController()
            })
            .disposed(by: disposeBag)
        
        viewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlertView("Error", error)
                if error == "Пользователь не существует" {
                    mainView.inputFieldView.badInfo(isActive: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.loading.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                self.view.isLoading(loading)
            })
            .disposed(by: disposeBag)
        
        mainView.actions.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.handleAction(action: action)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleAction(action: AuthorizationView.Action) {
        switch action {
        case .googleTapped:
            break
        case .alert(let error):
            showAlertView("Error", error)
        case .tbankTapped:
            navigationController?.pushViewController(TIDAuthorizationViewController(), animated: true)
        case .privacyTapped:
            if let pdfURL = Bundle.main.url(forResource: "privacy", withExtension: "pdf") {
                openWebView(url: pdfURL)
            }
        case .tosTapped:
            if let pdfURL = Bundle.main.url(forResource: "tos", withExtension: "pdf") {
                openWebView(url: pdfURL)
            }
        case .exitTapped(let email, let password):
            viewModel.authUser(email: email, password: password)
        case .regTapped(let name, let email, let password):
            viewModel.regUser(name: name, email: email, password: password)
        }
    }
    
    private func openWebView(url: URL) {
        let vc = WebViewController(url: url)
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }
    
    private func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
