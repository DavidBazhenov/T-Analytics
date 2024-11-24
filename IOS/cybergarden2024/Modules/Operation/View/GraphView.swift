//
//  GraphView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import UIKit
import ScrollableGraphView

class GraphView: UIView, ScrollableGraphViewDataSource {

    private var expensesData: [Double] = []
    private var incomesData: [Double] = []
    private var labels: [String] = []

    private var graphView: ScrollableGraphView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGraph()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGraph() {
        graphView = ScrollableGraphView(frame: self.bounds)
        graphView.dataSource = self

        let expensesLinePlot = LinePlot(identifier: "expensesLine")
        expensesLinePlot.lineColor = UIColor.hexECF1F7
        expensesLinePlot.adaptAnimationType = .elastic

        let expensesDotPlot = DotPlot(identifier: "expensesDot")
        expensesDotPlot.dataPointType = .circle
        expensesDotPlot.dataPointSize = 5
        expensesDotPlot.dataPointFillColor = UIColor.hexECF1F7
        expensesDotPlot.adaptAnimationType = .elastic

        let incomesLinePlot = LinePlot(identifier: "incomesLine")
        incomesLinePlot.lineColor = UIColor.hexFEDE34
        incomesLinePlot.adaptAnimationType = .elastic

        let incomesDotPlot = DotPlot(identifier: "incomesDot")
        incomesDotPlot.dataPointType = .square
        incomesDotPlot.dataPointSize = 5
        incomesDotPlot.dataPointFillColor = UIColor.hexFEDE34
        incomesDotPlot.adaptAnimationType = .elastic

        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.relativePositions = [0, 0.25, 0.5, 0.75, 1]
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)

        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: expensesLinePlot)
        graphView.addPlot(plot: expensesDotPlot)
        graphView.addPlot(plot: incomesLinePlot)
        graphView.addPlot(plot: incomesDotPlot)

        graphView.backgroundFillColor = .appClear
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true

        addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: self.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func resetGraph() {
        graphView?.removeFromSuperview()
        graphView = nil
        setupGraph()
    }

    func setData(expenses: [Double], incomes: [Double], labels: [String]) {
        var expenses = expenses
        expenses.reverse()
        var incomes = incomes
        incomes.reverse()
        var labels = labels
        labels.reverse()
        guard !expenses.isEmpty, !incomes.isEmpty, !labels.isEmpty else {
            print("Ошибка: данные графика пусты.")
            return
        }

        if expenses.count != incomes.count || incomes.count != labels.count {
            print("Данные не совпадают по длине. Автоматически дополняем массивы...")
            let maxCount = max(expenses.count, incomes.count, labels.count)
            self.expensesData = Array(expenses) + Array(repeating: 0.0, count: maxCount - expenses.count)
            self.incomesData = Array(incomes) + Array(repeating: 0.0, count: maxCount - incomes.count)
            self.labels = Array(labels) + Array(repeating: "Нет данных", count: maxCount - labels.count)
        } else {
            self.expensesData = expenses
            self.incomesData = incomes
            self.labels = labels
        }

        assert(expensesData.count == incomesData.count && incomesData.count == labels.count,
               "Количество данных для графика не совпадает.")

        resetGraph()
        graphView.shouldAdaptRange = false
        graphView.rangeMin = 0
        graphView.rangeMax = max(expensesData.max() ?? 0, incomesData.max() ?? 0) + 10
        graphView.reload()
    }

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        guard pointIndex >= 0 && pointIndex < expensesData.count else {
            print("Ошибка: индекс \(pointIndex) выходит за пределы массива.")
            return 0
        }

        switch plot.identifier {
        case "expensesLine", "expensesDot":
            return expensesData[pointIndex]
        case "incomesLine", "incomesDot":
            return incomesData[pointIndex]
        default:
            return 0
        }
    }

    func label(atIndex pointIndex: Int) -> String {
        guard pointIndex >= 0 && pointIndex < labels.count else {
            print("Ошибка: индекс \(pointIndex) выходит за пределы массива.")
            return ""
        }

        return labels[pointIndex]
    }

    func numberOfPoints() -> Int {
        return labels.count
    }
}
