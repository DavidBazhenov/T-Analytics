//
//  ViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 22.11.2024.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    var disposeBag = DisposeBag()
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
}
