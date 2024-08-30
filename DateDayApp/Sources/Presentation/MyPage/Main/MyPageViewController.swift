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
            editProfileButtonTap: myPageView.editProfileButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
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
