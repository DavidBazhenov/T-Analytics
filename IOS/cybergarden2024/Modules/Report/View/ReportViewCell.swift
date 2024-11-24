//
//  ReportViewCell.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import TinyConstraints

class ReportViewCell: UICollectionViewCell {
    
    private let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 3)
    private let titleLogo = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interSemiBold(ofSize: 30))
    private let titleName = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interSemiBold(ofSize: 14))
    private let titlePrice = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interSemiBold(ofSize: 14), alignment: .right)
    private let titleCount = ViewsFactory.defaultLabel(textColor: .hex8B9AA2, font: .interSemiBold(ofSize: 11))
    
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
        [titleLogo, mainStackView, titlePrice].forEach { addSubview($0) }
        mainStackView.addArrangedSubview(titleName)
        mainStackView.addArrangedSubview(titleCount)
        
        titleLogo.leftToSuperview(offset: 10)
        titleLogo.centerYToSuperview()
        titlePrice.centerYToSuperview()
        titlePrice.rightToSuperview(offset: -10)
        mainStackView.leftToRight(of: titleLogo, offset: 10)
        mainStackView.centerYToSuperview()
    }
    
    private func setupViews() {
        backgroundColor = .appClear
    }

    private func pluralize(_ count: Int, singular: String, few: String, many: String) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder100 >= 11 && remainder100 <= 19 {
            return many
        }
        
        switch remainder10 {
        case 1:
            return singular
        case 2...4:
            return few
        default:
            return many
        }
    }
    
    func update(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool) {
        titleLogo.text = category.icon ?? ""
        titleName.text = category.name ?? ""
        titleCount.text = "\(count) \(pluralize(count, singular: "Операция", few: ^String.General.operationsTitle, many: "Операций"))"
        titlePrice.text = String(format: "%.0f", price)
        titlePrice.text = "\(isIncome ? "+" : "-")\(titlePrice.text ?? "") ₽"
    }
}
