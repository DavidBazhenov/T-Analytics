//
//  PredictViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import RxSwift

class PredictViewController: ViewController {

    private let mainView = PredictView()
    private let viewModel = PredictViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view = mainView
        setupBindings()
        viewModel.getPredictTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaultsHelper.shared.ml ?? false {
            viewModel.getPredictTransactions()
        } else {
            showToast(title: "Вам необходимо дать доступ в настройках")
        }
    }

    private func setupBindings() {
        viewModel.loadPredict.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mainView.update(predicts: self.viewModel.predicts ?? [])
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
