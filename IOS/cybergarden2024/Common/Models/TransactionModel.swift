//
//  TransactionModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import Foundation

struct TransactionModel: Codable {
    var id: String?
    var userId: String?
    var categoryId: String?
    var walletFromId: String?
    var amount: Double?
    var type: String?
    var date: Date?
    var description: String?
    var category: Category?
    
    struct Category: Codable, Hashable {
        var name: String?
        var icon: String?
        var color: String?
        
        private enum CodingKeys: String, CodingKey {
            case name, icon, color
        }
        
        static func == (lhs: Category, rhs: Category) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, userId, categoryId, walletFromId, amount, type, date, description, category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        categoryId = try container.decodeIfPresent(String.self, forKey: .categoryId)
        walletFromId = try container.decodeIfPresent(String.self, forKey: .walletFromId)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        category = try container.decodeIfPresent(Category.self, forKey: .category)
        
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            date = formatter.date(from: dateString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(categoryId, forKey: .categoryId)
        try container.encodeIfPresent(walletFromId, forKey: .walletFromId)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(category, forKey: .category)
        
        if let date = date {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let dateString = formatter.string(from: date)
            try container.encode(dateString, forKey: .date)
        }
    }
}
