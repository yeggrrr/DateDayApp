//
//  SignUpViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    // MARK: UI
    private let signUpView = SignUpView()
    
    // MARK: Properties
    private let viewModel = SignUpViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // MARK: Functions
    private func bind() {
        let input = SignUpViewModel.Input(
            signUpButtonTap: signUpView.signUpButton.rx.tap,
            nicknameText: signUpView.nicknameTextField.rx.text,
            emailText: signUpView.emailTextField.rx.text,
            passwordText: signUpView.passwordTextField.rx.text)
        
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(
            output.nicknameValidation,
            output.emailValidation,
            output.passwordValidation)
        .bind(with: self) { owner, value in
            if value.0 && value.1 && value.2 {
                owner.signUpView.signUpButton.isEnabled = true
                owner.signUpView.signUpButton.backgroundColor = .primaryCustom
            } else {
                owner.signUpView.signUpButton.isEnabled = false
                owner.signUpView.signUpButton.backgroundColor = .white
            }
        }
        .disposed(by: disposeBag)
        
        if let nickname = signUpView.nicknameTextField.text,
           let email = signUpView.emailTextField.text,
           let password = signUpView.passwordTextField.text {
            output.signUpButtonTap
                .bind(with: self) { owner, _ in
                    NetworkManager.shared.createSignUp(
                        nickname: nickname,
                        email: email,
                        password: password)
                    print("회원가입 버튼 클릭됨")
                }
                .disposed(by: disposeBag)
        }
    }
}
