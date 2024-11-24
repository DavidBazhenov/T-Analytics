//
//  EditProfileView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class EditProfileView: UIView, UITextFieldDelegate {
    
    private let disposeBag = DisposeBag()
    public var saveUser: PublishSubject<(fio: String, email: String, number: String)> = PublishSubject()
    public var alert: PublishSubject<String> = PublishSubject()
    public var back: PublishSubject<Bool> = PublishSubject()
    
    private let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5)
    
    private let mainLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 24))
    private let nameTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let emailTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let phoneTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let backTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .hexECF1F7
        textField.layer.cornerRadius = 10
        textField.textColor = .appBlack
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.setLeftPadding(12)
        textField.setRightPadding(12)
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .hexECF1F7
        textField.layer.cornerRadius = 10
        textField.textColor = .appBlack
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.keyboardType = .emailAddress
        textField.setLeftPadding(12)
        textField.setRightPadding(12)
        return textField
    }()
    
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
        phoneTextField.delegate = self
    }
    
    private func setupTitle() {
        mainLabel.text = ^String.Profile.profileEditMainTitle
        emailTitleLabel.text = ^String.Auth.authEmailTitle
        phoneTitleLabel.text = ^String.Auth.authPhoneTitle
        nameTitleLabel.text = ^String.Auth.authNameTitle
        backTitleLabel.text = ^String.Profile.profileBackTitle
        continueButton.setTitle(^String.Profile.profileSaveTitle, for: .normal)
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        
        backTitleLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backTitleLabel.addGestureRecognizer(gestureRecognizer)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayouts() {
        addSubview(mainStackView)
        addSubview(mainLabel)
        addSubview(continueButton)
        addSubview(backTitleLabel)
        
        mainLabel.topToSuperview(offset: 18, usingSafeArea: true)
        mainLabel.centerXToSuperview()
        
        mainStackView.topToBottom(of: mainLabel, offset: 100)
        mainStackView.horizontalToSuperview(insets: .horizontal(30))
        
        [nameTitleLabel, nameTextField, emailTitleLabel, emailTextField, phoneTitleLabel, phoneTextField].forEach {
            mainStackView.addArrangedSubview($0)
        }
        mainStackView.setCustomSpacing(20, after: nameTextField)
        mainStackView.setCustomSpacing(20, after: emailTextField)
        
        continueButton.topToBottom(of: mainStackView, offset: 80)
        continueButton.horizontalToSuperview(insets: .horizontal(30))
        backTitleLabel.topToBottom(of: continueButton, offset: 20)
        backTitleLabel.centerXToSuperview()
    }
    
    @objc private func continueButtonTapped() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !name.isEmpty else {
            alert.onNext("Имя не может быть пустым")
            return
        }
        
        guard isValidEmail(email) else {
            alert.onNext("Неверный формат электронной почты")
            return
        }
        
        guard isValidPhone(phone) else {
            alert.onNext("Неверный формат номера телефона")
            return
        }
        
        saveUser.onNext((fio: name, email: email, number: phone))
    }
    
    @objc private func backButtonTapped() {
        back.onNext(true)
    }
    
    func update(model: ProfileModel) {
        nameTextField.text = model.name ?? ""
        emailTextField.text = model.email ?? ""
        phoneTextField.text = model.phone ?? ""
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "\\+7 \\d{3} \\d{3} \\d{2}-\\d{2}"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
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
