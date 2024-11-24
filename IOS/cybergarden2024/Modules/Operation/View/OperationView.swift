//
//  OperationView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class OperationView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    enum Action {
        case addTransaction
        case updateAll
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    public var actions: PublishSubject<Action> = PublishSubject()

    private let mainLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 32))

    let selectorWalletsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(^String.General.allWalletsTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interMedium(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.size(CGSize(width: 170, height: 18))
        if let arrowImage = AppImage.sfChevronDown.uiImage {
            button.setImage(arrowImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .white
            button.semanticContentAttribute = .forceRightToLeft
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        }
        return button
    }()
    
    private let graphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let selectorDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(^String.General.selectDatesTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interMedium(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.size(CGSize(width: 170, height: 18))
        if let arrowImage = AppImage.sfChevronDown.uiImage {
            button.setImage(arrowImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .white
            button.semanticContentAttribute = .forceRightToLeft
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        }
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(55)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            // Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
            section.interGroupSpacing = 20

            // Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(30)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
        layout.register(
            RoundedSectionBackgroundView.self,
            forDecorationViewOfKind: "RoundedSectionBackgroundView"
        )
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(AppImage.createOperation.uiImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var groupedTransactions: [(date: Date, transactions: [TransactionModel], totalAmount: Double)] = []
    private var originalTransactions: [TransactionModel] = []
    private var wallets: [WalletModel] = []
    private let refreshControl = UIRefreshControl()

    private var selectedWallet: WalletModel?
    private var selectedDate: Date?

    // MARK: - Initializers
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
        setupCollectionView()
        setupActions()
        setupFloatingButton()
    }

    // MARK: - Setup
    private func setupTitle() {
        mainLabel.text = ^String.General.operationsTitle
    }

    private func setupViews() {
        backgroundColor = .hex1D1D1D
        addSubview(mainLabel)
        addSubview(selectorWalletsButton)
        addSubview(selectorDateButton)
        addSubview(collectionView)
        addSubview(graphView)
    }

    private func setupLayouts() {
        mainLabel.topToSuperview(offset: 77, usingSafeArea: false)
        mainLabel.centerXToSuperview()

        selectorWalletsButton.topToBottom(of: mainLabel, offset: 15)
        selectorWalletsButton.leftToSuperview(offset: 16)

        selectorDateButton.topToBottom(of: mainLabel, offset: 15)
        selectorDateButton.rightToSuperview(offset: -16)
        
        graphView.topToBottom(of: selectorWalletsButton, offset: 15)
        graphView.height(268)
        graphView.horizontalToSuperview(insets: .horizontal(30))

        collectionView.topToBottom(of: graphView, offset: 15)
        collectionView.horizontalToSuperview(insets: .horizontal(30))
        collectionView.bottomToSuperview(offset: 0)
    }

    private func setupCollectionView() {
        collectionView.register(OperationViewCell.self, forCellWithReuseIdentifier: "OperationViewCell")
        collectionView.register(OperationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }

    private func setupActions() {
        selectorWalletsButton.addTarget(self, action: #selector(showWalletSelector), for: .touchUpInside)
        selectorDateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    private func setupFloatingButton() {
        addSubview(addTransactionButton)
        addTransactionButton.rightToSuperview(offset: -10)
        addTransactionButton.topToSuperview(offset: Constants.screenHeight - 140)
        addTransactionButton.height(56)
        addTransactionButton.addTarget(self, action: #selector(handleAddTransaction), for: .touchUpInside)
    }

    // MARK: - Data Update
    func updateData(transactions: [TransactionModel], wallets: [WalletModel]) {
        self.originalTransactions = transactions
        self.wallets = wallets
        applyFilters()
    }

    private func applyFilters(startDate: Date? = nil, endDate: Date? = nil) {
        var filteredTransactions = originalTransactions

        if let wallet = selectedWallet {
            filteredTransactions = filteredTransactions.filter { $0.walletFromId == wallet._id }
            selectorWalletsButton.setTitle(wallet.name, for: .normal)
        } else {
            selectorWalletsButton.setTitle(^String.General.allWalletsTitle, for: .normal)
        }
        if let startDate = startDate, let endDate = endDate {
            filteredTransactions = filteredTransactions.filter {
                guard let transactionDate = $0.date else { return false }
                return transactionDate >= startDate && transactionDate <= endDate
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            selectorDateButton.setTitle("\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))", for: .normal)
        } else {
            selectorDateButton.setTitle(^String.General.selectDatesTitle, for: .normal)
        }

        groupedTransactions = groupTransactionsByDate(transactions: filteredTransactions)
        let dates = groupedTransactions.map { $0.date }
        let expenses = groupedTransactions.map { $0.transactions.filter { $0.type == "expense" }.reduce(0) { $0 + ($1.amount ?? 0) } }
        let incomes = groupedTransactions.map { $0.transactions.filter { $0.type == "income" }.reduce(0) { $0 + ($1.amount ?? 0) } }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let labels = dates.map { dateFormatter.string(from: $0) }
        graphView.setData(expenses: expenses, incomes: incomes, labels: labels)
        collectionView.reloadData()
    }

    private func groupTransactionsByDate(transactions: [TransactionModel]) -> [(Date, [TransactionModel], Double)] {
        let grouped = Dictionary(grouping: transactions) { transaction -> Date in
            guard let date = transaction.date else { return Date() }
            return Calendar.current.startOfDay(for: date)
        }

        return grouped.map { date, transactions in
            let totalAmount = transactions.reduce(0) { sum, transaction in
                let amount = transaction.amount ?? 0
                return sum + (transaction.type == "expense" ? -amount : amount)
            }
            return (date, transactions, totalAmount)
        }.sorted { $0.0 > $1.0 }
    }

    // MARK: - Handlers
    @objc private func handleRefresh() {
        actions.onNext(.updateAll)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }

    @objc private func showWalletSelector() {
        let alertController = UIAlertController(title: ^String.General.selectWalletTitle, message: nil, preferredStyle: .actionSheet)

        let allWalletsAction = UIAlertAction(title: ^String.General.allWalletsTitle, style: .default) { _ in
            self.selectedWallet = nil
            self.applyFilters()
        }
        alertController.addAction(allWalletsAction)

        for wallet in wallets {
            let action = UIAlertAction(title: wallet.name, style: .default) { _ in
                self.selectedWallet = wallet
                self.applyFilters()
            }
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: ^String.General.cancelButtonTitle, style: .cancel))
        findParentViewController()?.present(alertController, animated: true)
    }

    @objc private func showDatePicker() {
        let modal = ModalsBuilder.buildDateModal(
            dateRangePick: { [weak self] startDate, endDate in
                guard let self = self else { return }

                self.selectedDate = nil
                self.applyFilters(startDate: startDate, endDate: endDate)
            }
        )
        findParentViewController()?.present(modal, animated: true)
    }
    
    @objc private func handleAddTransaction() {
        actions.onNext(.addTransaction)
    }

    private func findParentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupedTransactions.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedTransactions[section].transactions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperationViewCell", for: indexPath) as? OperationViewCell else {
            return UICollectionViewCell()
        }
        let transaction = groupedTransactions[indexPath.section].transactions[indexPath.item]
        let walletName = wallets.first(where: { $0._id == transaction.walletFromId })?.name ?? ^String.General.unknownWalletError
        cell.update(transaction: transaction, walletName: walletName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? OperationHeaderView else {
                return UICollectionReusableView()
            }
            let group = groupedTransactions[indexPath.section]
            header.update(date: group.date, totalAmount: group.totalAmount)
            return header
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 55)
        }
}
