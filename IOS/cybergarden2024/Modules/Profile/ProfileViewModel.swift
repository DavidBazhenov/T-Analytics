//
//  ProfileViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class ProfileViewModel: ViewModel {
    
    public var userLoad: PublishSubject<Bool> = PublishSubject()
    
    var profileData: ProfileModel?
    
    override init() {
        super.init()
        initProfileData()
    }
    
    func initProfileData() {
        self.loading.onNext(true)
        API.Users.getMe().request()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case .success(let returnJson):
                    if let data = returnJson, let model = data.parse(to: ProfileModel.self) {
                        self.profileData = model
                        self.userLoad.onNext(true)
                    }
                case .failure(let error) :
                    self.error.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
    }
    
}
