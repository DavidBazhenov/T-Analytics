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
    
    private enum CodingKeys: String, CodingKey {
        case id, userId, categoryId, walletFromId, amount, type, date, description
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
        
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            date = formatter.date(from: dateString)
        }
    }
}
