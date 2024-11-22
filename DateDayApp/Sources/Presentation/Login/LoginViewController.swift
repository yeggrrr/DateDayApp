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
                                         signUpButtonTap: loginView.signUpButton.rx.tap,
                                         emailText: loginView.emailTextField.rx.text.orEmpty,
                                         passwordText: loginView.passwordTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.loginButtonTap
            .withLatestFrom(Observable.combineLatest(input.emailText, input.passwordText))
            .flatMap { value in
                let (email, password) = value
                return NetworkManager.shared.requestUserVerification(api: Router.login(query: LoginQuery(email: email, password: password)), type: LoginModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    UserDefaultsManager.shared.refresh = success.refreshToken
                    UserDefaultsManager.shared.token = success.accessToken
                    UserDefaultsManager.shared.saveTime = DateFormatter.containTimeDateFormatter.string(from: Date())
                    UserDefaultsManager.shared.saveLoginUserID = success.userId
                    let vc = DateDayTabBarController(showLoginAlert: true)
                    self.setRootViewController(vc)
                case .failure(let failure):
                    switch failure {
                    case .missingRequiredValue:
                        owner.showToast(message: "필수값을 채워주세요! :)")
                    case .mismatchOrInvalid:
                        owner.showToast(message: "계정을 확인해주세요! :)")
                    default:
                        break
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
