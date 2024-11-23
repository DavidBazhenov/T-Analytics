//
//  AuthorizationView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class AuthorizationView: UIView {
    
    enum Action {
        case googleTapped
        case tbankTapped
        case privacyTapped
        case tosTapped
        case alert(error: String)
        case exitTapped(email: String, password: String)
        case regTapped(name: String, email: String, password: String)
    }
    
    private let disposeBag = DisposeBag()
    
    public var actions: PublishSubject<Action> = PublishSubject()
    
    var isLogin: Bool = true {
        didSet {
            updateLayoutForMode()
        }
    }
    
    private var headerTopConstraint: Constraint?
    private var inputFieldTopConstraint: Constraint?
    
    private let buttonsStackView: UIStackView = ViewsFactory.defaultStackView(axis: .horizontal, spacing: 20)
    private let headerStackView: UIStackView = ViewsFactory.defaultStackView(axis: .horizontal, spacing: 8)
    
    let inputFieldView = AuthorizationInputView()
    
    private let dividerViewFirst: UIView = {
        let view = UIView()
        view.backgroundColor = .hexECF1F7
        view.height(1)
        return view
    }()
    
    private let dividerViewSecond: UIView = {
        let view = UIView()
        view.backgroundColor = .hexECF1F7
        view.height(1)
        return view
    }()
    
    private let mainLogoLabel = ViewsFactory.defaultLabel(textColor: .appWhite, font: .interMedium(ofSize: 32))
    private let mainLogoImageView = ViewsFactory.defaultImageView(contentMode: .scaleAspectFit, image: AppImage.tbankLogo.uiImage)
    private let quickAccessTitleLabel = ViewsFactory.defaultLabel(textColor: .appWhite, font: .interRegular(ofSize: 12))
    private let tosAndprivacyTitleLabel = ViewsFactory.defaultLabel(lines: 4, alignment: .center)
    private let haveAccountTitleLabel = ViewsFactory.defaultLabel()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.appBlack, for: .normal)
        button.titleLabel?.font = .interMedium(ofSize: 16)
        button.backgroundColor = .hexFEDE34
        button.layer.cornerRadius = 10
        button.height(48)
        return button
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton()
        button.setTitle(^String.Auth.authGoogleTitle, for: .normal)
        button.setTitleColor(.appBlack, for: .normal)
        button.titleLabel?.font = .interMedium(ofSize: 16)
        button.backgroundColor = .appWhite
        button.layer.cornerRadius = 10
        button.height(48)
        button.setImage(AppImage.googleLogo.uiImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        return button
    }()
    
    private let tbankButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appWhite
        button.layer.cornerRadius = 10
        button.height(48)
        button.setImage(AppImage.tbankButtonLogo.uiImage, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupTitle()
        setupBindings()
        setupViews()
        setupLayouts()
    }
    
    private func setupBindings() {
        inputFieldView.alert.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.actions.onNext(.alert(error: error))
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTitle() {
        mainLogoLabel.text = ^String.Auth.authLogoTitle
        quickAccessTitleLabel.text = ^String.Auth.authFastAccessTitle
        continueButton.setTitle(!isLogin ? ^String.Auth.authExitWordTitle : ^String.Auth.authRegistrationWordTitle, for: .normal)
        
        let fullText = ^String.Auth.authTosAndPrivacyTitle
        let tosText = ^String.Auth.authTosTitle
        let privacyText = ^String.Auth.authPrivacyTitle
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttributes([
            .font: UIFont.interRegular(ofSize: 12),
            .foregroundColor: UIColor.hexECF1F7
        ], range: NSRange(location: 0, length: fullText.count))
        
        if let tosRange = fullText.range(of: tosText) {
            let nsRange = NSRange(tosRange, in: fullText)
            attributedString.addAttributes([
                .font: UIFont.interRegular(ofSize: 12),
                .foregroundColor: UIColor.hex22587C,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        
        if let privacyRange = fullText.range(of: privacyText) {
            let nsRange = NSRange(privacyRange, in: fullText)
            attributedString.addAttributes([
                .font: UIFont.interRegular(ofSize: 12),
                .foregroundColor: UIColor.hex22587C,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        
        tosAndprivacyTitleLabel.attributedText = attributedString
        tosAndprivacyTitleLabel.isUserInteractionEnabled = true
        
        let tosTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTosAndPrivacyTap(_:)))
        tosAndprivacyTitleLabel.addGestureRecognizer(tosTapGesture)
        
        let haveAccountFullText = isLogin ? ^String.Auth.authExitTitle : ^String.Auth.authRegistrationTitle
        let haveAccountWordText = isLogin ? ^String.Auth.authExitWordTitle : ^String.Auth.authRegistrationWordTitle
        
        let haveAccountAttributedString = NSMutableAttributedString(string: haveAccountFullText)
        
        haveAccountAttributedString.addAttributes([
            .font: UIFont.interMedium(ofSize: 16),
            .foregroundColor: UIColor.hexECF1F7
        ], range: NSRange(location: 0, length: haveAccountFullText.count))
        
        if let wordRange = haveAccountFullText.range(of: haveAccountWordText) {
            let nsRange = NSRange(wordRange, in: haveAccountFullText)
            haveAccountAttributedString.addAttributes([
                .font: UIFont.interMedium(ofSize: 16),
                .foregroundColor: UIColor.hex22587C,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        
        haveAccountTitleLabel.attributedText = haveAccountAttributedString
        haveAccountTitleLabel.isUserInteractionEnabled = true
        
        let haveAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHaveAccountTap(_:)))
        haveAccountTitleLabel.addGestureRecognizer(haveAccountTapGesture)
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        buttonsStackView.distribution = .fillEqually
        
        googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        tbankButton.addTarget(self, action: #selector(tbankTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    private func setupLayouts() {
        [googleButton, tbankButton].forEach(buttonsStackView.addArrangedSubview)
        [mainLogoImageView, mainLogoLabel].forEach(headerStackView.addArrangedSubview)
        [headerStackView, inputFieldView, dividerViewFirst, quickAccessTitleLabel, dividerViewSecond, continueButton, buttonsStackView, haveAccountTitleLabel, tosAndprivacyTitleLabel].forEach(addSubview)
        
        headerTopConstraint = headerStackView.topToSuperview(offset: isLogin ? 37 : 0, usingSafeArea: true)
        headerStackView.centerXToSuperview()
        
        inputFieldTopConstraint = inputFieldView.topToBottom(of: headerStackView, offset: isLogin ? 46 : 14)
        inputFieldView.horizontalToSuperview(insets: .horizontal(32))
        
        continueButton.topToBottom(of: inputFieldView, offset: 30)
        continueButton.horizontalToSuperview(insets: .horizontal(32))
        
        quickAccessTitleLabel.topToBottom(of: continueButton, offset: 30)
        dividerViewFirst.centerY(to: quickAccessTitleLabel)
        dividerViewSecond.centerY(to: quickAccessTitleLabel)
        dividerViewFirst.leftToSuperview(offset: 32)
        dividerViewSecond.rightToSuperview(offset: -32)
        
        quickAccessTitleLabel.centerXToSuperview()
        dividerViewSecond.leftToRight(of: quickAccessTitleLabel, offset: 20)
        dividerViewFirst.rightToLeft(of: quickAccessTitleLabel, offset: -20)
        
        buttonsStackView.topToBottom(of: quickAccessTitleLabel, offset: 30)
        buttonsStackView.horizontalToSuperview(insets: .horizontal(32))
        
        haveAccountTitleLabel.topToBottom(of: buttonsStackView, offset: 38)
        haveAccountTitleLabel.centerXToSuperview()
        
        tosAndprivacyTitleLabel.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 32, bottom: 76, right: 32))
    }
    
    private func updateLayoutForMode() {
        headerTopConstraint?.constant = isLogin ? 37 : 0
        inputFieldTopConstraint?.constant = isLogin ? 46 : 14
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        inputFieldView.swapStatus(isLogin: isLogin)
        setupTitle()
    }
    
    @objc private func continueTapped() {
        if inputFieldView.isValidInfo() {
            if isLogin {
                let info = inputFieldView.getLoginInfo()
                actions.onNext(.exitTapped(email: info.email, password: info.password))
            } else {
                let info = inputFieldView.getRegistrationInfo()
                actions.onNext(.regTapped(name: info.name, email: info.email, password: info.password))
            }
        }
    }
    
    @objc private func tbankTapped() {
        actions.onNext(.tbankTapped)
    }
    
    @objc private func googleTapped() {
        actions.onNext(.googleTapped)
    }
    
    @objc private func handleHaveAccountTap(_ gesture: UITapGestureRecognizer) {
        isLogin.toggle()
    }
    
    @objc private func handleTosAndPrivacyTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let text = label.attributedText?.string else { return }
        
        let tosText = ^String.Auth.authTosTitle
        let privacyText = ^String.Auth.authPrivacyTitle
        
        let tapLocation = gesture.location(in: label)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if let tosRange = text.range(of: tosText), NSRange(tosRange, in: text).contains(index) {
            actions.onNext(.tosTapped)
        } else if let privacyRange = text.range(of: privacyText), NSRange(privacyRange, in: text).contains(index) {
            actions.onNext(.privacyTapped)
        }
    }
    
}
