//
//  AirDropOnlyActivityItemSource.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 17.11.2024.
//

import UIKit

class AirDropOnlyActivityItemSource: NSObject, UIActivityItemSource {
    
    let item: Any

    init(item: Any) {
        self.item = item
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return NSURL(string: "")!
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return item
    }
    
}
