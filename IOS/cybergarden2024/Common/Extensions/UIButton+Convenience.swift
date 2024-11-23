//
//  UIButton+Convenience.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import TinyConstraints

extension UIButton {
    
    func setupHorizontalInsets(image: CGFloat = 0, content: CGFloat = 0) {
        contentEdgeInsets = .horizontal(image + content)
        let image = semanticContentAttribute == .forceRightToLeft ? -image : image
        imageEdgeInsets = .right(image) + .left(-image)
        titleEdgeInsets = .left(image) + .right(-image)
    }
    
}
