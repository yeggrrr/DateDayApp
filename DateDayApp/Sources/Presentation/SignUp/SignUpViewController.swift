//
//  SignUpViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: KeyboardDismiss / Nickname 중복 UI 변경 / 반복 코드 처리
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
        
        output.nicknameValidation
            .bind(with: self) { owner, value in
                owner.updateCheckIcon(isValid: value, imageView: owner.signUpView.nicknameValidImageView)
            }
            .disposed(by: disposeBag)
        
        output.emailValidation
            .bind(with: self) { owner, value in
                guard let emailText = owner.signUpView.emailTextField.text else { return }
                if value {
                    NetworkManager.shared.validationEmail(email: emailText)
                        .subscribe(with: self) { owner, result in
                            switch result {
                            case .success(_):
                                owner.updateCheckIcon(isValid: true, imageView: owner.signUpView.emailValidImageView)
                            case .failure(let failure):
                                owner.updateCheckIcon(isValid: false, imageView: owner.signUpView.emailValidImageView)
                                switch failure {
                                case .missingRequiredValue:
                                    self.showToast(message: "필수값을 입력해주세요.")
                                case .unavailable:
                                    self.showToast(message: "사용이 불가능한 이메일입니다.")
                                default:
                                    break
                                }
                            }
                        } onFailure: { owner, error in
                            print("Failed:: \(error)")
                        } onDisposed: { owner in
                            print("Disposed")
                        }
                        .disposed(by: owner.disposeBag)
                } else {
                    owner.signUpView.emailValidImageView.tintColor = .systemRed
                    owner.signUpView.emailValidImageView.image = UIImage(systemName: "xmark.circle.fill")
                }
            }
            .disposed(by: disposeBag)
        
        output.passwordValidation
            .bind(with: self) { owner, value in
                owner.updateCheckIcon(isValid: value, imageView: owner.signUpView.passwordValidImageView)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.nicknameValidation,
            output.emailValidation,
            output.passwordValidation)
        .bind(with: self) { owner, value in
            if value.0 && value.1 && value.2 {
                owner.signUpView.signUpButton.isEnabled = true
                owner.signUpView.signUpButton.roundUI(
                    title: "회원가입",
                    bgColor: .primaryButtonBg,
                    borderColor: UIColor.primaryBorder.cgColor,
                    borderWidth: 3)
            } else {
                owner.signUpView.signUpButton.isEnabled = false
                owner.signUpView.signUpButton.backgroundColor = .white
            }
        }
        .disposed(by: disposeBag)
        
        output.signUpButtonTap
            .bind(with: self) { owner, _ in
                guard let nickname = owner.signUpView.nicknameTextField.text,
                      let email = owner.signUpView.emailTextField.text,
                      let password = owner.signUpView.passwordTextField.text else { return }
                NetworkManager.shared.createSignUp(nickname: nickname, email: email, password: password)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(_):
                            self.okShowAlert(title: "회원가입이 완료되었습니다.", message: "") { _ in
                                self.setRootViewController(LoginViewController())
                            }
                        case .failure(let failure):
                            switch failure {
                            case .missingRequiredValue:
                                self.showToast(message: "필수값을 채워주세요! :)")
                            case .nicknamesContainingSpaces:
                                self.showToast(message: "닉네임에 공백이 포함되어 있습니다! :)")
                            case .alreadySignedUp:
                                self.showToast(message: "이미 가입한 유저입니다. :)")
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("Failed:: \(error)")
                    } onDisposed: { owner in
                        print("Disposed")
                    }
                    .disposed(by: owner.disposeBag)

            }
            .disposed(by: disposeBag)
    }
    
    func updateCheckIcon(isValid: Bool, imageView: UIImageView) {
        if isValid {
            imageView.tintColor = .systemGreen
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            imageView.tintColor = .systemRed
            imageView.image = UIImage(systemName: "xmark.circle.fill")
        }
    }
}
