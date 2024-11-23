//
//  Array+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import Foundation

extension Array {
    
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0 && index < endIndex else { return nil }
        return self[index]
    }
    
}
