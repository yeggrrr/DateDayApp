//
//  MyPageView.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import UIKit
import SnapKit

final class MyPageView: BaseView {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let myIntroduceButton = UIButton(type: .system)
    private let dividerView = UIView()
    private let topButtonStackView = UIStackView()
    let editProfileButton = UIButton()
    let logoutButton = UIButton()
    
    private let myInterestListStackView = UIStackView()
    private let myInterestBgView = UIView()
    private let myInterestListView = UIView()
    private let myInterestListIconImageView = UIImageView()
    private let myInterestListTextLabel = UILabel()
    let myInterestListButton = UIButton()
    
    private let myPostListStackView = UIStackView()
    private let myPostListBgView = UIView()
    private let myPostListView = UIView()
    private let myPostListIconImageView = UIImageView()
    private let myPostListTextLabel = UILabel()
    let myPostListButton = UIButton()
    
    private let myPaymentListStackView = UIStackView()
    private let myPaymentListBgView = UIView()
    private let myPaymentListView = UIView()
    private let myPaymentListIconImageView = UIImageView()
    private let myPaymentListTextLabel = UILabel()
    let myPaymentListButton = UIButton()
    
    override func addSubviews() {
        addSubviews([
            profileImageView, nicknameLabel, myIntroduceButton, dividerView,
            myInterestBgView, myPostListBgView, myPaymentListBgView,
            topButtonStackView,
            myInterestListStackView, myInterestListButton,
            myPostListStackView, myPostListButton,
            myPaymentListStackView, myPaymentListButton
        ])
        
        myInterestListStackView.addArrangedSubviews([myInterestListView, myInterestListTextLabel])
        myInterestListView.addSubview(myInterestListIconImageView)
        
        myPostListStackView.addArrangedSubviews([myPostListView, myPostListTextLabel])
        myPostListView.addSubview(myPostListIconImageView)
        
        myPaymentListStackView.addArrangedSubviews([myPaymentListView, myPaymentListTextLabel])
        myPaymentListView.addSubview(myPaymentListIconImageView)
        
        topButtonStackView.addArrangedSubviews([editProfileButton, logoutButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.height.width.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.height.equalTo(30)
        }
        
        myIntroduceButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(nicknameLabel.snp.centerY)
            $0.width.height.equalTo(40)
        }
        
        topButtonStackView.snp.makeConstraints {
            $0.top.equalTo(myIntroduceButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(20)
            $0.height.equalTo(30)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(topButtonStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(2)
            $0.height.equalTo(1)
        }
        
        myInterestListStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(safeArea.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        myInterestListButton.snp.makeConstraints {
            $0.leading.equalTo(myInterestListStackView.snp.leading)
            $0.verticalEdges.equalTo(myInterestListStackView.snp.verticalEdges)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-20)
        }
        
        myInterestBgView.snp.makeConstraints {
            $0.edges.equalTo(myInterestListButton.snp.edges)
        }
        
        myInterestListView.snp.makeConstraints {
            $0.width.equalTo(myInterestListView.snp.height)
        }
        
        myInterestListIconImageView.snp.makeConstraints {
            $0.edges.equalTo(myInterestListView.snp.edges).inset(10)
        }
        
        myPostListStackView.snp.makeConstraints {
            $0.top.equalTo(myInterestListButton.snp.bottom).offset(16)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(safeArea.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        myPostListView.snp.makeConstraints {
            $0.width.equalTo(myPostListView.snp.height)
        }
        
        myPostListIconImageView.snp.makeConstraints {
            $0.edges.equalTo(myPostListView.snp.edges).inset(10)
        }
        
        myPostListButton.snp.makeConstraints {
            $0.leading.equalTo(myPostListStackView.snp.leading)
            $0.verticalEdges.equalTo(myPostListStackView.snp.verticalEdges)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-20)
        }
        
        myPostListBgView.snp.makeConstraints {
            $0.edges.equalTo(myPostListButton.snp.edges)
        }
        
        myPaymentListStackView.snp.makeConstraints {
            $0.top.equalTo(myPostListButton.snp.bottom).offset(16)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(safeArea.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        myPaymentListView.snp.makeConstraints {
            $0.width.equalTo(myPaymentListView.snp.height)
        }
        
        myPaymentListIconImageView.snp.makeConstraints {
            $0.edges.equalTo(myPaymentListView.snp.edges).inset(10)
        }
        
        myPaymentListButton.snp.makeConstraints {
            $0.leading.equalTo(myPaymentListStackView.snp.leading)
            $0.verticalEdges.equalTo(myPaymentListStackView.snp.verticalEdges)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-20)
        }
        
        myPaymentListBgView.snp.makeConstraints {
            $0.edges.equalTo(myPaymentListButton.snp.edges)
        }
    }

    override func configureUI() {
        backgroundColor = .white
        
        profileImageView.image = UIImage(resource: .defaultProfile)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.black.cgColor
        
        nicknameLabel.setUI(
            txtAlignment: .center,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        myIntroduceButton.setImage(UIImage(systemName: "lasso.badge.sparkles"), for: .normal)
        myIntroduceButton.tintColor = .black
        
        topButtonStackView.axis = .horizontal
        topButtonStackView.distribution = .fillEqually
        topButtonStackView.spacing = 7
        
        editProfileButton.setTitle("프로필 편집", for: .normal)
        editProfileButton.setTitleColor(.black, for: .normal)
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.layer.borderWidth = 1.5
        editProfileButton.layer.cornerRadius = 5
        
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.layer.borderColor = UIColor.black.cgColor
        logoutButton.layer.borderWidth = 1.5
        logoutButton.layer.cornerRadius = 5
        
        dividerView.backgroundColor = .black
        
        myInterestListStackView.axis = .horizontal
        myPostListStackView.axis = .horizontal
        myPaymentListStackView.axis = .horizontal
        
        myInterestListStackView.spacing = 5
        myPostListStackView.spacing = 5
        myPaymentListStackView.spacing = 5
        
        myInterestBgView.backgroundColor = .primaryCustomLight
        myPostListBgView.backgroundColor = .primaryCustomLight
        myPaymentListBgView.backgroundColor = .primaryCustomLight
        
        myInterestBgView.layer.cornerRadius = 5
        myPostListBgView.layer.cornerRadius = 5
        myPaymentListBgView.layer.cornerRadius = 5
        
        myInterestListIconImageView.image = UIImage(systemName: "bookmark.fill")
        myInterestListIconImageView.tintColor = .white
        myInterestListTextLabel.text = "내 관심목록"
        myInterestListTextLabel.textAlignment = .left
        
        myPostListIconImageView.image = UIImage(systemName: "pencil.and.scribble")
        myPostListIconImageView.tintColor = .white
        myPostListTextLabel.text = "내 게시물"
        myPostListTextLabel.textAlignment = .left
        
        myPaymentListIconImageView.image = UIImage(systemName: "list.clipboard.fill")
        myPaymentListIconImageView.tintColor = .white
        myPaymentListTextLabel.text = "공방 결제 내역 리스트"
        myPaymentListTextLabel.textAlignment = .left
    }
}
