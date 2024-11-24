//
//  LocalizedStrings.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    enum Root: String {
        case rootOperationsTitle
        case rootWalletsTitle
        case rootChatBotTitle
        case rootPlanTitle
        case rootProfileTitle
    }
    
    enum ButtonTitles: String {
        case backButtonTitle
    }
    
    enum Profile: String {
        case profileMainTitle
        case profileTosTitle
        case profilePrivacyTitle
        case profileReportTitle
        case profileEditorTitle
        case profileSupportTitle
        case profileEditMainTitle
        case profileSaveTitle
        case profileBackTitle
        case profileMLTitle
        case profileShareTitle
        case profileLogoutTitle
    }
    
    enum Auth: String {
        case authLogoTitle
        case authExitWordTitle
        case authRegistrationWordTitle
        case authGoogleTitle
        case authFastAccessTitle
        case authEmailTitle
        case authPasswordTitle
        case authRegistrationTitle
        case authExitTitle
        case authTosAndPrivacyTitle
        case authTosTitle
        case authPrivacyTitle
        case authErrorLoginOrPasswordTitle
        case authPhoneTitle
        case authConfirmPasswordTitle
        case authNameTitle
        case authPasswordQuestionTitle
        case authContinueTitle
        case authExitByTIDTitle
    }
    
    enum Wallet: String {
        case walletTitle
        case walletAllSum
        case walletReport
        case walletCreateNewCardTitle
        case walletCreateNewCashTitle
    }
    
}

extension RawRepresentable {
    
    func format(_ args: CVarArg...) -> String {
        let format = ^self
        return String(format: format, arguments: args)
    }
    
}

prefix operator ^
prefix func ^<Type: RawRepresentable> (_ value: Type) -> String {
    if let raw = value.rawValue as? String {
        let key = raw.capitalizeFirstLetter()
        return NSLocalizedString(key, comment: "")
    }
    return ""
}
