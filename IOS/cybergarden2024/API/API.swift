//
//  API.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import Alamofire

struct API {
    
    struct Auth {
        
        struct register: APIRequest {
            let name: String
            let email: String
            let password: String
            
            var requestURL: String { return APIConfiguration.baseURL + "auth/register" }
            var httpMethod: HTTPMethod { return .post }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["name"] = name
                parameters["email"] = email
                parameters["password"] = password
                return parameters
            }
        }
        
        struct phoneLogin: APIRequest {
            let phone: String
            
            var requestURL: String { return APIConfiguration.baseURL + "auth/phone-login" }
            var httpMethod: HTTPMethod { return .post }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["phone"] = phone
                return parameters
            }
        }
        
        struct login: APIRequest {
            let email: String
            let password: String
            
            var requestURL: String { return APIConfiguration.baseURL + "auth/login" }
            var httpMethod: HTTPMethod { return .post }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["email"] = email
                parameters["password"] = password
                return parameters
            }
        }
        
    }
    
    struct Users {
        
        struct getMe: APIRequest {
            
            var requestURL: String { return APIConfiguration.baseURL + "users/me" }
            var httpMethod: HTTPMethod { return .get }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct putMe: APIRequest {
            let name: String
            let email: String
            let phone: String
            
            var requestURL: String { return APIConfiguration.baseURL + "users/me" }
            var httpMethod: HTTPMethod { return .put }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["name"] = name
                parameters["email"] = email
                parameters["phone"] = phone
                return parameters
            }
        }
        
    }
    
    struct Wallet {
        
        struct gettAllWallets: APIRequest {
            var requestURL: String { return APIConfiguration.baseURL + "wallets/findManyWallets" }
            var httpMethod: HTTPMethod { return .get }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct deleteWallet: APIRequest {
            let id: String
            
            var requestURL: String { return APIConfiguration.baseURL + "wallets/\(id)" }
            var httpMethod: HTTPMethod { return .delete }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct createWallet: APIRequest {
            let name: String
            let type: String
            let balance: Float
            let currency: String
            
            var requestURL: String { return APIConfiguration.baseURL + "wallets" }
            var httpMethod: HTTPMethod { return .post }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["name"] = name
                parameters["type"] = type
                parameters["balance"] = balance
                parameters["currency"] = currency
                return parameters
            }
        }
        
    }
    
    struct Transaction {
        
        struct gettAllWalletsTransactions: APIRequest {
            var requestURL: String { return APIConfiguration.baseURL + "transactions/getAllWalletsTransactions" }
            var httpMethod: HTTPMethod { return .get }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct gettAllTransactions: APIRequest {
            var requestURL: String { return APIConfiguration.baseURL + "transactions/getAllTransactions" }
            var httpMethod: HTTPMethod { return .get }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct getPredictTransactions: APIRequest {
            var requestURL: String { return APIConfiguration.baseURL + "transactions/getPredictTransactions" }
            var httpMethod: HTTPMethod { return .get }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct getTransactionsByWalletFromId: APIRequest {
            let id: String
            
            var requestURL: String { return APIConfiguration.baseURL + "transactions/getTransactionsByWalletFromId/\(id)" }
            var httpMethod: HTTPMethod { return .get }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                return parameters
            }
        }
        
        struct createTransaction: APIRequest {
            let userId: String
            let walletFromId: String
            let amount: Float
            let type: String
            let date: String
            let description: String
            let category: TransactionModel.Category
            
            var requestURL: String { return APIConfiguration.baseURL + "transactions" }
            var httpMethod: HTTPMethod { return .post }
            var parameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["userId"] = userId
                parameters["walletFromId"] = walletFromId
                parameters["amount"] = amount
                parameters["type"] = type
                parameters["date"] = date
                parameters["description"] = description
                parameters["category"] = [
                    "name": category.name,
                    "icon": category.icon,
                    "color": category.color
                ]
                return parameters
            }
        }
        
    }
    
}
