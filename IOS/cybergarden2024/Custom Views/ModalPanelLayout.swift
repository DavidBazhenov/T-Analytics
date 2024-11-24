//
//  ModalPanelLayout.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//


import FloatingPanel
import TinyConstraints

class ModalPanelLayout: FloatingPanelLayout {
    
    weak var targetGuide: UILayoutGuide?
    
    init(targetGuide: UILayoutGuide?) {
        self.targetGuide = targetGuide
    }
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        if let guide = targetGuide {
            return [
                .full: FloatingPanelAdaptiveLayoutAnchor(
                    absoluteOffset: -Constants.bottomSafeArea,
                    contentLayout: guide,
                    referenceGuide: .superview
                )
            ]
        } else {
            return [
                .full: FloatingPanelLayoutAnchor(
                    fractionalInset: 0.8,
                    edge: .bottom,
                    referenceGuide: .safeArea
                )
            ]
        }
    }
    
}

protocol SelfSizedModalController: AnyObject {
    func getLayoutGuide() -> UILayoutGuide
    func trackScrollView() -> UIScrollView?
}

class ModalsBuilder {
    
    static var maxHeight: CGFloat = Constants.screenHeight * 0.8
    static var defaultContentInsets = UIEdgeInsets.uniform(16)
    
    // MARK: - Documents
    
    static func buildCreateWalletModal(
        isCash: Bool,
        actionCard: @escaping ((_ name: String, _ currency: String) -> Void),
        actionCash: @escaping ((_ name: String, _ currency: String) -> Void)
    ) -> FloatingPanelController {
        let controller = CreateWallet()
        controller.createCard = actionCard
        controller.createCash = actionCash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            controller.updateMode(isCash: isCash)
        }
        return buildPanel(contentVC: controller)
    }
    
    static func buildDateModal(
        dateRangePick: @escaping (Date?, Date?) -> Void
    ) -> FloatingPanelController {
        let controller = DatePickerViewController()
        controller.onDateRangeSelected = dateRangePick
        return buildPanel(contentVC: controller)
    }
    
    static func buildCreateOperationModal(wallets: [WalletModel], onSuccess: (() -> Void)? = nil) -> FloatingPanelController {
        let controller = CreateOperationViewController()
        controller.onSuccess = onSuccess
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            controller.updateWallets(wallets: wallets)
        }
        return buildPanel(contentVC: controller)
    }
    
    private class func buildPanel(contentVC: UIViewController, canBeDismissedManually: Bool = true) -> FloatingPanelController {
        let fpc = FloatingPanelController()
        fpc.set(contentViewController: contentVC)
        
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = canBeDismissedManually
        fpc.isRemovalInteractionEnabled = canBeDismissedManually
        
        fpc.surfaceView.grabberHandleSize = .zero
        fpc.surfaceView.grabberHandlePadding = 0
        fpc.surfaceView.grabberAreaOffset = 0
        fpc.surfaceView.grabberHandle.isHidden = true
        
        fpc.surfaceView.appearance.cornerRadius = 12
        
        let selfSizedModal = contentVC as? SelfSizedModalController
        let layoutGuide = selfSizedModal?.getLayoutGuide()
        fpc.layout = ModalPanelLayout(targetGuide: layoutGuide)
        if let scrollView = selfSizedModal?.trackScrollView() {
            fpc.track(scrollView: scrollView)
            fpc.contentInsetAdjustmentBehavior = .never
        }
        return fpc
    }
    
}
