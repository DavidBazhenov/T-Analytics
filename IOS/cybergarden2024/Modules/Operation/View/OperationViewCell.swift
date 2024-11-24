//
//  OperationViewCell.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints

class OperationViewCell: UICollectionViewCell {
    
    private let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 3)
    private let nextStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 3)
    private let titleLogo = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interSemiBold(ofSize: 30))
    private let titleName = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interSemiBold(ofSize: 14))
    private let titlePrice = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interSemiBold(ofSize: 14), alignment: .right)
    private let titleWalletName = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interSemiBold(ofSize: 11), alignment: .right)
    private let titleWallet = ViewsFactory.defaultLabel(textColor: .hex8B9AA2, font: .interSemiBold(ofSize: 11))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupViews()
        setupLayout()
    }
    
    private func setupLayout() {
        [titleLogo, mainStackView, nextStackView].forEach { addSubview($0) }
        mainStackView.addArrangedSubview(titleName)
        mainStackView.addArrangedSubview(titleWallet)
        nextStackView.addArrangedSubview(titlePrice)
        nextStackView.addArrangedSubview(titleWalletName)
        
        titleLogo.leftToSuperview(offset: 10)
        titleLogo.centerYToSuperview()
        nextStackView.centerYToSuperview()
        nextStackView.rightToSuperview(offset: -10)
        mainStackView.leftToRight(of: titleLogo, offset: 10)
        mainStackView.centerYToSuperview()
    }
    
    private func setupViews() {
        backgroundColor = .appClear
    }
    
    func update(transaction: TransactionModel, walletName: String?) {
        titleLogo.text = transaction.category?.icon ?? ""
        titleName.text = transaction.description ?? ""
        titleWallet.text = transaction.category?.name ?? ""
        titleWalletName.text = walletName ?? ""
        titlePrice.text = String(format: "%.0f", transaction.amount ?? 0.0)
        titlePrice.text = "\(transaction.type == "income" ? "+" : "-")\(titlePrice.text ?? "") ₽"
    }
}
