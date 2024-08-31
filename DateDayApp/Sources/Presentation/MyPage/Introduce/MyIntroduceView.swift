//
//  MyIntroduceView.swift
//  DateDayApp
//
//  Created by YJ on 8/31/24.
//

import UIKit
import SnapKit

final class MyIntroduceView: BaseView {
    private let bgView = UIView()
    private let speechBubbleImageView = UIImageView()
    private let introduceBgView = UIView()
    let introduceLabel = UILabel()
    
    override func addSubviews() {
        addSubviews([bgView, speechBubbleImageView, introduceBgView, introduceLabel])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.centerY.equalTo(safeArea.snp.centerY).offset(-80)
            $0.leading.equalTo(safeArea.snp.leading).offset(20)
            $0.height.width.equalTo(280)
        }
        
        speechBubbleImageView.snp.makeConstraints {
            $0.edges.equalTo(bgView.snp.edges)
        }
        
        introduceBgView.snp.makeConstraints {
            $0.top.equalTo(speechBubbleImageView.snp.top).offset(115)
            $0.leading.equalTo(speechBubbleImageView.snp.leading).offset(40)
            $0.trailing.equalTo(speechBubbleImageView.snp.trailing).offset(-30)
            $0.bottom.equalTo(speechBubbleImageView.snp.bottom).offset(-65)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.edges.equalTo(introduceBgView.snp.edges).inset(5)
        }
    }
    
    override func configureUI() {
        backgroundColor = .clear
        
        speechBubbleImageView.image = UIImage(named: "bubbleImage")
        speechBubbleImageView.contentMode = .scaleAspectFit
        introduceLabel.setUI(
            txtAlignment: .center,
            font: .systemFont(ofSize: 13, weight: .semibold),
            numOfLines: 0,
            txtColor: .black)
    }
}
