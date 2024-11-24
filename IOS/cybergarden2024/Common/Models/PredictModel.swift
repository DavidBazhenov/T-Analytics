//
//  PredictModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 24.11.2024.
//

import Foundation

struct PredictModel: Codable {
    let date: Date
    let amount: Double
    let category: TransactionModel.Category
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case date, amount, category, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        
        self.date = parsedDate
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.category = try container.decode(TransactionModel.Category.self, forKey: .category)
        self.type = try container.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        try container.encode(dateString, forKey: .date)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(type, forKey: .type)
    }
}
