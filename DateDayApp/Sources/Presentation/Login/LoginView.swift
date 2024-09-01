//
//  LoginView.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    // MARK: UI
    private let logoImageView = UIImageView()
    private let inputStackView = UIStackView()
    private let emailTextFieldView = UIView()
    private let passwordTextFieldView = UIView()
    private let signUpLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let signUpButton = UIButton(type: .system)
    
    // MARK: Functions
    override func addSubviews() {
        addSubviews([logoImageView, inputStackView, loginButton, signUpButton, signUpLabel])
        inputStackView.addArrangedSubviews([emailTextFieldView, passwordTextFieldView])
        emailTextFieldView.addSubview(emailTextField)
        passwordTextFieldView.addSubview(passwordTextField)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(50)
            $0.leading.equalTo(safeArea.snp.leading).offset(80)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-50)
            $0.bottom.lessThanOrEqualTo(inputStackView.snp.top).offset(-50)
        }
        
        inputStackView.snp.makeConstraints {
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.centerY.equalTo(safeArea.snp.centerY).offset(-100)
            $0.horizontalEdges.equalTo(safeArea).inset(50)
            $0.height.equalTo(90)
        }
        
        emailTextField.snp.makeConstraints {
            $0.verticalEdges.equalTo(emailTextFieldView.snp.verticalEdges).inset(5)
            $0.horizontalEdges.equalTo(emailTextFieldView.snp.horizontalEdges).inset(10)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.verticalEdges.equalTo(passwordTextFieldView.snp.verticalEdges).inset(5)
            $0.horizontalEdges.equalTo(passwordTextFieldView.snp.horizontalEdges).inset(10)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(44)
            $0.height.equalTo(44)
        }
        
        signUpLabel.snp.makeConstraints {
            $0.trailing.equalTo(signUpButton.snp.leading).offset(-10)
            $0.centerY.equalTo(signUpButton.snp.centerY)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.trailing.equalTo(loginButton.snp.trailing).offset(-5)
            $0.height.equalTo(20)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        logoImageView.image = UIImage(resource: .mainLogo)
        
        inputStackView.setUI(
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .fill,
            spacing: 5)
        
        emailTextFieldView.basicUI()
        passwordTextFieldView.basicUI()
        emailTextField.placeholder = "이메일을 입력해주세요"
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        
        signUpLabel.setUI(
            txt: "처음 방문하시나요?",
            txtAlignment: .center,
            font: .systemFont(ofSize: 16, weight: .semibold),
            txtColor: .black)
        
        loginButton.roundUI(
            title: "로그인",
            bgColor: .primaryCustomLight,
            font: .systemFont(ofSize: 17, weight: .semibold),
            borderColor: UIColor.clear.cgColor,
            borderWidth: 2)
        
        signUpButton.basicUI(title: "회원가입", color: .primaryDark)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        emailTextField.text = "yeggrrr@yegr.com"
        passwordTextField.text = "Yeggrrr123"
        
        /*
         dummy id(1)
         yeggrrr@yegr.com / Yeggrrr123
         dummy id(2)
         keenLover@yegr.com / KeenLover123
         test id
         yegryegr@yegr.com / Yegryegr123
         */
    }
}
