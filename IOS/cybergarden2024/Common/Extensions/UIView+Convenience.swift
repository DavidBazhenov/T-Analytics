//
//  UIView+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit
import SVProgressHUD

extension UIView {
    
    func getSuperview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview?.getSuperview(of: type)
    }
    
    func findViewByString(_ classString: String) -> UIView? {
        for subview in subviews {
            if NSStringFromClass(type(of: subview)) == classString {
                return subview
            }
            if let view = subview.findViewByString(classString) {
                return view
            }
        }
        return nil
    }
    
    func calculateFrameOnScreen(calculatedFrame: CGRect? = nil, in view: UIView? = nil) -> CGRect {
        var frame = calculatedFrame ?? frame
        guard let superView = superview, let superSuperView = superView.superview else {
            return frame
        }
        frame = superView.convert(frame, to: superSuperView)
        if superView == view {
            return frame
        }
        return superView.calculateFrameOnScreen(calculatedFrame: frame, in: view)
    }
    
    func isLoading(_ loading: Bool) {
        switch loading {
        case true:
            if let _ = superview {
                SVProgressHUD.setContainerView(self)
                let containerOrigin = self.frame.origin
                SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: -containerOrigin.x-5, vertical: -containerOrigin.y))
            }
            SVProgressHUD.show()
        case false:
            SVProgressHUD.setContainerView(nil)
            SVProgressHUD.dismiss()
            SVProgressHUD.resetOffsetFromCenter()
        }  
    }
    
    @objc func hideKeyboard() {
        endEditing(true)
    }
    
}

// MARK: Helpers
extension UIView {

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
