//
//  WriteView.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import SnapKit
import Cosmos

final class WriteView: BaseView {
    // MARK: UI
    private let titleView = UIView()
    let titleLabel = UILabel()
    let searchLocationButton = UIButton()
    let reviewTextView = UITextView()
    let hashTagNoticeLabel = UILabel()
    let hashTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let starRatingLabel = UILabel()
    let starRatingView = CosmosView()
    let ratingLabel = UILabel()
    
    // MARK: Properties
    let placeholder = "방문 후기를 작성해주세요! :)"
    
    override func addSubviews() {
        addSubviews([titleView, searchLocationButton, reviewTextView, hashTagNoticeLabel, hashTagCollectionView, starRatingLabel, starRatingView, ratingLabel])
        titleView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.leading.equalTo(safeArea.snp.leading).offset(30)
            $0.trailing.equalTo(searchLocationButton.snp.leading).offset(-5)
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(titleView.snp.edges).inset(5)
        }
        
        searchLocationButton.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.top)
            $0.leading.equalTo(titleView.snp.trailing).offset(5)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-30)
            $0.height.equalTo(titleView.snp.height)
            $0.width.equalTo(80)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(30)
            $0.height.equalTo(280)
        }
        
        hashTagNoticeLabel.snp.makeConstraints {
            $0.top.equalTo(reviewTextView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(30)
            $0.height.equalTo(30)
        }
        
        hashTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(hashTagNoticeLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(30)
            $0.height.equalTo(120)
        }
        
        starRatingLabel.snp.makeConstraints {
            $0.top.equalTo(hashTagCollectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(30)
            $0.height.equalTo(30)
        }
        
        starRatingView.snp.makeConstraints {
            $0.top.equalTo(starRatingLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.bottom.lessThanOrEqualTo(safeArea.snp.bottom).offset(-10)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.centerY.equalTo(starRatingView.snp.centerY)
            $0.leading.equalTo(starRatingView.snp.trailing).offset(5)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-30)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        searchLocationButton.squareUI(
            bgColor: .primaryCustomLight,
            title: "위치찾기",
            titleColor: .black,
            cornerRadius: 10,
            borderColor: UIColor.primaryBorder.cgColor,
            borderWidth: 2)
        
        titleView.basicUI(cornerRadius: 10)
        
        reviewTextView.setUI(
            font: .systemFont(ofSize: 15, weight: .regular),
            text: placeholder)
        
        starRatingLabel.setUI(
            txt: "방문하신 공방의 별점은~?'◡'",
            txtAlignment: .center,
            font: .systemFont(ofSize: 18, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        hashTagNoticeLabel.setUI(
            txt: "해시태그를 선택해주세요!'◡'",
            txtAlignment: .center,
            font: .systemFont(ofSize: 18, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        hashTagCollectionView.layer.borderColor = UIColor.primaryDark.cgColor
        hashTagCollectionView.layer.borderWidth = 2
        starRatingView.myCosmosUI()
        ratingLabel.text = "5.0"
    }
    
    private static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 60
        layout.itemSize = CGSize(width: width / 3, height: 30)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}
