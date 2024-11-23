//
//  EditProfileViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class EditProfileViewModel: ViewModel {
    
    public var userUpdate: PublishSubject<Bool> = PublishSubject()
    
    func updateData(name: String, email: String, phone: String) {
        self.loading.onNext(true)
        API.Users.putMe(name: name, email: email, phone: phone).request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let data = returnJson, let model = data.parse(to: ProfileModel.self) {
                        self.userUpdate.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
}
