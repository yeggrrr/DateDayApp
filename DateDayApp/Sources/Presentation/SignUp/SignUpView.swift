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
    let signUpButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        addSubviews([inputStackView, signUpButton, nicknameValidImageView, emailValidImageView, passwordValidImageView, regulationsInfoScrollView])
        regulationsInfoScrollView.addSubview(regulationsInfoContentView)
        regulationsInfoContentView.addSubviews([regulationsInfoLabel, regulationsLabel])
        inputStackView.addArrangedSubviews([nicknameTextFieldView, emailTextFieldView, passwordTextFieldView])
        nicknameTextFieldView.addSubview(nicknameTextField)
        emailTextFieldView.addSubview(emailTextField)
        passwordTextFieldView.addSubview(passwordTextField)
    }
    
    func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        let scrollViewFrame = regulationsInfoScrollView.frameLayoutGuide // horizontalEdges
        let scrollViewContent = regulationsInfoScrollView.contentLayoutGuide // verticalEdges
        
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
            $0.height.equalTo(150)
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
            $0.top.equalTo(regulationsInfoLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(regulationsInfoContentView.snp.horizontalEdges).inset(10)
            $0.bottom.equalTo(regulationsInfoContentView.snp.bottom).offset(-10)
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
        nicknameTextField.keyboardType = .asciiCapable
        
        emailTextFieldView.layer.borderWidth = 1
        emailTextFieldView.layer.borderColor = UIColor.black.cgColor
        emailTextField.placeholder = "이메일을 입력해주세요"
        emailTextField.keyboardType = .emailAddress
        
        passwordTextFieldView.layer.borderWidth = 1
        passwordTextFieldView.layer.borderColor = UIColor.black.cgColor
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        passwordTextField.keyboardType = .asciiCapable
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 1
        
        nicknameValidImageView.tintColor = .systemRed
        emailValidImageView.tintColor = .systemRed
        passwordValidImageView.tintColor = .systemRed
        nicknameValidImageView.image = UIImage(systemName: "xmark.circle.fill")
        emailValidImageView.image = UIImage(systemName: "xmark.circle.fill")
        passwordValidImageView.image = UIImage(systemName: "xmark.circle.fill")
        
        regulationsInfoScrollView.backgroundColor = .systemGray6
        regulationsInfoScrollView.layer.borderWidth = 1
        regulationsInfoScrollView.layer.borderColor = UIColor.darkGray.cgColor
        regulationsInfoScrollView.showsVerticalScrollIndicator = false
        
        regulationsInfoLabel.text = "<주의사항>"
        regulationsInfoLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        regulationsLabel.text = "[닉네임]\n2글자 이상, 영문 숫자 조합만 가능\n[비밀번호]\n첫 글자는 대문자, 숫자와 특수문자(!, ?, #, *) 조합 가능"
        regulationsLabel.numberOfLines = 0
        regulationsLabel.font = .systemFont(ofSize: 15, weight: .thin)
        regulationsLabel.setLineSpacing(8)
    }
}
