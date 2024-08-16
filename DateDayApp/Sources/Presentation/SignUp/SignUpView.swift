//
//  SignUpView.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import SnapKit

final class SignUpView: UIView, ViewRepresentable {
    private let inputStackView = UIStackView()
    private let nicknameTextFieldView = UIView()
    private let emailTextFieldView = UIView()
    private let passwordTextFieldView = UIView()
    let nicknameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signUpButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        addSubviews([inputStackView, signUpButton])
        inputStackView.addArrangedSubviews([nicknameTextFieldView, emailTextFieldView, passwordTextFieldView])
        nicknameTextFieldView.addSubview(nicknameTextField)
        emailTextFieldView.addSubview(emailTextField)
        passwordTextFieldView.addSubview(passwordTextField)
    }
    
    func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        inputStackView.snp.makeConstraints {
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.centerY.equalTo(safeArea.snp.centerY).offset(-100)
            $0.horizontalEdges.equalTo(safeArea).inset(50)
            $0.height.equalTo(135)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameTextFieldView.snp.verticalEdges).inset(5)
            $0.horizontalEdges.equalTo(nicknameTextFieldView.snp.horizontalEdges).inset(10)
        }
        
        emailTextField.snp.makeConstraints {
            $0.verticalEdges.equalTo(emailTextFieldView.snp.verticalEdges).inset(5)
            $0.horizontalEdges.equalTo(emailTextFieldView.snp.horizontalEdges).inset(10)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.verticalEdges.equalTo(passwordTextFieldView.snp.verticalEdges).inset(5)
            $0.horizontalEdges.equalTo(passwordTextFieldView.snp.horizontalEdges).inset(10)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(44)
            $0.height.equalTo(44)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        
        inputStackView.axis = .vertical
        inputStackView.distribution = .fillEqually
        inputStackView.alignment = .fill
        inputStackView.spacing = 5
        
        nicknameTextFieldView.layer.borderWidth = 1
        nicknameTextFieldView.layer.borderColor = UIColor.black.cgColor
        nicknameTextField.placeholder = "닉네임을 입력해주세요"
        
        emailTextFieldView.layer.borderWidth = 1
        emailTextFieldView.layer.borderColor = UIColor.black.cgColor
        emailTextField.placeholder = "이메일을 입력해주세요"
        
        passwordTextFieldView.layer.borderWidth = 1
        passwordTextFieldView.layer.borderColor = UIColor.black.cgColor
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 1
    }
}
