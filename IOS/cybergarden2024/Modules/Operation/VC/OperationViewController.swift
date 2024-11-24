//
//  OperationViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import RxSwift

class OperationViewController: ViewController {
    
    private let mainView = OperationView()
    private let viewModel = OperationViewModel()
    
    private var wallets: [WalletModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
        viewModel.getAllWallets()
        viewModel.getAllTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getAllWallets()
        viewModel.getAllTransactions()
    }
    
    private func setupBindings() {
        viewModel.getWallets.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.mainView.updateData(transactions: self.viewModel.transactions ?? [], wallets: self.viewModel.wallets ?? (wallets ?? []))
            })
            .disposed(by: disposeBag)
        
        viewModel.getTransactions.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.mainView.updateData(transactions: self.viewModel.transactions ?? [], wallets: self.viewModel.wallets ?? (wallets ?? []))
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
        
        mainView.actions.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.handleAction(action: action)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func handleAction(action: OperationView.Action) {
        switch action {
        case .updateAll:
            viewModel.allUpdate()
        case .addTransaction:
            let modal = ModalsBuilder.buildCreateOperationModal(wallets: viewModel.wallets ?? []) { [weak self] in
                guard let self = self else { return }
                self.viewModel.allUpdate()
            }
            present(modal, animated: true)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

