//
//  PredictView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit

class PredictView: UIView {
    
    private var predicts: [PredictModel]? {
        didSet {
            updateChartData()
            updateGraphData()
        }
    }
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .hexECF1F7
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.text = "Планирование"
        label.textAlignment = .center
        return label
    }()
    
    private let categoryPicker: UISegmentedControl = {
        let picker = UISegmentedControl(items: ["Доходы", "Расходы"])
        picker.backgroundColor = .hex1D1D1D
        picker.selectedSegmentTintColor = .hexFEDE34
        picker.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
        picker.setTitleTextAttributes([.foregroundColor: UIColor.hex1D1D1D, .font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        picker.layer.cornerRadius = 12
        picker.clipsToBounds = true
        picker.selectedSegmentIndex = 0
        return picker
    }()
    
    private let gistogramView = PredictGistogramView()
    private let graphView = GraphView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        addSubview(mainLabel)
        addSubview(categoryPicker)
        addSubview(gistogramView)
        addSubview(graphView)
    }
    
    private func setupLayout() {
        mainLabel.topToSuperview(offset: 77, usingSafeArea: false)
        mainLabel.centerXToSuperview()
        
        categoryPicker.topToBottom(of: mainLabel, offset: 10)
        categoryPicker.centerXToSuperview()
        categoryPicker.width(200)
        categoryPicker.height(40)
        
        gistogramView.topToBottom(of: categoryPicker, offset: 20)
        gistogramView.leftToSuperview(offset: 15)
        gistogramView.rightToSuperview(offset: -15)
        gistogramView.height(250)
        
        graphView.topToBottom(of: gistogramView, offset: 20)
        graphView.leftToSuperview(offset: 15)
        graphView.rightToSuperview(offset: -15)
        graphView.height(268)
    }
    
    private func setupActions() {
        categoryPicker.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        updateChartData()
    }
    
    private func updateChartData() {
        guard let predicts = predicts else { return }
        
        let isIncomeSelected = categoryPicker.selectedSegmentIndex == 0
        let filteredData = predicts
            .filter { isIncomeSelected ? $0.type == "income" : $0.type == "expense" }
            .reduce(into: [TransactionModel.Category: Double]()) { result, predict in
                result[predict.category, default: 0] += predict.amount
            }
            .map { (category: $0.key, price: $0.value) }
        
        gistogramView.updateChart(with: filteredData)
    }
    
    private func updateGraphData() {
        guard let predicts = predicts else { return }
        
        let incomeData = predicts
            .filter { $0.type == "income" }
            .reduce(into: [String: Double]()) { result, predict in
                let dateString = DateFormatter.localizedString(from: predict.date, dateStyle: .short, timeStyle: .none)
                result[dateString, default: 0] += predict.amount
            }
        
        let expenseData = predicts
            .filter { $0.type == "expense" }
            .reduce(into: [String: Double]()) { result, predict in
                let dateString = DateFormatter.localizedString(from: predict.date, dateStyle: .short, timeStyle: .none)
                result[dateString, default: 0] += predict.amount
            }
        
        let allDates = Array(Set(incomeData.keys).union(expenseData.keys))
            .sorted { lhs, rhs in
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                if let lhsDate = dateFormatter.date(from: lhs), let rhsDate = dateFormatter.date(from: rhs) {
                    return lhsDate > rhsDate
                }
                return false
            }
        
        let incomes = allDates.map { incomeData[$0] ?? 0 }
        let expenses = allDates.map { expenseData[$0] ?? 0 }
        
        graphView.setData(expenses: expenses, incomes: incomes, labels: allDates)
    }
    
    func update(predicts: [PredictModel]) {
        self.predicts = predicts
    }
}
