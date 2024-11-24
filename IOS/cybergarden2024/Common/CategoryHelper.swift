//
//  CategoryHelper.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import Foundation

class CategoryHelper {
    
    static func getCategories(for type: String) -> [TransactionModel.Category] {
        if type == "expense" {
            return [
                TransactionModel.Category(name: "Food", icon: "🍔", color: "#FF3B30"),         // Ярко-красный
                TransactionModel.Category(name: "Transport", icon: "🚗", color: "#FF9500"),    // Оранжевый
                TransactionModel.Category(name: "Entertainment", icon: "🎉", color: "#FFCC00") // Жёлтый
            ]
        } else if type == "income" {
            return [
                TransactionModel.Category(name: "Advance", icon: "💸", color: "#34C759"),      // Зелёный
                TransactionModel.Category(name: "Salary", icon: "💰", color: "#007AFF")       // Синий
            ]
        }
        return []
    }
}
