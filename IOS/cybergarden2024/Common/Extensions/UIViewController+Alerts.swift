//
//  UIViewController+Alerts.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

//import TinyConstraints
//
//extension UIViewController {
//    
//    private func showAlertController(
//        title: String?,
//        message: String?,
//        actions: [UIAlertAction],
//        style: UIAlertController.Style = .alert
//    ) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
//        actions.forEach { alertController.addAction($0) }
//        present(alertController, animated: true)
//    }
//    
//    // MARK: - Alerts
//    
//    func showErrorAlert(message: String?, completion: (() -> Void)? = nil) {
//        let okAction = UIAlertAction(title: ^String.Alerts.okTitle, style: .cancel) { _ in completion?() }
//        showAlertController(title: ^String.Alerts.errorTitle, message: message, actions: [okAction])
//    }
//    
//    func showInfoAlert(title: String? = ^String.Alerts.infoTitle, message: String? = nil, completion: (() -> Void)? = nil) {
//        let okAction = UIAlertAction(title: ^String.Alerts.okTitle, style: .cancel) { _ in completion?() }
//        showAlertController(title: title, message: message, actions: [okAction])
//    }
//    
//    func showConfirmationAlert(message: String? = nil, completion: @escaping ((Bool) -> Void)) {
//        let yesAction = UIAlertAction(title: ^String.Alerts.yesTitle, style: .default) { _ in completion(true) }
//        let noAction = UIAlertAction(title: ^String.Alerts.noTitle, style: .cancel) { _ in completion(false) }
//        showAlertController(title: ^String.Alerts.areYouSure, message: message, actions: [yesAction, noAction])
//    }
//    
//}
