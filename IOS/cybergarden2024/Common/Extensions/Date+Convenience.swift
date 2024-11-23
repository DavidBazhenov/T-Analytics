//
//  Date+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import Foundation

extension Date {
    
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}
