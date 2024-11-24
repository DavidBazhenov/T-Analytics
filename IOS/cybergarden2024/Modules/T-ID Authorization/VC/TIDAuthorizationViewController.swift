//
//  TIDAuthorizationViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import RxSwift
import LocalAuthentication

class TIDAuthorizationViewController: ViewController {
    
    private let mainView = TIDAuthorizationView()
    private let viewModel = TIDAuthorizationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
    }
    
    private func setupBindings() {
        viewModel.loginUser.observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                AppNavigator.shared.showRootTabBarController()
            })
            .disposed(by: disposeBag)
        
        viewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlertView("Error", error)
            })
            .disposed(by: disposeBag)
        
        viewModel.loading.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                self.view.isLoading(loading)
            })
            .disposed(by: disposeBag)
        
        mainView.action.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.handleAction(action: action)
            })
            .disposed(by: disposeBag)
    }
    
    private func authenticateWithFaceID(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Авторизуйтесь с помощью Face ID для доступа"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluationError in
                DispatchQueue.main.async {
                    completion(success, evaluationError)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
    }
    
    private func handleAction(action: TIDAuthorizationView.Actions) {
        switch action {
        case .login(let phone):
            authenticateWithFaceID { [weak self] success, error in
                guard let self = self else { return }
                if success {
                    self.viewModel.loginUserByTid(phone: phone)
                } else {
                    if let error = error {
                        self.showAlertView("Error", error.localizedDescription)
                    } else {
                        self.showAlertView("Error", "Аутентификация не выполнена")
                    }
                }
            }
        case .back:
            navigationController?.popViewController(animated: true)
        case .alert(let alert):
            showAlertView("Error", alert)
        }
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
