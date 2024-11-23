//
//  WalletViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class WalletViewModel: ViewModel {
    
    public var getWallets: PublishSubject<Bool> = PublishSubject()
    public var getTransactions: PublishSubject<Bool> = PublishSubject()
    
    var transactions: [TransactionsModel]?
    var wallets: [WalletsModel]?
    
    func getAll(email: String, password: String) {
        self.loading.onNext(true)
        API.Wallets.login(email: email, password: password).request()
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
