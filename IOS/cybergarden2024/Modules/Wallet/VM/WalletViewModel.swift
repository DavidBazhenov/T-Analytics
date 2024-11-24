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
    
    var transactions: [[TransactionModel]]?
    var wallets: [WalletModel]?
    var sum: Double?
    
    func getAllWallets() {
        self.loading.onNext(true)
        API.Wallet.gettAllWallets().request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let sum = returnJson?["summ"] as? Double {
                        self.sum = sum
                    }
                    if let wallets = returnJson?["wallets"] as? [[String: Any]], let model = wallets.parse(to: [WalletModel].self) {
                        self.wallets = model
                    }
                    self.getWallets.onNext(true)
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func getAllTransactions() {
        self.loading.onNext(true)
        API.Transaction.gettAllWalletsTransactions().request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let transactionsArray = returnJson?["transactionsArray"] as? [[[String: Any]]], let model = transactionsArray.parse(to: [[TransactionModel]].self) {
                        self.transactions = model
                        self.getTransactions.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func createCard(name: String, currency: String) {
        API.Wallet.createWallet(name: name, type: "bank", balance: 0, currency: currency).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    self.allUpdate()
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func createCash(name: String, currency: String) {
        API.Wallet.createWallet(name: name, type: "cash", balance: 0, currency: currency).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    self.allUpdate()
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func allUpdate() {
        getAllWallets()
        getAllTransactions()
    }
    
    func convertTransactions() -> [([(Date, Double)], UIColor)] {
        guard let transactions = transactions, let wallets = wallets else {
            return []
        }
        
        let walletColors: [String: UIColor] = wallets.reduce(into: [:]) { result, wallet in
            if let id = wallet._id, let colorHex = wallet.color {
                result[id] = UIColor(hex: colorHex)
            }
        }
        
        var result: [([(Date, Double)], UIColor)] = []
        
        for group in transactions {
            guard !group.isEmpty else { continue }
            
            if let walletFromId = group.first?.walletFromId,
               let color = walletColors[walletFromId] {
                let dateAmountArray: [(Date, Double)] = group.compactMap { transaction in
                    guard let date = transaction.date, let amount = transaction.type == "income" ? transaction.amount : -(transaction.amount ?? 0.0) else {
                        return nil
                    }
                    return (date, amount)
                }
                result.append((dateAmountArray, color))
            }
        }
        
        return result
    }
}
