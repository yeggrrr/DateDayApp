//
//  LoginView.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import SnapKit

final class LoginView: UIView, ViewRepresentable {
    let inputStackView = UIStackView()
    let emailTextFieldView = UIView()
    let emailTextField = UITextField()
    let passwordTextFieldView = UIView()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let signUpButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        addSubviews([inputStackView, loginButton, signUpButton])
        inputStackView.addArrangedSubviews([emailTextFieldView, passwordTextFieldView])
        emailTextFieldView.addSubview(emailTextField)
        passwordTextFieldView.addSubview(passwordTextField)
    }
    
    func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
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
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.trailing.equalTo(loginButton.snp.trailing).offset(-5)
            $0.height.equalTo(20)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        
        inputStackView.axis = .vertical
        inputStackView.distribution = .fillEqually
        inputStackView.alignment = .fill
        inputStackView.spacing = 5
        
        emailTextFieldView.layer.borderWidth = 1
        emailTextFieldView.layer.borderColor = UIColor.black.cgColor
        emailTextField.placeholder = "이메일을 입력해주세요"
        
        passwordTextFieldView.layer.borderWidth = 1
        passwordTextFieldView.layer.borderColor = UIColor.black.cgColor
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 1
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
    }
}

