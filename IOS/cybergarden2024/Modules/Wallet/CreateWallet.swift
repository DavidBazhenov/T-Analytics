//
//  CreateWallet.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints

class CreateWallet: ViewController {
    
    var createCard: ((String, String) -> Void)?
    var createCash: ((String, String) -> Void)?
    
    private let nameTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interRegular(ofSize: 16))
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя кошелька"
        textField.borderStyle = .none
        textField.backgroundColor = .hexECF1F7
        textField.textColor = .black
        textField.font = .interRegular(ofSize: 16)
        textField.layer.cornerRadius = 12
        textField.height(48)
        textField.setLeftPadding(12)
        textField.setRightPadding(12)
        return textField
    }()
    
    private let currencyPicker: UISegmentedControl = {
        let items = ["RUB", "USD", "EUR", "GBP"]
        let picker = UISegmentedControl(items: items)
        picker.selectedSegmentIndex = 0
        picker.backgroundColor = .hexECF1F7
        picker.selectedSegmentTintColor = .hexFEDE34
        picker.tintColor = .black
        picker.layer.cornerRadius = 12
        return picker
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.appBlack, for: .normal)
        button.titleLabel?.font = .interRegular(ofSize: 16)
        button.backgroundColor = .hexFEDE34
        button.layer.cornerRadius = 12
        button.height(48)
        return button
    }()
        
    private var isCashMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        setupKeyboardDismissRecognizer()
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
        setupActions()
    }
    
    private func setupViews() {
        nameTitleLabel.text = "Имя кошелька"
        view.backgroundColor = .hex2E2F34
        view.addSubview(nameTextField)
        view.addSubview(currencyPicker)
        view.addSubview(continueButton)
        view.addSubview(nameTitleLabel)
    }
    
    private func setupLayout() {
        
        
        nameTitleLabel.topToSuperview(offset: 20, usingSafeArea: true)
        nameTitleLabel.leftToSuperview(offset: 16)
        
        nameTextField.topToBottom(of: nameTitleLabel, offset: 5)
        nameTextField.horizontalToSuperview(insets: .horizontal(16))
        
        currencyPicker.topToBottom(of: nameTextField, offset: 20)
        currencyPicker.horizontalToSuperview(insets: .horizontal(16))
        
        continueButton.horizontalToSuperview(insets: .uniform(15))
        continueButton.bottomToSuperview(offset: -20, usingSafeArea: true)
    }
    
    private func setupActions() {
        currencyPicker.addTarget(self, action: #selector(currencyChanged), for: .valueChanged)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func currencyChanged() {
        // Логика изменения валюты (если требуется)
    }
    
    @objc private func continueButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let currency = currencyPicker.titleForSegment(at: currencyPicker.selectedSegmentIndex) ?? "RUB"
        
        if isCashMode {
            createCash?(name, currency)
        } else {
            createCard?(name, currency)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateMode(isCash: Bool) {
        isCashMode = isCash
        nameTextField.text = ""
        currencyPicker.selectedSegmentIndex = 0
    }
    
    private func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
