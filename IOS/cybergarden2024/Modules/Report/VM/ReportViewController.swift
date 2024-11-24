//
//  ReportViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import RxSwift

class ReportViewController: ViewController {

    private let mainView = ReportView()
    private let viewModel = ReportViewModel()
    var id: String?
    
    var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id {
            viewModel.getTransactionsById(id: id)
        } else {
            viewModel.getAllTransactions()
        }
    }

    private func setupBindings() {
        viewModel.loadWalletTransactions.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mainView.updateTransactions(self.viewModel.transactions ?? [])
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteWalletSuccess.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.completion?()
                self.navigationController?.popViewController(animated: true)
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
        
        mainView.deleteWallet.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let id = self.id else { return }
                self.viewModel.deleteWallet(id: id)
            })
            .disposed(by: disposeBag)
        
        mainView.back.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                navigationController?.popViewController(animated: true)
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
    
    func update(id: String? = nil) {
        if let id = id {
            self.id = id
            viewModel.getTransactionsById(id: id)
        } else {
            viewModel.getAllTransactions()
        }
    }
}
