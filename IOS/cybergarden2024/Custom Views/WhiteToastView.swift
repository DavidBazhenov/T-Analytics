//
//  WhiteToastView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

class WhiteToastView: UIView {
    
    private var horizontalInset: CGFloat = 18
    let viewHeight: CGFloat = 45
    
    private let titleLabel = ViewsFactory.defaultLabel(
        textColor: .appBlack,
        font: .sFProTextSemibold(ofSize: 11),
        alignment: .center
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
        updateFrame()
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        backgroundColor = .appWhite
        layer.cornerRadius = viewHeight / 2
        
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.appBlack.withAlphaComponent(0.15).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 74
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
    }
    
    private func updateFrame() {
        titleLabel.sizeToFit()
        titleLabel.frame.origin.x = horizontalInset
        titleLabel.frame.size.height = viewHeight
        frame.size.width = titleLabel.frame.maxX + horizontalInset
        frame.size.height = viewHeight
    }
    
}
