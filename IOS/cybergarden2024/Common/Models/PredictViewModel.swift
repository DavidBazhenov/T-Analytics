//
//  PredictViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import RxSwift

class PredictViewModel: ViewModel {
    
    public var loadPredict: PublishSubject<Bool> = PublishSubject()
    
    var predicts: [PredictModel]?
    
    func getPredictTransactions() {
        self.loading.onNext(true)
        API.Transaction.getPredictTransactions().request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let data = returnJson?["data"] as? [[String : Any]], let model = data.parse(to: [PredictModel].self) {
                        self.predicts = model
                        self.loadPredict.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
}

