//
//  AuthorizationViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import RxSwift

class AuthorizationViewModel: ViewModel {
    
    public var registerUserLoad: PublishSubject<Bool> = PublishSubject()
    
    func authUser(email: String, password: String) {
        self.loading.onNext(true)
        API.Auth.login(email: email, password: password).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let accessToken = returnJson?["accessToken"] as? String {
                        UserDefaultsHelper.shared.saveToken(accessToken)
                        self.registerUserLoad.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func regUser(name: String, email: String, password: String) {
        self.loading.onNext(true)
        API.Auth.register(name: name, email: email, password: password).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let accessToken = returnJson?["accessToken"] as? String {
                        UserDefaultsHelper.shared.saveToken(accessToken)
                        self.registerUserLoad.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
}
