//
//  AuthorizationInputView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class AuthorizationInputView: UIView {
    
    public var alert: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 15)
    
    private let nameTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let emailTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let passwordTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let errorTitleLabel = ViewsFactory.defaultLabel(textColor: .appSystemRed, font: .interMedium(ofSize: 12))
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .hexECF1F7
        textField.layer.cornerRadius = 10
        textField.textColor = .appBlack
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.placeholder = "Имя Фамилия"
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
        textField.placeholder = "Почта"
        textField.setLeftPadding(12)
        textField.setRightPadding(12)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .hexECF1F7
        textField.layer.cornerRadius = 10
        textField.textColor = .appBlack
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.setLeftPadding(12)
        textField.setRightPadding(58)
        return textField
    }()
    
    private let passwordVisibilityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(AppImage.eyeClose.uiImage, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        button.width(48)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func commonInit() {
        setupViews()
        setupLayouts()
        setupBindings()
        validateFields()
        swapStatus(isLogin: true)
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        passwordVisibilityButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let rightViewContainer = UIView()
        rightViewContainer.addSubview(passwordVisibilityButton)
        passwordVisibilityButton.edgesToSuperview(excluding: .left)
        rightViewContainer.width(44)
        
        passwordTextField.rightView = rightViewContainer
        passwordTextField.rightViewMode = .always
        
        emailTitleLabel.text = ^String.Auth.authEmailTitle
        passwordTitleLabel.text = ^String.Auth.authPasswordTitle
        errorTitleLabel.text = ^String.Auth.authErrorLoginOrPasswordTitle
        nameTitleLabel.text = ^String.Auth.authNameTitle
        
        errorTitleLabel.isHidden = true
    }
    
    private func setupLayouts() {
        addSubview(mainStackView)
        mainStackView.edgesToSuperview()
        
        [nameTitleLabel, nameTextField, emailTitleLabel, emailTextField, passwordTitleLabel, passwordTextField, errorTitleLabel].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func setupBindings() {
        [nameTextField, emailTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
    }
    
    // MARK: - Actions
    @objc private func validateFields() {
        badInfo(isActive: false)
    }
    
    func isValidInfo() -> Bool {
        UserDefaultsHelper.shared.removeToken()
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        
        if !nameTitleLabel.isHidden && nameText.isEmpty {
            alert.onNext("Имя не может быть пустым")
            return false
        }
        
        if emailText.isEmpty || !isValidEmail(emailText) {
            alert.onNext("Неверный формат электронной почты")
            return false
        }
        
        if passwordText.isEmpty {
            alert.onNext("Пароль не может быть пустым")
            return false
        }
        return true
    }
    
    func badInfo(isActive: Bool) {
        passwordTextField.layer.borderWidth = isActive ? 1 : 0
        emailTextField.layer.borderWidth = isActive ? 1 : 0
        passwordTextField.layer.borderColor = UIColor.appSystemRed.cgColor
        emailTextField.layer.borderColor = UIColor.appSystemRed.cgColor
        errorTitleLabel.isHidden = !isActive
    }
    
    func getRegistrationInfo() -> (name: String, email: String, password: String) {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        return (name, email, password)
    }
    
    func getLoginInfo() -> (email: String, password: String) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        return (email, password)
    }
    
    func swapStatus(isLogin: Bool) {
        nameTitleLabel.isHidden = isLogin
        nameTextField.isHidden = isLogin
        validateFields()
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let image = passwordTextField.isSecureTextEntry ? AppImage.eyeClose.uiImage : AppImage.eyeOpen.uiImage
        passwordVisibilityButton.setImage(image, for: .normal)
    }
}

// MARK: - Utility Extensions
extension UITextField {
    
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
