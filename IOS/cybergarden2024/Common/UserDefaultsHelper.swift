//
//  UserDefaultsHelper.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import Foundation
import UIKit

class UserDefaultsHelper: NSObject {
    
    static let shared = UserDefaultsHelper()
    
    private let userDefaults = UserDefaults.standard
    private let kToken = "token"
    private let kML = "ML"
    private let kSelectedPhoto = "selectedPhoto"
    
    // MARK: - Token Logic
    var token: String? {
        return userDefaults.value(forKey: kToken) as? String
    }
    
    var ml: Bool? {
        return userDefaults.value(forKey: kML) as? Bool
    }
    
    func saveToken(_ value: String) {
        userDefaults.setValue(value, forKey: kToken)
    }
    
    func saveML(_ value: Bool) {
        userDefaults.setValue(value, forKey: kML)
    }
    
    func removeToken() {
        userDefaults.removeObject(forKey: kToken)
    }
    
    func removeML() {
        userDefaults.removeObject(forKey: kML)
    }
    
    // MARK: - Image Logic
    func savePhoto(_ image: UIImage) {
        guard let imageData = image.pngData(), let token = token else { return }
        userDefaults.set(imageData, forKey: token)
    }
    
    func getPhoto() -> UIImage? {
        guard let token = token else { return nil }
        guard let imageData = userDefaults.data(forKey: token) else { return nil }
        return UIImage(data: imageData)
    }
    
    func removePhoto() {
        guard let token = token else { return }
        userDefaults.removeObject(forKey: token)
    }
}

extension UserDefaults {

   func save<T: Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T: Decodable>(object type:T.Type, fromKey key: String) -> T? {
       let decoder = JSONDecoder()
       guard let data = data(forKey: key), let object = try? decoder.decode(type, from: data) else { return nil }
       return object
   }

}
