//
//  PredictGistogramView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import PieCharts
import TinyConstraints

class PredictGistogramView: UIView, PieChartDelegate {
    
    private var chartData: [(category: TransactionModel.Category, price: Double, color: UIColor)] = []
    
    private let chartView: PieChart = {
        let chart = PieChart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private let categoryListView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .trailing
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
        setupCategoryListView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChart() {
        addSubview(chartView)
        chartView.edgesToSuperview(excluding: .right, insets: .init(top: 10, left: 10, bottom: 10, right: 0))
        chartView.width(200)
        chartView.delegate = self
        chartView.outerRadius = 75
        chartView.innerRadius = 55
        
        let textLayer = PiePlainTextLayer()
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 100
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.textColor = .hexECF1F7
        textLayerSettings.label.font = .interSemiBold(ofSize: 12)
        textLayerSettings.label.textGenerator = { slice in
            return String(format: "%.0f ₽", slice.data.model.value)
        }
        textLayer.settings = textLayerSettings
        
        chartView.layers = [textLayer]
    }
    
    private func setupCategoryListView() {
        addSubview(categoryListView)
        categoryListView.leftToRight(of: chartView, offset: 0)
        categoryListView.topToSuperview(offset: 10)
        categoryListView.rightToSuperview(offset: -5, priority: .defaultHigh)
    }
    
    private func generateRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func updateCategoryList() {
        categoryListView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (category, _, color) in chartData {
            let label = UILabel()
            label.text = "\(category.icon ?? "") \(category.name ?? "")"
            label.textColor = .hexECF1F7
            label.font = .systemFont(ofSize: 14)
            label.numberOfLines = 0
            label.lineBreakMode = .byTruncatingTail
            
            let colorSquare = UIView()
            colorSquare.backgroundColor = color
            colorSquare.layer.cornerRadius = 2
            
            colorSquare.width(10)
            colorSquare.height(10)
            
            let horizontalStack = UIStackView(arrangedSubviews: [label, colorSquare])
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 8
            horizontalStack.alignment = .center
            
            categoryListView.addArrangedSubview(horizontalStack)
        }
    }
    
    func updateChart(with data: [(category: TransactionModel.Category, price: Double)]) {
        removeLabels()
        chartView.removeSlices()
        
        chartData = data.map { entry in
            let color = generateRandomColor()
            return (entry.category, entry.price, color)
        }
        
        let segments = chartData.map { entry -> PieSliceModel in
            PieSliceModel(value: entry.price, color: entry.color)
        }
        
        let textLayer = PiePlainTextLayer()
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 100
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.textColor = .hexECF1F7
        textLayerSettings.label.font = .interSemiBold(ofSize: 12)
        textLayerSettings.label.textGenerator = { slice in
            return String(format: "%.0f ₽", slice.data.model.value)
        }
        textLayer.settings = textLayerSettings
        
        chartView.layers = [textLayer]
        
        chartView.models = []
        chartView.models = segments
        updateCategoryList()
    }
    
    func onSelected(slice: PieSlice, selected: Bool) {}
    
    private func removeLabels() {
        chartView.subviews.forEach {
            if let label = $0 as? UILabel { label.removeFromSuperview() }
        }
    }
}
