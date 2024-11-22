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
    var profileData: ProfileModel?
    var editedProfileData: EditProfileModel?
    
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
            myIntroduceButtonTap: myPageView.myIntroduceButton.rx.tap,
            myPaymentListButtonTap: myPageView.myPaymentListButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        // 프로필 정보 업데이트
        output.profileData
            .bind(with: self) { owner, profileData in
                owner.myPageView.nicknameLabel.text = profileData.nickname
                owner.profileData = profileData
                if let image = profileData.profileImage {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        owner.myPageView.profileImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 프로필 수정 업데이트
        output.editedProfileData
            .bind(with: self) { owner, editedData in
                owner.editedProfileData = editedData
                
                if let image = editedData.profileImage {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        owner.myPageView.profileImageView.image = UIImage(data: data)
                    }
                }
                owner.myPageView.nicknameLabel.text = editedData.nickname
            }
            .disposed(by: disposeBag)
        
        // 프로필 편집
        output.editProfileButtonTap
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                vc.delegate = self
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 로그아웃
        output.logoutButtonTap
            .bind(with: self) { owner, _ in
                owner.okCanelShowAlert(title: "로그아웃 하시겠습니까?", message: "") { _ in
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    owner.setRootViewController(nav)
                }
            }
            .disposed(by: disposeBag)

        // 내 관심 목록
        output.interestButtonTap
            .bind(with: self) { owner, _ in
                let vc = PickedListViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 내 게시물
        output.myPostListButtonTap
            .bind(with: self) { owner, _ in
                let vc = MyPostViewController()
                if let profileData = owner.profileData {
                    vc.viewModel.profileName.onNext(profileData.nickname)
                    vc.viewModel.profileImage.onNext(profileData.profileImage ?? "")
                    
                }
                
                if let editedProfileData = owner.editedProfileData {
                    vc.viewModel.profileName.onNext(editedProfileData.nickname)
                    vc.viewModel.profileImage.onNext(editedProfileData.profileImage ?? "")
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 결제 내역 리스트
        output.myPaymentListButtonTap
            .bind(with: self) { owner, _ in
                let vc = MyPaymentListViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 내 소개
        output.myIntroduceButtonTap
            .withLatestFrom(output.editedIntroduce)
            .bind(with: self) { owner, introduce in
                let vc = MyIntroduceViewController()
                if let introduce = introduce {
                    vc.introduceText.onNext(introduce)
                }
                
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 토큰 갱신
        output.tokenExpiredMessage
            .bind(with: self) { owner, _ in
                owner.updateToken { newToken in
                    UserDefaultsManager.shared.token = newToken
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupMenu() -> UIBarButtonItem {
        var item: [UIAction] {
            let withdraw = UIAction(
                title: "탈퇴하기",
                image: UIImage(systemName: "minus.circle"),
                handler: { _ in
                    self.okCanelShowAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?") { _ in
                        NetworkManager.shared.callRequest(api: Router.withdraw, type: WithdrawModel.self)
                            .subscribe(with: self) { owner, result in
                                switch result {
                                case .success(_):
                                    let nav = UINavigationController(rootViewController: LoginViewController())
                                    owner.setRootViewController(nav)
                                case .failure(let failure):
                                    switch failure {
                                    case .refreshTokenExpiration:
                                        let nav = UINavigationController(rootViewController: LoginViewController())
                                        owner.setRootViewController(nav)
                                    default:
                                        break
                                    }
                                }
                            } onFailure: { owner, error in
                                print("error: \(error)")
                            } onDisposed: { owner in
                                print("MyPageVC withdraw Disposed")
                            }
                            .disposed(by: self.disposeBag)
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
        viewModel.editedIntroduce.onNext(editedData.myIntroduce)
    }
}
