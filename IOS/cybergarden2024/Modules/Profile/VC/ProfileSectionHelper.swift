//
//  ProfileSectionHelper.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit

enum ProfileSection {
    case baseSection(section: ProfileBaseSection)
}

struct ProfileBaseSection {
    let items: [ProfileBaseItem]
    
    init(items: [ProfileBaseItem]) {
        self.items = items
    }
}

struct ProfileBaseItem {
    let cell: ProfileTableViewCell
    let handler: ((ProfileTableViewCell) -> Void)?
    
    init(image: AppImage,
         title: String,
         view: UIView? = nil,
         isRed: Bool = false,
         isSwitch: Bool = false,
         switchHandler: ((Bool) -> Void)? = nil,
         handler: ((ProfileTableViewCell) -> Void)? = nil) {
        
        self.cell = ProfileTableViewCell(style: .default, reuseIdentifier: nil)
        self.handler = isSwitch ? nil : handler
        cell.imageView?.image = image.uiImage
        cell.textLabel?.text = title
        cell.selectionStyle = isSwitch ? .none : .default
        
        if isRed {
            cell.textLabel?.textColor = .appSystemRed
        }
        
        if isSwitch {
            let switchView = UISwitch()
            switchView.isOn = UserDefaultsHelper.shared.ml ?? false
            switchView.onTintColor = .hexFEDE34
            
            switchView.addAction(UIAction { action in
                if let switchControl = action.sender as? UISwitch {
                    switchHandler?(switchControl.isOn)
                }
            }, for: .valueChanged)
            
            cell.accessoryView = switchView
        } else if let view = view {
            view.sizeToFit()
            cell.accessoryView = view
        }
    }
}


protocol ProfileSectionsHelperDelegate: AnyObject {
    func openSupport()
    func useML()
    func openReport()
    func openTos()
    func openPrivacy()
    func openEditor()
    func shareApp()
    func logout()
}

class ProfileSectionsHelper {
    weak var delegate: ProfileSectionsHelperDelegate?
    
    func buildSections() -> [ProfileSection] {
        return [buildTopSection(), buildGeneralSection()]
    }
    
    private func buildTopSection() -> ProfileSection {
        let editorItem = ProfileBaseItem(image: .profileEdit, title: ^String.Profile.profileEditorTitle, view: UIImageView(image: AppImage.profileChevron.uiImage), handler:  { [weak self] _ in
            self?.delegate?.openEditor()
        })
        
        let mlItem = ProfileBaseItem(image: .profileML, title: ^String.Profile.profileMLTitle, isSwitch: true, switchHandler:  { [weak self] isOn in
            self?.delegate?.useML()
        })
        
        let items = [editorItem, mlItem]
        return .baseSection(section: ProfileBaseSection(items: items))
    }
    
    private func buildGeneralSection() -> ProfileSection {
        let supportItem = ProfileBaseItem(image: .profileSupport, title: ^String.Profile.profileSupportTitle, handler:  { [weak self] _ in
            self?.delegate?.openSupport()
        })
        
        let reportItem = ProfileBaseItem(image: .profileReport, title: ^String.Profile.profileReportTitle, handler:  { [weak self] _ in
            self?.delegate?.openReport()
        })
        
        let privacyItem = ProfileBaseItem(image: .profilePrivacy, title: ^String.Profile.profilePrivacyTitle, handler:  { [weak self] _ in
            self?.delegate?.openPrivacy()
        })
        
        let tosItem = ProfileBaseItem(image: .profileTos, title: ^String.Profile.profileTosTitle, handler:  { [weak self] _ in
            self?.delegate?.openTos()
        })
        
        let shareItem = ProfileBaseItem(image: .profileShare, title: ^String.Profile.profileShareTitle, handler:  { [weak self] _ in
            self?.delegate?.shareApp()
        })
        
        let logoutItem = ProfileBaseItem(image: .profileLogout, title: ^String.Profile.profileLogoutTitle, isRed: true, handler:  { [weak self] _ in
            self?.delegate?.logout()
        })
        
        let items = [supportItem, reportItem, privacyItem, tosItem, shareItem, logoutItem]
        return .baseSection(section: ProfileBaseSection(items: items))
    }
}
