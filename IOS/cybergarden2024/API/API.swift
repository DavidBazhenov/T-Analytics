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
    
}
