//
//  ViewModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import RxSwift

class ViewModel {
    public var error: PublishSubject<String?> = PublishSubject()
    public var loading: PublishSubject<Bool> = PublishSubject()
    public var disposeBag = DisposeBag()
}
