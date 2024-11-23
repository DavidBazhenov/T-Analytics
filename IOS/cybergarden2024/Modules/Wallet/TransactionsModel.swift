//
//  TransactionsModel.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

struct TransactionsModel: Codable {
    
    var id: String?
    var userId: String?
    var categoryId: String?
    var walletFromId: String?
    var amount: Float?
    var type: String?
    var date: String?
    var description: String?
    
}
