//
//  SignUpView.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
import SnapKit

final class SignUpView: BaseView {
    private let logoImageView = UIImageView()
    private let inputStackView = UIStackView()
    private let nicknameTextFieldView = UIView()
    private let emailTextFieldView = UIView()
    private let passwordTextFieldView = UIView()
    private let noticeView = UIView()
    private let noticeLabel = UILabel()
    private let regulationsInfoScrollView = UIScrollView()
    private let regulationsInfoContentView = UIView()
    private let regulationsInfoLabel = UILabel()
    private let regulationsLabel = UILabel()
    let nicknameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nicknameValidImageView = UIImageView()
    let emailValidImageView = UIImageView()
    let passwordValidImageView = UIImageView()
    let isSecureTextEntryButton = UIButton()
    let signUpButton = UIButton()
    
    override func addSubviews() {
        addSubviews([logoImageView, inputStackView, signUpButton, nicknameValidImageView, emailValidImageView, passwordValidImageView, regulationsInfoScrollView])
        regulationsInfoScrollView.addSubview(regulationsInfoContentView)
        regulationsInfoContentView.addSubviews([regulationsInfoLabel, regulationsLabel])
        inputStackView.addArrangedSubviews([nicknameTextFieldView, emailTextFieldView, passwordTextFieldView])
        nicknameTextFieldView.addSubview(nicknameTextField)
        emailTextFieldView.addSubview(emailTextField)
        passwordTextFieldView.addSubviews([passwordTextField, isSecureTextEntryButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        let scrollViewFrame = regulationsInfoScrollView.frameLayoutGuide
        let scrollViewContent = regulationsInfoScrollView.contentLayoutGuide
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(40)
            $0.leading.equalTo(safeArea.snp.leading).offset(80)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-50)
            $0.bottom.lessThanOrEqualTo(inputStackView.snp.top).offset(-50)
        }
        
        inputStackView.snp.makeConstraints {
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.centerY.equalTo(safeArea.snp.centerY).offset(-90)
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
            $0.leading.equalTo(passwordTextFieldView.snp.leading).offset(10)
            $0.trailing.equalTo(isSecureTextEntryButton.snp.leading).offset(-10)
        }
        
        isSecureTextEntryButton.snp.makeConstraints {
            $0.trailing.equalTo(passwordTextFieldView.snp.trailing).offset(-10)
            $0.centerY.equalTo(passwordTextFieldView.snp.centerY)
            $0.height.equalTo(20)
            $0.width.equalTo(30)
        }
        
        nicknameValidImageView.snp.makeConstraints {
            $0.leading.equalTo(inputStackView.snp.trailing).offset(5)
            $0.centerY.equalTo(nicknameTextField.snp.centerY)
            $0.width.height.equalTo(20)
        }
        
        emailValidImageView.snp.makeConstraints {
            $0.leading.equalTo(inputStackView.snp.trailing).offset(5)
            $0.centerY.equalTo(emailTextField.snp.centerY)
            $0.width.height.equalTo(20)
        }
        
        passwordValidImageView.snp.makeConstraints {
            $0.leading.equalTo(inputStackView.snp.trailing).offset(5)
            $0.centerY.equalTo(passwordTextField.snp.centerY)
            $0.width.height.equalTo(20)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(44)
            $0.height.equalTo(44)
        }
        
        regulationsInfoScrollView.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(20)
            $0.height.equalTo(190)
        }
        
        regulationsInfoContentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollViewContent.snp.verticalEdges)
            $0.horizontalEdges.equalTo(scrollViewFrame.snp.horizontalEdges)
        }
        
        regulationsInfoLabel.snp.makeConstraints {
            $0.top.equalTo(regulationsInfoContentView.snp.top).offset(5)
            $0.centerX.equalTo(regulationsInfoContentView.snp.centerX)
        }
        
        regulationsLabel.snp.makeConstraints {
            $0.top.equalTo(regulationsInfoLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(regulationsInfoContentView.snp.horizontalEdges).inset(10)
            $0.bottom.equalTo(regulationsInfoContentView.snp.bottom).offset(-10)
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
        
        nicknameTextFieldView.basicUI()
        emailTextFieldView.basicUI()
        passwordTextFieldView.basicUI()
        
        nicknameTextField.setUI(placeholder: "닉네임을 입력해주세요", keyboardType: .asciiCapable)
        emailTextField.setUI(placeholder: "이메일을 입력해주세요", keyboardType: .emailAddress)
        passwordTextField.setUI(placeholder: "비밀번호를 입력해주세요", keyboardType: .asciiCapable)
        passwordTextField.isSecureTextEntry = true
        
        isSecureTextEntryButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        isSecureTextEntryButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        isSecureTextEntryButton.tintColor = .black
        
        signUpButton.roundUI(
            title: "회원가입",
            bgColor: .primaryCustomLight,
            font: .systemFont(ofSize: 17, weight: .semibold),
            borderColor: UIColor.clear.cgColor)
        
        nicknameValidImageView.initialIconUI()
        emailValidImageView.initialIconUI()
        passwordValidImageView.initialIconUI()
        
        regulationsInfoScrollView.signUpUI()
        
        regulationsInfoLabel.setUI(
            txt: "<주의사항>",
            txtAlignment: .center,
            font: .systemFont(ofSize: 17, weight: .semibold),
            txtColor: .black)
        
        regulationsLabel.setUI(
            txt: "[닉네임]\n2글자 이상, 영문 숫자 조합만 가능\n공백 포함 불가능\n[비밀번호]\n8자 이상, 첫 글자는 대문자\n숫자와 특수문자(!, ?, #, *) 조합 가능",
            font: .systemFont(ofSize: 15, weight: .thin),
            txtColor: .black)
        regulationsLabel.setLineSpacing(8)
    }
}
