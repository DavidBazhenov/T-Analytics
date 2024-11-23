//
//  WalletViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import RxSwift

class WalletViewController: ViewController {
    
    private let mainView = WalletView()
    private let viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
        viewModel.getAllWallets()
        viewModel.getAllTransactions()
    }
    
    private func setupBindings() {
        viewModel.getWallets.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.mainView.update(with: self.viewModel.wallets ?? [], sum: self.viewModel.sum ?? 0.0)
            })
            .disposed(by: disposeBag)
        
        viewModel.getTransactions.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.mainView.updateGraph(data: self.viewModel.convertTransactions())
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
    
    private func handleAction(action: WalletView.Action) {
        switch action {
        case .createCashWallet:
            createWallet(isCash: true)
        case .createCardWallet:
            createWallet(isCash: false)
        case .goToWallet(let id):
            break
        case .openReport:
            break
        case .updateAll:
            viewModel.allUpdate()
        }
    }
    
    private func createWallet(isCash: Bool) {
        let modal = ModalsBuilder.buildCreateWalletModal(
            isCash: isCash,
            actionCard: { [weak self] name, currency in
                self?.viewModel.createCard(name: name, currency: currency)
            },
            actionCash: { [weak self]  name, currency in
                self?.viewModel.createCash(name: name, currency: currency)
            }
        )
        present(modal, animated: true, completion: nil)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
