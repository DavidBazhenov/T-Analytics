//
//  EditProfileViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class EditProfileViewController: ViewController {

    private let mainView = EditProfileView()
    private let viewModel = EditProfileViewModel()
    
    public var reloadData: PublishSubject<Bool> = PublishSubject()
    
    var model: ProfileModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupBindings()
        setupKeyboardDismissRecognizer()
    }
    
    private func setupBindings() {
        viewModel.userUpdate.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSave in
                guard let self = self else { return }
                if isSave {
                    self.reloadData.onNext(true)
                    self.navigationController?.popViewController(animated: true)
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
        
        mainView.saveUser.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userData in
                guard let self = self else { return }
                self.viewModel.updateData(name: userData.fio, email: userData.email, phone: userData.number)
            })
            .disposed(by: disposeBag)
        
        mainView.back.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userData in
                guard let self = self else { return }
                navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.alert.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlertView("Error", error)
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
    
    func update() {
        guard let model = model else { return }
        mainView.update(model: model)
    }
    
}
