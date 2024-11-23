//
//  ViewsFactory.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import TinyConstraints
import AVKit

class ViewsFactory {
    
    class func defaultButton(
        type: UIButton.ButtonType = .system,
        height: CGFloat? = nil,
        color: UIColor,
        radius: CGFloat = 0,
        font: UIFont = .sFProText(ofSize: 17),
        titleColor: UIColor = .appWhite
    ) -> UIButton {
        let button = UIButton(type: type)
        if let height = height {
            button.height(height)
        }
        button.backgroundColor = color
        button.layer.cornerRadius = radius
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
    
    class func defaultLabel(
        lines: Int = 1,
        textColor: UIColor = .appBlack,
        font: UIFont = .sFProText(ofSize: 17),
        alignment: NSTextAlignment = .natural,
        adjustFont: Bool = false
    ) -> UILabel {
        let label = UILabel()
        label.numberOfLines = lines
        label.textColor = textColor
        label.font = font
        label.textAlignment = alignment
        if adjustFont {
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
        }
        return label
    }
    
    class func defaultImageView(
        contentMode: UIView.ContentMode = .scaleAspectFit,
        image: UIImage? = nil
    ) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        return imageView
    }
    
    class func defaultScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        return scrollView
    }
    
    class func defaultStackView(
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        margins: TinyEdgeInsets? = nil
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        if let margins = margins {
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = margins
        }
        return stackView
    }
    
    class func separatorLine(color: UIColor = .appBlack, vertical: Bool = true, thickness: CGFloat = 1) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        if vertical {
            line.width(thickness)
        } else {
            line.height(thickness)
        }
        return line
    }
    
    class func defaultActivityIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .appSystemGray) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        return indicator
    }
    
    class func defaultTableView(style: UITableView.Style = .plain) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        tableView.setDefaultSettings()
        return tableView
    }
    
    class func defaultBarButton(font: UIFont = .sFProText(ofSize: 17), image: AppImage? = nil, color: UIColor = .hexFF9500) -> UIBarButtonItem {
        let button = UIBarButtonItem()
        [.normal, .highlighted].forEach { state in
            button.setTitleTextAttributes([.font: font, .foregroundColor: color], for: state)
        }
        button.setTitleTextAttributes([.font: font, .foregroundColor: color.withAlphaComponent(0.2)], for: .disabled)
        button.image = image?.uiImageWith(font: font, tint: color)
        return button
    }
    
    class func defaultSwitch(tintColor: UIColor = .hexFF9500) -> UISwitch {
        let switchView = UISwitch()
        switchView.onTintColor = tintColor
        return switchView
    }
    
    class func defaultStepper(tintColor: UIColor = .white) -> UIStepper {
        let stepperView = UIStepper()
        stepperView.tintColor = tintColor
        return stepperView
    }
    
    class func defaultToolbar(height: CGFloat = 44) -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth, height: height)))
        return toolbar
    }
    
    // MARK: - Custom Views
    
    class func continueButton() -> UIButton {
        return defaultButton(
            height: 56,
            color: .hexFF9500,
            radius: 14,
            font: .sFProTextSemibold(ofSize: 20),
            titleColor: .appWhite
        )
    }
    
    class func tosPrivacyButton() -> UIButton {
        return defaultButton(
            color: .appClear,
            font: .sFProTextSemibold(ofSize: 13),
            titleColor: .appSystemGray
        )
    }
    
    class func premiumBarButton() -> UIBarButtonItem {
        return defaultBarButton(image: .sfCrown)
    }
    
    class func addBarButton() -> UIBarButtonItem {
        return defaultBarButton(image: .sfPlus)
    }
    
    class func defaultAvRoutePickerView() -> AVRoutePickerView {
        let pickerView = AVRoutePickerView()
        pickerView.isHidden = true
        return pickerView
    }
    
    class func setupBackBarButton(tintColor: UIColor = .hexFF9500, configurationBlock: (UIButton) -> Void) -> UIBarButtonItem {
        let backButton = ViewsFactory.defaultButton(color: .appClear, font: .sFProText(ofSize: 17), titleColor: tintColor)
        backButton.setTitle(^String.ButtonTitles.backButtonTitle, for: .normal)
        let backImage = AppImage.sfChevronBackward.uiImageWith(font: .sFProTextBold(ofSize: 17), tint: tintColor)
        backButton.setImage(backImage, for: .normal)
        backButton.setupHorizontalInsets(image: 2)
        configurationBlock(backButton)
        let backBarButton = UIBarButtonItem(customView: backButton)
        return backBarButton
    }
    
    class func greenCheckmarkLabel() -> UILabel {
        let label = defaultLabel()
        let image = AppImage.sfCheckmarkCircleFill.uiImageWith(
            font: .sFProTextSemibold(ofSize: 24),
            tint: .appSystemGreen
        )
        let attachment = NSTextAttachment()
        attachment.image = image
        label.attributedText = NSAttributedString(attachment: attachment)
        label.textAlignment = .right
        return label
    }
    
}
