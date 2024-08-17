//
//  LoginViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    // MARK: UI
    private let loginView = LoginView()
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    // MARK: Functions
    private func configure() {
        // navigationItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func bind() {
        let input = LoginViewModel.Input(loginButtonTap: loginView.loginButton.rx.tap,
                                         signUpButtonTap: loginView.signUpButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.loginButtonTap
            .bind(with: self) { owner, _ in
                print("loginButton Clicked")
            }
            .disposed(by: disposeBag)
        
        output.signUpButtonTap
            .bind(with: self) { owner, _ in
                let vc = SignUpViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
