//
//  CreateOperationViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import RxSwift

class CreateOperationViewController: ViewController {

    var onSuccess: (() -> Void)?

    private let mainView = CreateOperationView()
    private let viewModel = CreateOperationViewModel()
    private var wallets: [WalletModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
    }

    private func setupBindings() {
        viewModel.createTransactionComplete.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.onSuccess?()
                }
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

        mainView.addOperation.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let operation = self.mainView.validateAndReturnData() {
                    self.viewModel.createTransaction(walletFromId: operation.walletFromId, amount: operation.amount, type: operation.type, date: operation.date, description: operation.description, category: operation.category)
                }
            })
            .disposed(by: disposeBag)

        mainView.alerts.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                self.showAlertView("Error", alert)
            })
            .disposed(by: disposeBag)
    }

    private func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func updateWallets(wallets: [WalletModel]) {
        self.wallets = wallets
        mainView.updateWallets(wallets)
    }
}
