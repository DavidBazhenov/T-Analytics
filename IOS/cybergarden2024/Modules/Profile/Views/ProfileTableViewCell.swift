//
//  ProfileTableViewCell.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setDisabled(_ disabled: Bool) {
        let alpha: CGFloat = disabled ? 0.3 : 1
        [imageView, textLabel, detailTextLabel].forEach {
            $0?.alpha = alpha
        }
        if let button = accessoryView as? UIButton {
            button.isEnabled = !disabled
            [button.imageView, button.titleLabel].forEach {
                $0?.alpha = alpha
            }
        }
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        backgroundColor = .hexECF1F7
        textLabel?.font = .interRegular(ofSize: 14)
        textLabel?.textColor = .hex1D1D1D
    }
    
}
