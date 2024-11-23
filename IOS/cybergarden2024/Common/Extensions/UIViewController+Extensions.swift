//
//  UIViewController+Extensions.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxCocoa
import RxSwift
import UIKit

extension UIViewController {
    func showAlertView(_ title: String?, _ description: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Oк", style: .default, handler: nil))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func pushToViewController(_ vc: UIViewController) {
        if let navigationVC = self.navigationController {
            navigationVC.pushViewController(vc, animated: true)
        }
    }
}
