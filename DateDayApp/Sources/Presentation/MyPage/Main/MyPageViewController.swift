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
        let a = output.profileData
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

        
        output.interestButtonTap
            .bind(with: self) { owner, _ in
                let vc = PickedListViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.editProfileButtonTap
            .bind(with: self) { owner, _ in
                let vc = EditProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.logoutButtonTap
            .bind(with: self) { owner, _ in
                print("logoutButtonTap")
            }
            .disposed(by: disposeBag)
        
        output.myPostListButtonTap
            .bind(with: self) { owner, _ in
                print("myPostListButtonTap")
            }
            .disposed(by: disposeBag)
        
        output.myIntroduceButtonTap
            .bind(with: self) { owner, _ in
                print("myIntroduceButtonTap")
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
                print("클릭됨")
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
