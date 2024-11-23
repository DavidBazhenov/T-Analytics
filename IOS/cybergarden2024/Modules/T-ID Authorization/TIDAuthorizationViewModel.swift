//
//  TIDAuthorizationViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import RxSwift

class TIDAuthorizationViewModel: ViewModel {
    
    public var loginUser: PublishSubject<Bool> = PublishSubject()
    
    func loginUserByTid(phone: String) {
        self.loading.onNext(true)
        API.Auth.phoneLogin(phone: phone).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let accessToken = returnJson?["accessToken"] as? String {
                        UserDefaultsHelper.shared.saveToken(accessToken)
                        self.loginUser.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
}
