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
                guard let email = owner.loginView.emailTextField.text,
                      let password = owner.loginView.passwordTextField.text else { return }
                
                NetworkManager.shared.createLogin(
                    email: email,
                    password: password) { result in
                        switch result {
                        case .success(let success):
                            UserDefaultsManager.shared.refresh = success.refreshToken
                            UserDefaultsManager.shared.token = success.accessToken
                            self.setRootViewController(FeedViewController())
                        case .failure(let failure):
                            switch failure {
                            case .missingRequiredValue:
                                self.showToast(message: "필수값을 채워주세요! :)")
                            case .accountVerificationRequired:
                                self.showToast(message: "계정을 확인해주세요! :)")
                            default:
                                break
                            }
                        }
                    }
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
