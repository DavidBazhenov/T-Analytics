//
//  ReportDoughnutChartView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import PieCharts

class ReportDoughnutChartView: UIView, PieChartDelegate {
    
    var onCategorySelected: ((String) -> Void)?
    private var chartData: [(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)] = []
    private var isMain = true
    
    private var chartView: PieChart = {
        let chart = PieChart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChart() {
        addSubview(chartView)
        chartView.edgesToSuperview()
        chartView.delegate = self
        chartView.outerRadius = 95
        chartView.innerRadius = 75
        
        let textLayer = PiePlainTextLayer()
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 130
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.textColor = .hexECF1F7
        textLayerSettings.label.font = .interSemiBold(ofSize: 14)
        textLayerSettings.label.textGenerator = {slice in
            return String(format: "%.0f ₽", slice.data.model.value)
        }
        textLayer.settings = textLayerSettings
        
        chartView.layers = [textLayer]
    }
    
    private func generateRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func removeLabels() {
        chartView.subviews.forEach {
            if let label = $0 as? UILabel { label.removeFromSuperview() }
        }
    }
    
    func updateChart(with data: [(category: TransactionModel.Category, count: Int, price: Double, isIncome: Bool)], isMain: Bool) {
        chartView.removeSlices()
        removeLabels()
        chartData = data
        self.isMain = isMain
        
        let segments = data.map { entry -> PieSliceModel in
            PieSliceModel(value: entry.price, color: generateRandomColor())
        }
        
        let textLayer = PiePlainTextLayer()
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 130
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.textColor = .hexECF1F7
        textLayerSettings.label.font = .interSemiBold(ofSize: 14)
        textLayerSettings.label.textGenerator = {slice in
            return String(format: "%.0f ₽", slice.data.model.value)
        }
        textLayer.settings = textLayerSettings
        
        chartView.layers = [textLayer]
        
        chartView.models = []
        chartView.models = segments
    }
    
    func onSelected(slice: PieSlice, selected: Bool) {
        guard selected, isMain else { return }
        
        if let index = chartView.slices.firstIndex(where: { $0 == slice }) {
            let selectedCategory = chartData[index].category.name
            if let selectedCategory = selectedCategory { onCategorySelected?(selectedCategory) }
        }
    }
}
