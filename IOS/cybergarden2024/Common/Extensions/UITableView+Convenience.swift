//
//  UITableView+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

extension UITableView {
    
    func setDefaultSettings() {
        backgroundColor = .appClear
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        let tableHeaderFrame = CGRect(
            x: 0, y: 0,
            width: CGFloat.leastNormalMagnitude,
            height: CGFloat.leastNormalMagnitude
        )
        tableHeaderView = UIView(frame: tableHeaderFrame)
        tableFooterView = UIView(frame: tableHeaderFrame)
        sectionFooterHeight = .leastNormalMagnitude
    }
    
}
