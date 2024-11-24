//
//  CreateOperationView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class CreateOperationView: UIView {

    private let disposeBag = DisposeBag()
    public var addOperation: PublishSubject<Bool> = PublishSubject()
    public var alerts: PublishSubject<String> = PublishSubject()
    private var wallets: [WalletModel] = []
    private var categories: [TransactionModel.Category] = []
    private var isExpense = true

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ^String.General.addOperationsTitle
        label.textColor = .hexECF1F7
        label.font = .interMedium(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .hexFEDE34
        label.textAlignment = .center
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.width(48)
        label.height(48)
        return label
    }()

    private let switchLabel: UILabel = {
        let label = UILabel()
        label.text = "Расход"
        label.textColor = .white
        label.font = .interRegular(ofSize: 16)
        return label
    }()

    private let switchView: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .hexFEDE34
        return switchControl
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ^String.General.descriptionPlaceholder
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.hex1D1D1D.cgColor
        textField.layer.cornerRadius = 12
        textField.setLeftPadding(12)
        textField.attributedPlaceholder = NSAttributedString(
            string: ^String.General.descriptionPlaceholder,
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return textField
    }()

    private let categoryPicker: UISegmentedControl = {
        let picker = UISegmentedControl()
        picker.backgroundColor = .hex1D1D1D
        picker.selectedSegmentTintColor = .hexFEDE34
        picker.tintColor = .hex1D1D1D
        picker.layer.cornerRadius = 12
        return picker
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ^String.General.amountPlaceholder
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.font = .interRegular(ofSize: 16)
        textField.height(48)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.hex1D1D1D.cgColor
        textField.layer.cornerRadius = 12
        textField.setLeftPadding(12)
        textField.keyboardType = .decimalPad
        textField.attributedPlaceholder = NSAttributedString(
            string: ^String.General.amountPlaceholder,
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return textField
    }()

    private let walletPicker: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(^String.General.selectWalletTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .hex2E2F34
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.hex1D1D1D.cgColor
        button.layer.cornerRadius = 12
        button.height(48)
        return button
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.backgroundColor = .appClear
        return picker
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle(^String.General.addButtonTitle, for: .normal)
        button.setTitleColor(.appBlack, for: .normal)
        button.titleLabel?.font = .interRegular(ofSize: 16)
        button.backgroundColor = .hexFEDE34
        button.layer.cornerRadius = 12
        button.height(48)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        setupActions()
        loadCategories()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .hex2E2F34
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(descriptionTextField)
        addSubview(switchLabel)
        addSubview(switchView)
        addSubview(categoryPicker)
        addSubview(amountTextField)
        addSubview(walletPicker)
        addSubview(datePicker)
        addSubview(addButton)
    }

    private func setupLayout() {
        titleLabel.topToSuperview(offset: 20, usingSafeArea: true)
        titleLabel.horizontalToSuperview(insets: .horizontal(16))

        categoryLabel.topToBottom(of: titleLabel, offset: 20)
        categoryLabel.leftToSuperview(offset: 16)

        descriptionTextField.centerY(to: categoryLabel)
        descriptionTextField.leftToRight(of: categoryLabel, offset: 16)
        descriptionTextField.rightToSuperview(offset: -16)

        switchLabel.topToBottom(of: categoryLabel, offset: 20)
        switchLabel.leftToSuperview(offset: 16)

        switchView.centerY(to: switchLabel)
        switchView.leftToRight(of: switchLabel, offset: 8)

        categoryPicker.topToBottom(of: switchLabel, offset: 20)
        categoryPicker.horizontalToSuperview(insets: .horizontal(16))

        amountTextField.topToBottom(of: categoryPicker, offset: 20)
        amountTextField.horizontalToSuperview(insets: .horizontal(16))

        walletPicker.topToBottom(of: amountTextField, offset: 20)
        walletPicker.horizontalToSuperview(insets: .horizontal(16))

        datePicker.topToBottom(of: walletPicker, offset: 20)
        datePicker.centerXToSuperview()

        addButton.horizontalToSuperview(insets: .horizontal(16))
        addButton.bottomToSuperview(offset: -20, usingSafeArea: true)
    }

    private func setupActions() {
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        addButton.addTarget(self, action: #selector(addOperationTapped), for: .touchUpInside)
        walletPicker.addTarget(self, action: #selector(walletPickerTapped), for: .touchUpInside)
        categoryPicker.addTarget(self, action: #selector(updateCategoryIcon), for: .valueChanged)
    }

    @objc private func switchChanged() {
        isExpense = !switchView.isOn
        switchLabel.text = isExpense ? "Расход" : "Доход"
        loadCategories()
    }

    @objc private func walletPickerTapped() {
        guard !wallets.isEmpty else { return }

        let alertController = UIAlertController(title: ^String.General.selectWalletTitle, message: nil, preferredStyle: .actionSheet)
        
        for (index, wallet) in wallets.enumerated() {
            let action = UIAlertAction(title: wallet.name, style: .default) { [weak self] _ in
                self?.walletPicker.setTitle(wallet.name, for: .normal)
                self?.walletPicker.tag = index
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: ^String.General.cancelButtonTitle, style: .cancel))

        if let topController = getTopMostViewController() {
            topController.present(alertController, animated: true)
        }
    }
    
    private func getTopMostViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    private func loadCategories() {
        categories = CategoryHelper.getCategories(for: isExpense ? "expense" : "income")
        categoryPicker.removeAllSegments()
        for (index, category) in categories.enumerated() {
            categoryPicker.insertSegment(withTitle: category.name, at: index, animated: false)
        }
        categoryPicker.selectedSegmentIndex = 0
        updateCategoryIcon()
    }

    @objc private func updateCategoryIcon() {
        guard categoryPicker.selectedSegmentIndex >= 0 else { return }
        let selectedCategory = categories[categoryPicker.selectedSegmentIndex]
        categoryLabel.text = selectedCategory.icon
    }

    @objc private func addOperationTapped() {
        if let operationData = validateAndReturnData() {
            addOperation.onNext(true)
        }
    }

    func validateAndReturnData() -> (walletFromId: String, amount: Float, type: String, date: String, description: String, category: TransactionModel.Category)? {
        guard let description = descriptionTextField.text, !description.isEmpty else {
            alerts.onNext(^String.General.descriptionEmptyError)
            return nil
        }
        guard let amountText = amountTextField.text, let amount = Float(amountText), amount > 0, amount == floor(amount) else {
            alerts.onNext(^String.General.amountPositiveError)
            return nil
        }
        guard wallets.indices.contains(walletPicker.tag) else {
            alerts.onNext(^String.General.selectWalletTitle)
            return nil
        }
        guard categoryPicker.selectedSegmentIndex >= 0 else {
            alerts.onNext(^String.General.selectCategoryError)
            return nil
        }
        let walletFromId = wallets[walletPicker.tag]._id ?? ""
        let type = isExpense ? "expense" : "income"
        let date = ISO8601DateFormatter().string(from: datePicker.date)
        let selectedCategory = categories[categoryPicker.selectedSegmentIndex]
        return (walletFromId, amount, type, date, description, selectedCategory)
    }

    func updateWallets(_ wallets: [WalletModel]) {
        self.wallets = wallets
        walletPicker.tag = 0
        walletPicker.setTitle(wallets.first?.name ?? ^String.General.selectWalletTitle, for: .normal)
    }
}
