//
//  WalletViewCell.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit

class WalletViewCell: UICollectionViewCell {
    
    private let mainStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 5)
    private let logoWallet = ViewsFactory.defaultImageView()
    private let titleName = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interSemiBold(ofSize: 13))
    private let titleBalance = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interSemiBold(ofSize: 13))
    private let imageReporterBack = ViewsFactory.defaultImageView(image: AppImage.profileChevron.uiImage)
    
    override init (frame: CGRect) {
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
        addSubview(logoWallet)
        addSubview(imageReporterBack)
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleName)
        mainStackView.addArrangedSubview(titleBalance)
        
        logoWallet.edgesToSuperview(excluding: .right, insets: .uniform(13))
        imageReporterBack.verticalToSuperview(insets: .vertical(24))
        imageReporterBack.rightToSuperview(offset: -12)
        mainStackView.leftToRight(of: logoWallet, offset: 15)
        mainStackView.verticalToSuperview(insets: .vertical(8))
    }
    
    private func setupViews() {
        layer.cornerRadius = 10
        backgroundColor = .hex2E2F34
    }
    
    func update(wallet: WalletModel) {
        logoWallet.image = wallet.type == "cash" ? AppImage.walletCashIcon.uiImage : AppImage.walletCardIcon.uiImage
        titleName.text = wallet.name
        titleBalance.text = "\(wallet.balance ?? 0.0) \(wallet.currency ?? "")"
        logoWallet.backgroundColor = UIColor(hex: wallet.color ?? "")
    }
    
}
