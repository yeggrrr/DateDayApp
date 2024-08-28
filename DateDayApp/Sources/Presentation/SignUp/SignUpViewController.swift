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
                                case .alreadySignedUp:
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
                    owner.signUpView.emailValidImageView.tintColor = .primaryLightPink
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
                    titleColor: .white,
                    bgColor: .primaryButtonBg,
                    font: .systemFont(ofSize: 17, weight: .semibold),
                    borderColor: UIColor.clear.cgColor,
                    borderWidth: 2)
            } else {
                owner.signUpView.signUpButton.isEnabled = false
                owner.signUpView.signUpButton.backgroundColor = .primaryCustomLight
                owner.signUpView.signUpButton.setTitleColor(.black, for: .normal)
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
                            case .noSpacesAllowed:
                                self.showToast(message: "닉네임에 공백이 포함되어 있습니다! :)")
                            case .alreadySignedUp:
                                self.okShowAlert(title: "해당 닉네임을 사용할 수 없습니다.", message: "다른 분이 이미 사용중이에요! :)") { _ in
                                    owner.signUpView.nicknameTextField.text = ""
                                }
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
            imageView.tintColor = .primaryCustomLight
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            imageView.tintColor = .primaryLightPink
            imageView.image = UIImage(systemName: "xmark.circle.fill")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
