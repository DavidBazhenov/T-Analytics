//
//  ProfileViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import RxSwift

class ProfileViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let mainView = ProfileView()
    private let viewModel = ProfileViewModel()
    private let editorVC = EditProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupBindings()
        loadSavedPhoto()
        
        if let model = self.viewModel.profileData {
            mainView.update(model: model)
        }
    }
    
    private func setupBindings() {
        viewModel.userLoad.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self, let model = self.viewModel.profileData else { return }
                self.mainView.update(model: model)
            })
            .disposed(by: disposeBag)
        
        viewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlertView("Error", error)
            })
            .disposed(by: disposeBag)
        
        viewModel.loading.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                self.view.isLoading(loading)
            })
            .disposed(by: disposeBag)
        
        mainView.actions.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.handleAction(action: action)
            })
            .disposed(by: disposeBag)
        
        editorVC.reloadData.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.viewModel.initProfileData()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleAction(action: ProfileView.Action) {
        switch action {
        case .changePhoto:
            changePhoto()
        case .openTos:
            if let pdfURL = Bundle.main.url(forResource: "tos", withExtension: "pdf") {
                openWebView(url: pdfURL)
            }
        case .openReport:
            break
        case .openPrivacy:
            if let pdfURL = Bundle.main.url(forResource: "privacy", withExtension: "pdf") {
                openWebView(url: pdfURL)
            }
        case .openSupport:
            break
        case .editProfile:
            editorVC.model = viewModel.profileData
            editorVC.update()
            navigationController?.pushViewController(editorVC, animated: true)
        case .canUseML:
            var ml = UserDefaultsHelper.shared.ml ?? false
            ml.toggle()
            UserDefaultsHelper.shared.saveML(ml)
        case .shareApp:
            break
        case .logout:
            UserDefaultsHelper.shared.removeToken()
            AppNavigator.shared.showAuthController()
        }
    }
    
    private func openWebView(url: URL) {
        let vc = WebViewController(url: url)
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true)
    }
    
    private func changePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        saveImageToUserDefaults(image)
        updateProfilePhoto(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func saveImageToUserDefaults(_ image: UIImage) {
        UserDefaultsHelper.shared.savePhoto(image)
    }

    private func loadSavedPhoto() {
        if let savedImage = UserDefaultsHelper.shared.getPhoto() {
            updateProfilePhoto(savedImage)
        }
    }
    
    private func updateProfilePhoto(_ image: UIImage) {
        mainView.loadPhoto(image: image)
    }
}
