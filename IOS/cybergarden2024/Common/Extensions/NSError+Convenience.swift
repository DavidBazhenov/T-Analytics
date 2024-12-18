//
//  NSError+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import Foundation

extension NSError {
    
    static func getErrorWithDescription(_ description: String, code: Int = -1, domain: AnyClass? = nil) -> NSError {
        let domain = String(describing: domain ?? self)
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
}
