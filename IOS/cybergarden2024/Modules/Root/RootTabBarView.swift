//
//  RootTabBarView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit

enum RootTabBarItem: Int, CaseIterable {
    
    case operations
    case wallets
    case plan
    case profile
    
    fileprivate var params: (title: String.Root, image: AppImage) {
        switch self {
        case .operations:
            return (.rootOperationsTitle, .rootOperations)
        case .wallets:
            return (.rootWalletsTitle, .rootWallets)
        case .plan:
            return (.rootPlanTitle, .rootPlan)
        case .profile:
            return (.rootProfileTitle, .rootProfile)
        }
    }
    
}

class RootTabBarItemView: UIView {
    
    let tabBarItem: RootTabBarItem
    
    private let imageView = ViewsFactory.defaultImageView()
    private let titleLabel = ViewsFactory.defaultLabel(font: .interRegular(ofSize: 11))
    
    private let parentStackView = ViewsFactory.defaultStackView(axis: .vertical, spacing: 3, alignment: .center, margins: .vertical(2))
    
    var handleTabBarItemSelected: ((RootTabBarItem) -> Void)?
    
    init(tabBarItem: RootTabBarItem) {
        self.tabBarItem = tabBarItem
        super.init(frame: .zero)
        setupViews()
        setupLayout()
        setupHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelected(_ isSelected: Bool) {
        let color = isSelected ? UIColor.hexFEDE34 : .hexECF1F7
        imageView.image = tabBarItem.params.image.uiImageWith(
            tint: color
        )
        titleLabel.textColor = color
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        let params = tabBarItem.params
        imageView.image = params.image.uiImage
        titleLabel.text = ^params.title
    }
    
    private func setupLayout() {
        [imageView, titleLabel].forEach { parentStackView.addArrangedSubview($0) }
        imageView.height(30)
        
        addSubview(parentStackView)
        parentStackView.edgesToSuperview()
    }
    
    private func setupHandlers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Handlers
    
    @objc private func viewTapped() {
        handleTabBarItemSelected?(tabBarItem)
    }
    
}

class RootTabBarItemsView: UIView {
    
    private lazy var tabBarItemsViews = RootTabBarItem.allCases.map { RootTabBarItemView(tabBarItem: $0) }
    private let parentStackView = ViewsFactory.defaultStackView(distribution: .fillEqually, alignment: .top)
    
    var handleTabBarItemSelected: ((RootTabBarItem) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setSelectedTabItem(_ selectedTabBarItem: RootTabBarItem) {
        tabBarItemsViews.forEach { tabBarItemView in
            let isSelected = tabBarItemView.tabBarItem == selectedTabBarItem
            tabBarItemView.setSelected(isSelected)
        }
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        setupLayout()
        setupHandlers()
    }
    
    private func setupLayout() {
        tabBarItemsViews.forEach { parentStackView.addArrangedSubview($0) }
        addSubview(parentStackView)
        parentStackView.edgesToSuperview()
    }
    
    private func setupHandlers() {
        tabBarItemsViews.forEach { tabBarItemView in
            tabBarItemView.handleTabBarItemSelected = { [weak self] tabBarItem in
                self?.handleTabBarItemSelected?(tabBarItem)
            }
        }
    }
    
}
