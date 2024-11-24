//
//  ChartPageViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit

class ChartPageViewController: UIViewController {
    private let doughnutChartView = ReportDoughnutChartView()
    private let periodLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interSemiBold(ofSize: 16))
    private var pendingData: [(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(doughnutChartView)
        view.addSubview(periodLabel)
        setupLayout()
        
        if let data = pendingData {
            updateChartData(with: data)
        }
    }
    
    func configure(with period: String) {
        periodLabel.text = period
    }
    
    func updateChartData(with data: [(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)]) {
        guard isViewLoaded else {
            pendingData = data
            return
        }
        doughnutChartView.updateChart(with: data, isMain: true)
    }
    
    private func setupLayout() {
        periodLabel.topToSuperview()
        periodLabel.centerXToSuperview()
        doughnutChartView.topToBottom(of: periodLabel, offset: 10)
        doughnutChartView.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 10, bottom: 10, right: 10))
    }
}
