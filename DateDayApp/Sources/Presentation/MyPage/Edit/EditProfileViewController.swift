//
//  EditProfileViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class EditProfileViewController: UIViewController {
    // MARK: UI
    let editProfileView = EditProfileView()
    
    // MARK: Properties
    private var selections = [String : PHPickerResult]() 
    private var selectedAssetIdentifiers = [String]()
    var selectedImage = PublishSubject<UIImage>()
    weak var delegate: EditedProfileDataDelegate?
    
    let viewModel = EditProfileViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        navigationItem.title = "프로필 정보 수정"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func bind() {
        let input = EditProfileViewModel.Input(
            setProfileImageButtonTap: editProfileView.setProfileImageButton.rx.tap,
            editingCompleteButtonTap: editProfileView.editingCompleteButton.rx.tap,
            setDefaultImageButtonTap: editProfileView.setDefaultImageButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        var selectedProfileImage: UIImage?
        
        // 프로필 데이터 뷰에 업데이트
        output.profileData
            .bind(with: self) { owner, profileData in
                owner.editProfileView.nicknameTextField.text = profileData.nickname
                owner.editProfileView.emailLabel.text = profileData.email
                owner.editProfileView.editMyIntroduceTextView.text = profileData.myIntroduce
                
                if let image = profileData.profileImage {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        owner.editProfileView.profileImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 프로필 이미지 설정
        output.setProfileImageButtonTap
            .bind(with: self) { owner, _ in
                owner.presentPicker()
            }
            .disposed(by: disposeBag)
        
        // 기본 이미지 설정
        output.setDefaultImageButtonTap
            .bind(with: self) { owner, _ in
                let defaultImage = UIImage(resource: .defaultProfile)
                owner.selectedImage.onNext(defaultImage)
            }
            .disposed(by: disposeBag)
        
        // 선택한 이미지 뷰에 업데이트
        selectedImage
            .bind(with: self) { owner, selectedImage in
                owner.editProfileView.profileImageView.image = selectedImage
            }
            .disposed(by: disposeBag)
        
        // 편집 완료 버튼 클릭
        selectedImage
            .bind(with: self) { onwer, image in
                print("image: \(image)")
                selectedProfileImage = image
            }
            .disposed(by: disposeBag)
        
        output.editingCompleteButtonTap
            .bind(with: self) { owner, _ in
                guard let editedNickname = owner.editProfileView.nicknameTextField.text else { return }
                
                if let selectedImage = selectedProfileImage?.jpegData(compressionQuality: 0.5) {
                    NetworkManager.shared.editProfile(
                        nickname: editedNickname,
                        introduce: owner.editProfileView.editMyIntroduceTextView.text,
                        profile: selectedImage)
                        .subscribe(with: self) { owner, result in
                            switch result {
                            case .success(let success):
                                input.editedProfileData.onNext(success)
                                owner.okShowAlert(title: "프로필 정보가 변경되었습니다! :)", message: "") { _ in
                                    owner.delegate?.editedProfileData(editedData: success)
                                    owner.navigationController?.popViewController(animated: true)
                                }
                            case .failure(let failure):
                                switch failure {
                                case .accessTokenExpiration:
                                    owner.updateToken()
                                default:
                                    break
                                }
                            }
                        } onFailure: { owner, error in
                            print("error: \(error)")
                        } onDisposed: { owner in
                            print("EditProfileVC NW Disposed")
                        }
                        .disposed(by: owner.disposeBag)
                } else {
                    NetworkManager.shared.editProfile(
                        nickname: editedNickname,
                        introduce: owner.editProfileView.editMyIntroduceTextView.text,
                        profile: Data())
                        .subscribe(with: self) { owner, result in
                            switch result {
                            case .success(let success):
                                input.editedProfileData.onNext(success)
                                owner.okShowAlert(title: "프로필 정보가 변경되었습니다! :)", message: "") { _ in
                                    owner.delegate?.editedProfileData(editedData: success)
                                    owner.navigationController?.popViewController(animated: true)
                                }
                            case .failure(let failure):
                                switch failure {
                                case .accessTokenExpiration:
                                    owner.updateToken()
                                default:
                                    break
                                }
                            }
                        } onFailure: { owner, error in
                            print("error: \(error)")
                        } onDisposed: { owner in
                            print("EditProfileVC NW Disposed")
                        }
                        .disposed(by: owner.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        // 수정된 데이터 값전달
        output.editedProfileData
            .bind(with: self) { owner, value in
                owner.delegate?.editedProfileData(editedData: value)
            }
            .disposed(by: disposeBag)
        
        // 토큰 갱신
        output.tokenExpiredMessage
            .bind(with: self) { owner, _ in
                owner.updateToken()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 1
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func displayImage() {
        let dispatchGroup = DispatchGroup()
        
        var imagesDict = [String : UIImage]()
        
        for (identifier, result) in selections {
            
            dispatchGroup.enter()
            
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            for identifier in self.selectedAssetIdentifiers  {
                guard let image = imagesDict[identifier] else { return }
                selectedImage.onNext(image)
            }
        }
    }
}

// MARK: UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: PHPickerViewControllerDelegate
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        
        var newSelections = [String : PHPickerResult]()
        
        for result in results {
            guard let identifier = result.assetIdentifier else { return }
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if !selections.isEmpty {
            displayImage()
        } else {
            print("사진 없음")
        }
    }
}

protocol EditedProfileDataDelegate: AnyObject {
    func editedProfileData(editedData: EditProfileModel)
}
