//
//  CreateOperationViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class CreateOperationViewModel: ViewModel {
    
    public var createTransactionComplete: PublishSubject<Bool> = PublishSubject()
    
    var wallets: [WalletModel]?
    var transactions: [TransactionModel]?

    func createTransaction(userId: String = "", walletFromId: String, amount: Float, type: String, date: String, description: String, category: TransactionModel.Category) {
        self.loading.onNext(true)
        let transactionRequest = API.Transaction.createTransaction(
            userId: userId,
            walletFromId: walletFromId,
            amount: amount,
            type: type,
            date: date,
            description: description,
            category: category
        ).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success:
                    self.createTransactionComplete.onNext(true)
                case .failure(let error):
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
}
