//
//  TIDAuthorizationView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class TIDAuthorizationView: UIView, UITextFieldDelegate {
    
    enum Actions {
        case back
        case login(phone: String)
        case alert(error: String)
    }
    
    private let disposeBag = DisposeBag()
    
    public var action: PublishSubject<Actions> = PublishSubject()
    
    private let headerStackView: UIStackView = ViewsFactory.defaultStackView(axis: .horizontal, spacing: 8)
    
    private let mainLogoLabel = ViewsFactory.defaultLabel(textColor: .appWhite, font: .interMedium(ofSize: 32))
    private let titleLogoLabel = ViewsFactory.defaultLabel(textColor: .appWhite, font: .interMedium(ofSize: 24))
    private let mainLogoImageView = ViewsFactory.defaultImageView(contentMode: .scaleAspectFit, image: AppImage.tbankLogo.uiImage)
    private let phoneTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let backTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .hexECF1F7
        textField.layer.cornerRadius = 10
        textField.textColor = .appBlack
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.keyboardType = .numberPad
        textField.setLeftPadding(12)
        textField.setRightPadding(12)
        textField.text = "+7 "
        return textField
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.appBlack, for: .normal)
        button.titleLabel?.font = .interMedium(ofSize: 16)
        button.backgroundColor = .hexFEDE34
        button.layer.cornerRadius = 10
        button.height(48)
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
        setupViews()
        setupLayouts()
    }
    
    private func setupTitle() {
        mainLogoLabel.text = ^String.Auth.authLogoTitle
        phoneTitleLabel.text = ^String.Auth.authPhoneTitle
        backTitleLabel.text = ^String.Profile.profileBackTitle
        titleLogoLabel.text = ^String.Auth.authExitByTIDTitle
        continueButton.setTitle(^String.Auth.authContinueTitle, for: .normal)
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        
        backTitleLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backTitleLabel.addGestureRecognizer(gestureRecognizer)
        
        phoneTextField.delegate = self
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayouts() {
        [mainLogoImageView, mainLogoLabel].forEach(headerStackView.addArrangedSubview)
        [headerStackView, titleLogoLabel, phoneTitleLabel, phoneTextField, continueButton, backTitleLabel].forEach(addSubview)
        
        headerStackView.topToSuperview(offset: 37, usingSafeArea: true)
        headerStackView.centerXToSuperview()
        
        titleLogoLabel.topToBottom(of: headerStackView, offset: 70)
        titleLogoLabel.centerXToSuperview()
        
        phoneTitleLabel.topToBottom(of: titleLogoLabel, offset: 40)
        phoneTitleLabel.leftToSuperview(offset: 30)
        
        phoneTextField.topToBottom(of: phoneTitleLabel, offset: 15)
        phoneTextField.horizontalToSuperview(insets: .horizontal(30))
        
        continueButton.topToBottom(of: phoneTextField, offset: 30)
        continueButton.horizontalToSuperview(insets: .horizontal(30))
        
        backTitleLabel.topToBottom(of: continueButton, offset: 30)
        backTitleLabel.centerXToSuperview()
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "\\+7 \\d{3} \\d{3} \\d{2}-\\d{2}"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    @objc private func continueTapped() {
        
    }
    
    @objc private func continueButtonTapped() {
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard isValidPhone(phone) else {
            action.onNext(.alert(error: ^String.General.invalidPhoneError))
            return
        }
        
        action.onNext(.login(phone: phone))
    }
    
    @objc private func backButtonTapped() {
        action.onNext(.back)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneTextField else { return true }
        
        let currentText = textField.text ?? ""
        let nsString = currentText as NSString
        let updatedText = nsString.replacingCharacters(in: range, with: string)
        
        let digits = updatedText.filter { $0.isNumber }
        
        if digits.isEmpty {
            textField.text = "+7 "
            return false
        }
        
        let limitedDigits = String(digits.prefix(11))
        textField.text = formatPhoneNumber(limitedDigits)
        return false
    }

    private func formatPhoneNumber(_ digits: String) -> String {
        var result = "+7"
        
        if digits.count > 1 {
            let mainPart = digits.dropFirst(1) // Пропускаем "+7"
            if mainPart.count > 0 {
                result += " " + mainPart.prefix(3)
            }
            if mainPart.count > 3 {
                result += " " + mainPart.dropFirst(3).prefix(3)
            }
            if mainPart.count > 6 {
                let lastPart = mainPart.dropFirst(6)
                if lastPart.count > 2 {
                    let splitIndex = lastPart.index(lastPart.startIndex, offsetBy: 2)
                    let part1 = lastPart[..<splitIndex]
                    let part2 = lastPart[splitIndex...]
                    result += " \(part1)-\(part2)"
                } else {
                    result += " \(lastPart)"
                }
            }
        }
        
        return result
    }
    
}
