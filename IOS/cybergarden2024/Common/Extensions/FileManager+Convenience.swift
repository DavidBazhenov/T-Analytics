//
//  FileManager+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import Foundation

extension FileManager {
    
    func createDirectoryIfNeeded(url: URL) {
        guard !fileExists(atPath: url.path) else { return }
        try? createDirectory(at: url, withIntermediateDirectories: true)
    }
    
}
