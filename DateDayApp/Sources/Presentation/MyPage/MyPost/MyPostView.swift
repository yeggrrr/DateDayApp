//
//  MyPostView.swift
//  DateDayApp
//
//  Created by YJ on 9/1/24.
//

import UIKit
import SnapKit

final class MyPostView: BaseView {
    private let userInfoView = UIView()
    let userProfileImageView = UIImageView()
    let userNameLabel = UILabel()
    private let dividerView = UIView()
    let myPostTableView = UITableView()
    let noticeLabel = UILabel()
    
    override func draw(_ rect: CGRect) {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
    }
    
    override func addSubviews() {
        addSubviews([userInfoView, userProfileImageView, userNameLabel, dividerView, myPostTableView, noticeLabel])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        userInfoView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
            $0.height.equalTo(50)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.leading.equalTo(userInfoView.snp.leading).offset(16)
            $0.verticalEdges.equalTo(userInfoView).inset(5)
            $0.width.equalTo(userProfileImageView.snp.height)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageView.snp.centerY)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(5)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
            $0.height.equalTo(1)
        }
        
        myPostTableView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.center.equalTo(safeArea.snp.center)
        }
    }
    
    override func configureUI() {
        backgroundColor = .white
        
        userProfileImageView.image = UIImage(resource: .defaultProfile)
        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.contentMode = .scaleAspectFill
        
        userNameLabel.setUI(
            txt: "임시 닉네임",
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        dividerView.backgroundColor = .lightGray
        
        noticeLabel.setUI(
            txt: "작성한 게시물이 없습니다.",
            txtAlignment: .center,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
    }
}
