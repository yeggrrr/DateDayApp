//
//  EditProfileView.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    private let profileImageStackView = UIStackView()
    private let setProfileImageBgView = UIView()
    private let defaultImageView = UIImageView()
    private let setProfileImageTextLabel = UILabel()
    let profileImageView = UIImageView()
    let setProfileImageButton = UIButton(type: .system)
    let setDefaultImageButton = UIButton(type: .system)
    
    private let elementsTextStackView = UIStackView()
    private let nicknameTextLabel = UILabel()
    private let emailTextLabel = UILabel()
    private let myIntroduceTextLabel = UILabel()
    
    private let elementsStackView = UIStackView()
    let nicknameTextField = UITextField()
    let emailLabel = UILabel()
    
    private let editMyIntroduceView = UIView()
    let editMyIntroduceTextView = UITextView()
    
    let editingCompleteButton = UIButton()
    
    override func addSubviews() {
        addSubviews([profileImageStackView, setProfileImageBgView, setProfileImageButton, setDefaultImageButton, setProfileImageTextLabel, elementsTextStackView, elementsStackView, editMyIntroduceView, editingCompleteButton])
        profileImageStackView.addArrangedSubviews([profileImageView, defaultImageView])
        elementsTextStackView.addArrangedSubviews([nicknameTextLabel, emailTextLabel, myIntroduceTextLabel])
        elementsStackView.addArrangedSubviews([nicknameTextField, emailLabel])
        editMyIntroduceView.addSubview(editMyIntroduceTextView)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        profileImageStackView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(20)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.height.equalTo(90)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        setProfileImageBgView.snp.makeConstraints {
            $0.edges.equalTo(profileImageView.snp.edges)
        }
        
        setProfileImageButton.snp.makeConstraints {
            $0.edges.equalTo(profileImageView.snp.edges)
        }
        
        setDefaultImageButton.snp.makeConstraints {
            $0.edges.equalTo(defaultImageView.snp.edges)
        }
        
        setProfileImageTextLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(20)
        }
        
        elementsTextStackView.snp.makeConstraints {
            $0.top.equalTo(setProfileImageTextLabel.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea.snp.leading).offset(30)
            $0.width.equalTo(55)
        }
        
        elementsStackView.snp.makeConstraints {
            $0.top.equalTo(setProfileImageTextLabel.snp.bottom).offset(30)
            $0.leading.equalTo(elementsTextStackView.snp.trailing).offset(20)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-30)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(nicknameTextLabel.snp.height)
        }
        
        emailLabel.snp.makeConstraints {
            $0.height.equalTo(emailTextLabel.snp.height)
        }
        
        editMyIntroduceView.snp.makeConstraints {
            $0.top.equalTo(elementsStackView.snp.bottom).offset(11)
            $0.leading.equalTo(elementsTextStackView.snp.trailing).offset(10)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-30)
            $0.height.equalTo(120)
        }
        
        editMyIntroduceTextView.snp.makeConstraints {
            $0.edges.equalTo(editMyIntroduceView.snp.edges).inset(5)
        }
        
        editingCompleteButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-50)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(100)
        }
    }
    
    override func configureUI() {
        backgroundColor = .white
        
        profileImageStackView.axis = .horizontal
        profileImageStackView.spacing = 10
        profileImageStackView.distribution = .fillEqually
        
        elementsTextStackView.axis = .vertical
        elementsTextStackView.spacing = 16
        elementsTextStackView.distribution = .fillEqually
        
        elementsStackView.axis = .vertical
        elementsStackView.spacing = 16
        
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = 45
        profileImageView.layer.masksToBounds = true
        
        defaultImageView.image = UIImage(named: "defaultProfileImage")
        defaultImageView.layer.borderWidth = 1.5
        defaultImageView.layer.borderColor = UIColor.black.cgColor
        defaultImageView.layer.cornerRadius = 45
        defaultImageView.layer.masksToBounds = true
        
        setProfileImageBgView.backgroundColor = .darkGray
        setProfileImageBgView.layer.cornerRadius = 45
        setProfileImageBgView.layer.opacity = 0.3
        
        setProfileImageTextLabel.setUI(
            txt: "사진 변경 또는 기본이미지 설정",
            txtAlignment: .center,
            font: .systemFont(ofSize: 13, weight: .regular),
            numOfLines: 1,
            txtColor: .black)
        
        setProfileImageButton.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        setProfileImageButton.tintColor = .darkGray
        
        setDefaultImageButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        setDefaultImageButton.tintColor = .lightGray
        
        nicknameTextLabel.setUI(
            txt: "닉네임",
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        emailTextLabel.setUI(
            txt: "이메일",
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        myIntroduceTextLabel.setUI(
            txt: "내 소개",
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        nicknameTextField.textColor = .darkGray
        nicknameTextField.textAlignment = .left
        nicknameTextField.font = .systemFont(ofSize: 15, weight: .regular)
        
        // nicknameLabel.setUI(
        //     txtAlignment: .left,
        //     font: .systemFont(ofSize: 15, weight: .regular),
        //     numOfLines: 1,
        //     txtColor: .darkGray)
        
        emailLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        editMyIntroduceTextView.textAlignment = .left
        editMyIntroduceTextView.font = .systemFont(ofSize: 15, weight: .regular)
        editMyIntroduceTextView.textColor = .darkGray
        
        editingCompleteButton.setTitle("편집 완료", for: .normal)
        editingCompleteButton.setTitleColor(.primaryDark, for: .normal)
        editingCompleteButton.setTitleColor(.white, for: .highlighted)
    }
}
