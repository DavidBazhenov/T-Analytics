//
//  OperationViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class OperationViewModel: ViewModel {
    
    public var getTransactions: PublishSubject<Bool> = PublishSubject()
    public var getWallets: PublishSubject<Bool> = PublishSubject()
    
    var wallets: [WalletModel]?
    var transactions: [TransactionModel]?
    
    func getAllTransactions() {
        self.loading.onNext(true)
        API.Transaction.gettAllTransactions().request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let transactionsArray = returnJson?["transactions"] as? [[String: Any]], let model = transactionsArray.parse(to: [TransactionModel].self) {
                        self.transactions = model
                        self.getTransactions.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func getAllWallets() {
        self.loading.onNext(true)
        API.Wallet.gettAllWallets().request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let wallets = returnJson?["wallets"] as? [[String: Any]], let model = wallets.parse(to: [WalletModel].self) {
                        self.wallets = model
                    }
                    self.getWallets.onNext(true)
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func allUpdate() {
        getAllWallets()
        getAllTransactions()
    }
    
}
