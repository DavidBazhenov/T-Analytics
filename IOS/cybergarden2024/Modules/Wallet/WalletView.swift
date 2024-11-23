//
//  WalletView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class WalletView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum Action {
        case createCashWallet
        case createCardWallet
        case goToWallet(id: String)
        case openReport
        case updateAll
    }
    
    private let disposeBag = DisposeBag()
    public var actions: PublishSubject<Action> = PublishSubject()
    
    private let buttonsStackView: UIStackView = ViewsFactory.defaultStackView(axis: .horizontal, spacing: 22)
    
    private let mainLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 32))
    private let sumLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 20))
    private let allSumTitleLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 14))
    private let alltransactionGraphView = MultiplePlotsGraphView()
    
    private let createCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex2E2F34
        view.layer.cornerRadius = 10
        view.height(90)
        return view
    }()
    
    private let createCashView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex2E2F34
        view.layer.cornerRadius = 10
        view.height(90)
        return view
    }()
    
    private let reportView: UIView = {
        let view = UIView()
        view.backgroundColor = .hex2E2F34
        view.layer.cornerRadius = 11
        view.height(25)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var wallets: [WalletModel] = []
    private let refreshControl = UIRefreshControl()
    
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
        setupButtons()
        setupGestures()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.register(WalletViewCell.self, forCellWithReuseIdentifier: "WalletViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        addSubview(collectionView)
    }
    
    private func setupTitle() {
        mainLabel.text = ^String.Wallet.walletTitle
        allSumTitleLabel.text = ^String.Wallet.walletAllSum
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        buttonsStackView.distribution = .fillEqually
    }
    
    private func setupLayouts() {
        [createCardView, createCashView].forEach(buttonsStackView.addArrangedSubview)
        [mainLabel, sumLabel, allSumTitleLabel, alltransactionGraphView, reportView, buttonsStackView, collectionView].forEach(addSubview)
        
        mainLabel.topToSuperview(offset: 18, usingSafeArea: true)
        mainLabel.centerXToSuperview()
        
        sumLabel.topToBottom(of: mainLabel, offset: 15)
        sumLabel.centerXToSuperview()
        allSumTitleLabel.topToBottom(of: sumLabel, offset: 3)
        allSumTitleLabel.centerXToSuperview()
        
        alltransactionGraphView.topToBottom(of: allSumTitleLabel, offset: 15)
        alltransactionGraphView.horizontalToSuperview(insets: .horizontal(15))
        alltransactionGraphView.height(223)
        
        reportView.topToBottom(of: alltransactionGraphView, offset: 12)
        reportView.centerXToSuperview()
        reportView.width(104)
        
        buttonsStackView.topToBottom(of: reportView, offset: 15)
        buttonsStackView.horizontalToSuperview(insets: .horizontal(15))
        
        collectionView.topToBottom(of: buttonsStackView, offset: 15)
        collectionView.horizontalToSuperview(insets: .horizontal(15))
        collectionView.bottomToSuperview(offset: -15)
    }
    
    private func setupButtons() {
        let imageCard = ViewsFactory.defaultImageView(image: AppImage.walletCardIcon.uiImage)
        imageCard.tintColor = .hexECF1F7
        let titleCard = ViewsFactory.defaultLabel(lines: 2, textColor: .hexECF1F7, font: .interRegular(ofSize: 13))
        titleCard.text = ^String.Wallet.walletCreateNewCardTitle
        titleCard.textAlignment = .center
        createCardView.addSubview(imageCard)
        createCardView.addSubview(titleCard)
        imageCard.topToSuperview(offset: 10)
        imageCard.centerXToSuperview()
        titleCard.topToBottom(of: imageCard, offset: 12)
        titleCard.horizontalToSuperview(insets: .horizontal(10))
        
        let imageCash = ViewsFactory.defaultImageView(image: AppImage.walletCashIcon.uiImage)
        imageCash.tintColor = .hexECF1F7
        let titleCash = ViewsFactory.defaultLabel(lines: 2, textColor: .hexECF1F7, font: .interRegular(ofSize: 13))
        titleCash.text = ^String.Wallet.walletCreateNewCashTitle
        titleCash.textAlignment = .center
        createCashView.addSubview(imageCash)
        createCashView.addSubview(titleCash)
        imageCash.topToSuperview(offset: 10)
        imageCash.centerXToSuperview()
        titleCash.topToBottom(of: imageCash, offset: 12)
        titleCash.horizontalToSuperview(insets: .horizontal(10))
        
        let imageReporter = ViewsFactory.defaultImageView(image: AppImage.walletReportIcon.uiImage)
        let imageReporterBack = ViewsFactory.defaultImageView(image: AppImage.profileChevron.uiImage)
        let titleReport = ViewsFactory.defaultLabel(textColor: .hex99AAB2, font: .interSemiBold(ofSize: 13))
        titleReport.text = ^String.Wallet.walletReport
        [imageReporter, imageReporterBack, titleReport].forEach(reportView.addSubview)
        imageReporter.edgesToSuperview(excluding: .right, insets: .uniform(4))
        titleReport.verticalToSuperview(insets: .vertical(4))
        titleReport.leftToRight(of: imageReporter, offset: 7)
        imageReporterBack.edgesToSuperview(excluding: .left, insets: .uniform(7))
    }
    
    private func setupGestures() {
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(createCard))
        createCardView.addGestureRecognizer(cardTapGesture)
        
        let cashTapGesture = UITapGestureRecognizer(target: self, action: #selector(createCash))
        createCashView.addGestureRecognizer(cashTapGesture)
        
        let reportTapGesture = UITapGestureRecognizer(target: self, action: #selector(openReport))
        reportView.addGestureRecognizer(reportTapGesture)
    }
    
    @objc private func createCard() {
        actions.onNext(.createCardWallet)
    }
    
    @objc private func createCash() {
        actions.onNext(.createCashWallet)
    }
    
    @objc private func openReport() {
        actions.onNext(.openReport)
    }
    
    @objc private func handleRefresh() {
        actions.onNext(.updateAll)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func update(with walletsModels: [WalletModel], sum: Double) {
        sumLabel.text = "\(sum) ₽"
        wallets = walletsModels
        collectionView.reloadData()
    }
    
    func updateGraph(data: [([(Date, Double)], UIColor)] ) {
        alltransactionGraphView.setupGraph(data: data)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletViewCell", for: indexPath) as? WalletViewCell else {
            return UICollectionViewCell()
        }
        let wallet = wallets[indexPath.item]
        cell.update(wallet: wallet)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
    
}
