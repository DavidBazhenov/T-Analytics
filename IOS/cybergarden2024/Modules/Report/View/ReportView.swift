//
//  ReportView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class ReportView: UIView, UIPageViewControllerDataSource {
    
    private let disposeBag = DisposeBag()
    public var deleteWallet: PublishSubject<Bool> = PublishSubject()
    public var back: PublishSubject<Bool> = PublishSubject()
    
    private var transactions: [TransactionModel] = [] {
        didSet {
            processTransactions()
            collectionView.reloadData()
            updateChartData()
        }
    }
    
    private var categorizedTransactions: [[(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)]] = []
    private var currentMonthCategorizedTransactions: [[(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)]] = []
    private var isIncomeSelected = true
    
    private let mainLabel: UILabel = {
        let label = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 32))
        label.text = ^String.Wallet.walletReport
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(AppImage.sfChevronLeft.uiImageWith(font: .interRegular(ofSize: 20), tint: .hexFEDE34), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(AppImage.sfTrash.uiImageWith(font: .interRegular(ofSize: 20), tint: .hexFEDE34), for: .normal)
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setImage(AppImage.sfArrowCounterclockwise.uiImageWith(font: .interRegular(ofSize: 20), tint: .hexFEDE34), for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let categoryPicker: UISegmentedControl = {
        let picker = UISegmentedControl(items: [^String.General.incomesTitle, ^String.General.expensesTitle])
        picker.backgroundColor = .hex1D1D1D
        picker.selectedSegmentTintColor = .hexFEDE34
        picker.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
        picker.setTitleTextAttributes([.foregroundColor: UIColor.hex1D1D1D, .font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        picker.layer.cornerRadius = 12
        picker.clipsToBounds = true
        picker.selectedSegmentIndex = 0
        return picker
    }()
    
    private let pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        return pageVC
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var pageControllers: [UIViewController] = {
        let currentMonthVC = ChartPageViewController()
        currentMonthVC.configure(with: ^String.General.lastMonthTitle)
        
        let allTimeVC = ChartPageViewController()
        allTimeVC.configure(with: ^String.General.allTimeTitle)
        
        _ = currentMonthVC.view
        _ = allTimeVC.view
        
        return [currentMonthVC, allTimeVC]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        configureCollectionView()
        configurePageViewController()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        addSubview(mainLabel)
        addSubview(backButton)
        addSubview(trashButton)
        addSubview(resetButton)
        addSubview(categoryPicker)
        addSubview(pageViewController.view)
        addSubview(collectionView)
    }
    
    private func setupLayout() {
        backButton.leftToSuperview(offset: 15)
        backButton.centerY(to: mainLabel)
        
        trashButton.rightToSuperview(offset: -15)
        trashButton.centerY(to: mainLabel)
        
        resetButton.rightToLeft(of: trashButton, offset: -10)
        resetButton.centerY(to: mainLabel)
        
        mainLabel.topToSuperview(offset: 77, usingSafeArea: false)
        mainLabel.centerXToSuperview()
        
        categoryPicker.topToBottom(of: mainLabel, offset: 10)
        categoryPicker.centerXToSuperview()
        categoryPicker.width(200)
        categoryPicker.height(40)
        
        pageViewController.view.topToBottom(of: categoryPicker, offset: 20)
        pageViewController.view.leftToSuperview(offset: 15)
        pageViewController.view.rightToSuperview(offset: -15)
        pageViewController.view.height(300)
        
        collectionView.topToBottom(of: pageViewController.view, offset: 20)
        collectionView.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 15, bottom: 15, right: 15))
    }
    
    private func configureCollectionView() {
        collectionView.register(ReportViewCell.self, forCellWithReuseIdentifier: "ReportViewCell")
        collectionView.register(OperationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OperationHeaderView")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configurePageViewController() {
        pageViewController.dataSource = self
        pageViewController.setViewControllers([pageControllers[0]], direction: .forward, animated: true)
    }
    
    private func setupActions() {
        categoryPicker.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func backButtonTapped() {
        back.onNext(true)
    }
    
    @objc private func trashButtonTapped() {
        deleteWallet.onNext(true)
    }
    
    @objc func resetButtonTapped() {
        categoryPicker.selectedSegmentIndex = 0
        isIncomeSelected = true
        updateChartData()
    }
    
    @objc private func segmentChanged() {
        isIncomeSelected = (categoryPicker.selectedSegmentIndex == 0)
        updateChartData()
    }
    
    private func updateChartData() {
        guard !categorizedTransactions.isEmpty else { return }
        
        let selectedData = categorizedTransactions[isIncomeSelected ? 1 : 0]
        let currentMonthData = currentMonthCategorizedTransactions[isIncomeSelected ? 1 : 0]

        if let currentMonthVC = pageControllers[0] as? ChartPageViewController {
            currentMonthVC.loadViewIfNeeded()
            currentMonthVC.updateChartData(with: currentMonthData)
        }
        if let allTimeVC = pageControllers[1] as? ChartPageViewController {
            allTimeVC.loadViewIfNeeded() 
            allTimeVC.updateChartData(with: selectedData)
        }
    }
    
    func updateTransactions(_ newTransactions: [TransactionModel]) {
        self.transactions = newTransactions
        processTransactions()
        collectionView.reloadData()
        updateChartData()
    }
    
    private func processTransactions() {
        let currentMonthTransactions = transactions.filter {
            guard let date = $0.date else { return false }
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
        }
        
        let expenseCategories = CategoryHelper.getCategories(for: "expense")
        let incomeCategories = CategoryHelper.getCategories(for: "income")
        
        // For all time
        let expenses = processCategoryTransactions(categories: expenseCategories, isIncome: false)
        let incomes = processCategoryTransactions(categories: incomeCategories, isIncome: true)
        categorizedTransactions = [expenses, incomes]
        
        // For current month
        let currentMonthExpenses = processCategoryTransactions(categories: expenseCategories, isIncome: false, transactions: currentMonthTransactions)
        let currentMonthIncomes = processCategoryTransactions(categories: incomeCategories, isIncome: true, transactions: currentMonthTransactions)
        currentMonthCategorizedTransactions = [currentMonthExpenses, currentMonthIncomes]
    }
    
    private func processCategoryTransactions(categories: [TransactionModel.Category], isIncome: Bool, transactions: [TransactionModel]? = nil) -> [(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)] {
        let transactions = transactions ?? self.transactions
        return categories.map { category in
            let filtered = transactions.filter {
                $0.category?.name == category.name && ($0.type == (isIncome ? "income" : "expense"))
            }
            let totalAmount = filtered.compactMap { $0.amount }.reduce(0, +)
            return (category: category, count: filtered.count, price: totalAmount, isIncome: isIncome)
        }.filter { $0.count > 0 }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pageControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.firstIndex(of: viewController), index < pageControllers.count - 1 else {
            return nil
        }
        return pageControllers[index + 1]
    }
}

extension ReportView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categorizedTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorizedTransactions[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportViewCell", for: indexPath) as? ReportViewCell else {
            fatalError("Unable to dequeue ReportViewCell")
        }
        let transaction = categorizedTransactions[indexPath.section][indexPath.row]
        cell.update(category: transaction.category, count: transaction.count, price: transaction.price, isIncome: transaction.isIncome)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OperationHeaderView", for: indexPath) as? OperationHeaderView else {
            fatalError("Unable to dequeue OperationHeaderView")
        }
        
        let totalAmount = categorizedTransactions[indexPath.section].reduce(0) { $0 + $1.price }
        let title = indexPath.section == 0 ? ^String.General.incomesTitle : ^String.General.expensesTitle
        
        header.update(title: title, totalAmount: totalAmount)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
}
