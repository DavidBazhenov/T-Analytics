//
//  OperationHeaderView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints

class OperationHeaderView: UICollectionReusableView {
    
    private let dateLabel = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interRegular(ofSize: 16))
    private let totalAmountLabel = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interRegular(ofSize: 16), alignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(dateLabel)
        addSubview(totalAmountLabel)
        
        dateLabel.leftToSuperview(offset: 15)
        dateLabel.bottomToSuperview(offset: 0)
        
        totalAmountLabel.rightToSuperview(offset: -10)
        totalAmountLabel.bottomToSuperview(offset: 0)
    }
    
    func update(date: Date, totalAmount: Double) {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateLabel.text = "Сегодня"
        } else if calendar.isDateInYesterday(date) {
            dateLabel.text = "Вчера"
        } else {
            formatter.dateFormat = "dd MMMM yyyy"
            dateLabel.text = formatter.string(from: date)
        }
        
        dateLabel.textColor = .hex99AAB2
        
        totalAmountLabel.text = String(format: "%.0f ₽", totalAmount)
        totalAmountLabel.textColor = .hex99AAB2
    }
    
    func update(title: String, totalAmount: Double) {
        dateLabel.text = title
        totalAmountLabel.text = String(format: "%.0f ₽", totalAmount)
        totalAmountLabel.textColor = .hex99AAB2
    }
}
