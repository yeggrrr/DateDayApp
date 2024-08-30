//
//  EditProfileViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProfileViewController: UIViewController {
    // MARK: UI
    let editProfileView = EditProfileView()
    
    // MARK: Properties
    let viewModel = EditProfileViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let input = EditProfileViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.profileData
            .bind(with: self) { owner, profileData in
                owner.editProfileView.nicknameLabel.text = profileData.nickname
                owner.editProfileView.emailLabel.text = profileData.email
                owner.editProfileView.myIntroduceLabel.text = profileData.myIntroduce
                
                if let image = profileData.profileImage {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        owner.editProfileView.profileImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.tokenExpiredMessage
            .bind(with: self) { owner, _ in
                owner.updateToken()
            }
            .disposed(by: disposeBag)
    }
    
}
