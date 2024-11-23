//
//  ProfileView.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints
import RxSwift

class ProfileView: UIView {
    
    enum Action {
        case editProfile
        case canUseML
        case changePhoto
        case openSupport
        case openTos
        case openPrivacy
        case openReport
        case shareApp
        case logout
    }
    
    private let disposeBag = DisposeBag()
    public var actions: PublishSubject<Action> = PublishSubject()
    
    private var sections: [ProfileSection] = []
    let sectionsHelper = ProfileSectionsHelper()
    
    private let mainLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 32))
    private let nameLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interBold(ofSize: 22))
    private let infoLabel = ViewsFactory.defaultLabel(textColor: .hexECF1F7, font: .interMedium(ofSize: 14))
    
    private let tableView = ViewsFactory.defaultTableView(style: .insetGrouped)
    
    private let imageView = ViewsFactory.defaultImageView()
    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(AppImage.profileAddPhoto.uiImage, for: .normal)
        button.backgroundColor = .hexECF1F7
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 23
        button.size(CGSize(width: 46, height: 46))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupTitle()
        setupBindings()
        setupViews()
        setupLayouts()
        updateSections()
    }
    
    private func setupBindings() {
        
    }
    
    private func setupTitle() {
        mainLabel.text = ^String.Profile.profileMainTitle
    }
    
    private func setupViews() {
        backgroundColor = .hex1D1D1D
        imageView.size(CGSize(width: 120, height: 120))
        imageView.layer.cornerRadius = 60
        imageView.image = AppImage.profileBasePhoto.uiImage
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        tableView.separatorInset = .left(57)
        tableView.dataSource = self
        tableView.delegate = self
        sectionsHelper.delegate = self
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    private func updateSections() {
        sections = sectionsHelper.buildSections()
        tableView.reloadData()
    }
    
    private func setupLayouts() {
        [mainLabel, nameLabel, infoLabel, imageView, addPhotoButton, tableView].forEach { addSubview($0) }
        
        mainLabel.topToSuperview(offset: 18, usingSafeArea: true)
        mainLabel.centerXToSuperview()
        
        imageView.topToBottom(of: mainLabel, offset: 30)
        imageView.centerXToSuperview()
        
        addPhotoButton.topToBottom(of: imageView, offset: -36)
        addPhotoButton.leftToRight(of: imageView, offset: -36)
        
        nameLabel.topToBottom(of: imageView, offset: 15)
        nameLabel.centerXToSuperview()
        
        infoLabel.topToBottom(of: nameLabel, offset: 5)
        infoLabel.centerXToSuperview()
        
        tableView.edgesToSuperview(excluding: .top, insets: .uniform(10))
        tableView.topToBottom(of: infoLabel, offset: 40)
    }
    
    @objc private func addPhotoButtonTapped() {
        actions.onNext(.changePhoto)
    }
    
    func loadPhoto(image: UIImage) {
        imageView.image = image
    }
    
    func update(model: ProfileModel) {
        nameLabel.text = model.name ?? ""
        infoLabel.text = "\(model.email ?? "") | \(model.phone ?? "")"
    }
    
}

// MARK: - UITableViewDataSource

extension ProfileView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .baseSection(let section):
            return section.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .baseSection(let section):
            let item = section.items[indexPath.row]
            return item.cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ProfileView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .baseSection(let section):
            let item = section.items[indexPath.row]
            item.handler?(item.cell)
        }
    }
    
}

// MARK: - SettingsSectionsHelperDelegate

extension ProfileView: ProfileSectionsHelperDelegate {
    
    func useML() {
        actions.onNext(.canUseML)
    }
    
    func shareApp() {
        actions.onNext(.shareApp)
    }
    
    func logout() {
        actions.onNext(.logout)
    }
    
    
    func openSupport() {
        actions.onNext(.openSupport)
    }
    
    func openReport() {
        actions.onNext(.openReport)
    }
    
    func openTos() {
        actions.onNext(.openTos)
    }
    
    func openPrivacy() {
        actions.onNext(.openPrivacy)
    }
    
    func openEditor() {
        actions.onNext(.editProfile)
    }
    
}
