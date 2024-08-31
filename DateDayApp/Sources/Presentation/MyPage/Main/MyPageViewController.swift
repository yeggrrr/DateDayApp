//
//  MyPageViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    // MARK: UI
    private let myPageView = MyPageView()
    
    // MARK: Properties
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        // navigatation
        navigationItem.rightBarButtonItem = setupMenu()
        navigationItem.title = "마이페이지"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func bind() {
        let input = MyPageViewModel.Input(
            interestButtonTap: myPageView.myInterestListButton.rx.tap,
            editProfileButtonTap: myPageView.editProfileButton.rx.tap,
            logoutButtonTap: myPageView.logoutButton.rx.tap,
            myPostListButtonTap: myPageView.myPostListButton.rx.tap,
            myIntroduceButtonTap: myPageView.myIntroduceButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.profileData
            .bind(with: self) { owner, profileData in
                owner.myPageView.nicknameLabel.text = profileData.nickname

                if let image = profileData.profileImage {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        owner.myPageView.profileImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.editedProfileData
            .bind(with: self) { owner, editedData in
                if let image = editedData.profileImage {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        owner.myPageView.profileImageView.image = UIImage(data: data)
                    }
                }
                owner.myPageView.nicknameLabel.text = editedData.nickname
            }
            .disposed(by: disposeBag)
        
        output.editProfileButtonTap
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                vc.delegate = self
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.logoutButtonTap
            .bind(with: self) { owner, _ in
                owner.okShowAlert(title: "로그아웃 하시겠습니까?", message: "") { _ in
                    owner.setRootViewController(LoginViewController())
                }
            }
            .disposed(by: disposeBag)

        output.interestButtonTap
            .bind(with: self) { owner, _ in
                let vc = PickedListViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.myPostListButtonTap
            .bind(with: self) { owner, _ in
                print("myPostListButtonTap")
            }
            .disposed(by: disposeBag)
        
        output.myIntroduceButtonTap
            .withLatestFrom(output.profileData)
            .bind(with: self) { owner, editedModel in
                print("클릭됨")
                let vc = MyIntroduceViewController()
                if let myIntroduce = editedModel.myIntroduce {
                    vc.introduceText.onNext(myIntroduce)
                }
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.tokenExpiredMessage
            .bind(with: self) { owner, _ in
                owner.updateToken()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupMenu() -> UIBarButtonItem {
        var item: [UIAction] {
            let withdraw = UIAction(
                title: "탈퇴하기",
                image: UIImage(systemName: "minus.circle"),
                handler: { _ in
                    self.okShowAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?") { _ in
                        // 탈퇴 API
                    }
                })
            
            let item = [withdraw]
            return item
        }
        
        let menu = UIMenu(title: "설정", children: item)
        
        let barButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "gearshape.fill"), primaryAction: nil, menu: menu)
        barButton.tintColor = .black

        return barButton
    }
}

extension MyPageViewController: EditedProfileDataDelegate {
    func editedProfileData(editedData: EditProfileModel) {
        viewModel.editedProfileData.onNext(editedData)
    }
}
