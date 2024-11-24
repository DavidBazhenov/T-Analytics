//
//  ReportViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import RxSwift

class ReportViewModel: ViewModel {
    
    public var loadWalletTransactions: PublishSubject<Bool> = PublishSubject()
    public var deleteWalletSuccess: PublishSubject<Bool> = PublishSubject()
    
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
                        self.loadWalletTransactions.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func getTransactionsById(id: String) {
        self.loading.onNext(true)
        API.Transaction.getTransactionsByWalletFromId(id: id).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let transactionsArray = returnJson?["transactions"] as? [[String: Any]], let model = transactionsArray.parse(to: [TransactionModel].self) {
                        self.transactions = model
                        self.loadWalletTransactions.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func deleteWallet(id: String) {
        self.loading.onNext(true)
        API.Wallet.deleteWallet(id: id).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                   self.deleteWalletSuccess.onNext(true)
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
}
