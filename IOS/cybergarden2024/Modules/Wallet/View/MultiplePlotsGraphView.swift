//
//  MultiplePlotsGraphView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import ScrollableGraphView
import TinyConstraints

class MultiplePlotsGraphView: UIView, ScrollableGraphViewDataSource {
    
    private var graphView: ScrollableGraphView?
    private var data: [[Double]] = []
    private var colors: [UIColor] = []
    private var xLabels: [String] = []
    
    func setupGraph(data: [([(Date, Double)], UIColor)]) {
        clear()
        
        self.data = data.map { $0.0.map { Double($0.1) } }
        self.colors = data.map { $0.1 }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        if let firstDataSet = data.first {
            self.xLabels = firstDataSet.0.map { dateFormatter.string(from: $0.0) }
        }
        
        let graphView = ScrollableGraphView(frame: self.bounds)
        graphView.dataSource = self
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        graphView.backgroundFillColor = .appClear
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        for (index, color) in colors.enumerated() {
            let linePlot = LinePlot(identifier: "line\(index)")
            linePlot.lineWidth = 2
            linePlot.lineColor = color
            linePlot.lineStyle = .smooth
            linePlot.shouldFill = true
            linePlot.fillType = .solid
            linePlot.fillColor = color.withAlphaComponent(0.5)
            linePlot.adaptAnimationType = .elastic
            graphView.addPlot(plot: linePlot)
        }
        
        self.graphView = graphView
        self.addSubview(graphView)
        
        graphView.edgesToSuperview()
    }
    
    func clear() {
        graphView?.removeFromSuperview()
        graphView = nil
        data.removeAll()
        colors.removeAll()
        xLabels.removeAll()
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        guard let plotIndex = Int(plot.identifier.dropFirst(4)) else { return 0 }
        if pointIndex >= data.count { return 0 }
        if plotIndex >= data[pointIndex].count { return 0 }
        return data[plotIndex][pointIndex]
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return xLabels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return xLabels.count
    }
}
