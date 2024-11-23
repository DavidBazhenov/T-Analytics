//
//  APIConfiguration.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import Alamofire

struct APIConfiguration {
    
    static var versionAPI: String {
        return "1"
    }
    
    static var baseURL: String {
        return "http://194.87.202.4:3000/" //prod
    }

    static var imageBaseURL: String {
        return baseURL
    }
    
    static var headers: HTTPHeaders {
        var headersDict : HTTPHeaders = [:]
        headersDict["version-api"] = versionAPI
        headersDict["platform"] = "ios"
        headersDict["User-Agent"] = "iOS/\(Bundle.main.releaseVersionNumber ?? "") (Build: \(Bundle.main.buildVersionNumber ?? ""); Api: \(versionAPI))"
        if let token = UserDefaultsHelper.shared.token {
            headersDict["Authorization"] = "Bearer \(token)"
        }

        return headersDict
    }
    
}
