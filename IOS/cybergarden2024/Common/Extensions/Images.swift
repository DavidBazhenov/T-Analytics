//
//  Images.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.09.2024
//

import UIKit

enum AppImage: String {
    
    //Root
    case rootOperations
    case rootWallets
    case rootAi
    case rootNotifications
    case rootProfile
    
    //Profile
    case profileAddPhoto
    case profileEdit
    case profileSupport
    case profileReport
    case profilePrivacy
    case profileTos
    case profileBasePhoto
    case profileML
    case profileLogout
    case profileShare
    case profileChevron
    case profileSwitchIcon
    
    //Authorization
    case tbankLogo
    case tbankButtonLogo
    case googleLogo
    case eyeOpen
    case eyeClose
    
    //Sf images
    case sfClose = "xmark"
    case sfCrown = "crown"
    case sfChevronRight = "chevron.right"
    case sfChevronLeft = "chevron.left"
    case sfCheckmark = "checkmark"
    case sfChevronBackward = "chevron.backward"
    case sfAppleLogo = "apple.logo"
    case sfNosign = "nosign"
    case sfSquareGridFill = "square.grid.2x2.fill"
    case sfDocOnDocFill = "doc.on.doc.fill"
    case sfAIAssistantStars
    case sfAIAssistantStarsLarge
    case sfAIAssistantStarsLargeFill
    case sfStarFill = "star.fill"
    case sfGearshape = "gearshape"
    case sfGearshapeFill = "gearshape.fill"
    case sfArrowTriangleCirclepath = "arrow.triangle.2.circlepath"
    case sfCloud = "cloud"
    case sfPhotoOnRectangleAngled = "photo.on.rectangle.angled"
    case sfCrownFill = "crown.fill"
    case sfPerson = "person"
    case sfInfinity = "infinity"
    case sfPlus = "plus"
    case sfPlusRectangle = "plus.rectangle"
    case sfCharacterTextbox = "character.textbox"
    case sfDocBadgePlus = "doc.badge.plus"
    case sfFolderBadgePlus = "folder.badge.plus"
    case sfCloudAndArrowDown = "icloud.and.arrow.down"
    case sfDocText = "doc.text"
    case sfSquareGrid = "square.grid.2x2"
    case sfClockArrowCirclepath = "clock.arrow.circlepath"
    case sfBoltFill = "bolt.fill"
    case sfPaperplaneFill = "paperplane.fill"
    case sfMicFill = "mic.fill"
    case sfMicSlashFill = "mic.slash.fill"
    case sfStopIcon = "stop.fill"
    case sfArrowUpDoc = "arrow.up.doc"
    case sfSquareAndPencil = "square.and.pencil"
    case sfArrowCounterclockwise = "arrow.counterclockwise"
    case sfICloud = "icloud"
    case sfTrash = "trash"
    case sfStar = "star"
    case sfClock = "clock"
    case sfCheckmarkCircle = "checkmark.circle"
    case sfCircle = "circle"
    case sfCheckmarkCircleFill = "checkmark.circle.fill"
    case sfDocOnDoc = "doc.on.doc"
    case sfSquareAndArrowUp = "square.and.arrow.up"
    case sfEllipsisCircle = "ellipsis.circle"
    case sfSquareAndArrowDown = "square.and.arrow.down"
    case sfDocRichtext = "doc.richtext"
    case sfEyeFill = "eye.fill"
    case sfXmarkCircle = "xmark.circle"
    case sfChevronDown = "chevron.down"
    case sfChevronUp = "chevron.up"
    case sfXmarkCircleFill = "xmark.circle.fill"
    case sfHouse = "house"
    case sfWandAndRays = "wand.and.rays"
    case sfPlusApp = "plus.app"
    case sfArrowUturnBackward = "arrow.uturn.backward"
    case sfArrowUturnForward = "arrow.uturn.forward"
    case sfRectangleStack = "rectangle.stack"
    case sfMagnifyingglass = "magnifyingglass"
    case sfRectangleExpandVertical = "rectangle.expand.vertical"
    case sfPrinter = "printer"
    case sfTextformat = "textformat"
    case sfEllipsis = "ellipsis"
    case sfFolder = "folder"
    case sfArchiveBox = "archivebox"
    case sfListBullet = "list.bullet"
    case sfRectangleGrid = "rectangle.grid.1x2"
    
    var uiImage: UIImage? {
        return UIImage(systemName: rawValue) ?? UIImage(named: rawValue)
    }
    
    func uiImageWith(font: UIFont? = nil, tint: UIColor? = nil) -> UIImage? {
        var img = uiImage
        if let font = font {
            img = img?.withConfiguration(UIImage.SymbolConfiguration(font: font))
        }
        if let tint = tint {
            return img?.withTintColor(tint, renderingMode: .alwaysOriginal)
        } else {
            return img
        }
    }
    
}
