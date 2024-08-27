//
//  DetailView.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import UIKit
import SnapKit
import MapKit

final class DetailView: BaseView {
    // MARK: UI
    private let backgroundImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let likeButton = UIButton(type: .system)
    private let dividerView = UIView()
    private let reviewIconImageView = UIImageView()
    private let reviewTextLabel = UILabel()
    private let reviewBgView = UIView()
    let reviewLabel = UILabel()
    private let locationIconImageView = UIImageView()
    private let locationTextLabel = UILabel()
    let LocationMapView = MKMapView()
    let moveToDetailButton = UIButton()
    
    let bottomView = UIView()
    let interestButton = UIButton(type: .system)
    let reservationButton = UIButton()
    
    // MARK: Functions
    override func addSubviews() {
        addSubviews([backgroundImageView, scrollView, bottomView])
        scrollView.addSubview(contentView)
        contentView.addSubviews([collectionView, likeButton, dividerView, reviewTextLabel, reviewBgView, reviewLabel, reviewIconImageView, locationTextLabel, locationIconImageView, LocationMapView, moveToDetailButton])
        bottomView.addSubviews([interestButton, reservationButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        let scrollViewFrame = scrollView.frameLayoutGuide
        let scrollViewContent = scrollView.contentLayoutGuide
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(bottomView.snp.top).offset(5)
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollViewContent.snp.verticalEdges)
            $0.horizontalEdges.equalTo(scrollViewFrame.snp.horizontalEdges)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(300)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.leading.equalTo(safeArea.snp.leading).offset(10)
            $0.height.width.equalTo(40)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(1)
            $0.height.equalTo(1)
        }
        
        reviewIconImageView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(16)
            $0.leading.equalTo(reviewBgView.snp.leading)
            $0.height.width.equalTo(25)
        }
        
        reviewTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(reviewIconImageView.snp.centerY)
            $0.leading.equalTo(reviewIconImageView.snp.trailing).offset(5)
        }
        
        reviewBgView.snp.makeConstraints {
            $0.top.equalTo(reviewTextLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(16)
            $0.bottom.lessThanOrEqualTo(locationTextLabel.snp.top).offset(-16)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.edges.equalTo(reviewBgView.snp.edges).inset(16)
        }
        
        locationIconImageView.snp.makeConstraints {
            $0.top.equalTo(reviewBgView.snp.bottom).offset(20)
            $0.leading.equalTo(reviewIconImageView.snp.leading)
            $0.height.width.equalTo(25)
        }
        
        locationTextLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIconImageView.snp.centerY)
            $0.leading.equalTo(locationIconImageView.snp.trailing).offset(5)
        }
        
        LocationMapView.snp.makeConstraints {
            $0.top.equalTo(locationTextLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(20)
            $0.height.equalTo(280)
        }
        
        moveToDetailButton.snp.makeConstraints {
            $0.top.equalTo(LocationMapView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(30)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-25)
        }
        
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        interestButton.snp.makeConstraints {
            $0.leading.equalTo(safeArea).offset(16)
            $0.top.equalTo(bottomView.snp.top).offset(16)
            $0.height.width.equalTo(50)
        }
        
        reservationButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).offset(16)
            $0.leading.equalTo(interestButton.snp.trailing).offset(16)
            $0.trailing.equalTo(safeArea).offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundImageView.image = UIImage(named: "seaBackground")
        
        contentView.backgroundColor = .primaryCustomLight
        contentView.layer.opacity = 0.8
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .primaryDark
        
        dividerView.backgroundColor = .primaryDark
        
        reviewIconImageView.image = UIImage(systemName: "highlighter")
        reviewIconImageView.tintColor = .black
        
        reviewTextLabel.setUI(
            txt: "후기 '◡'",
            txtAlignment: .left,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        reviewBgView.basicUI(
            bgColor: .white,
            cornerRadius: 10,
            borderWidth: 2,
            borderColor: UIColor.primaryDark.cgColor)
        reviewBgView.layer.opacity = 0.5
        
        reviewLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .regular),
            numOfLines: 0,
            txtColor: .black)
        
        locationIconImageView.image = UIImage(systemName: "location")
        locationIconImageView.tintColor = .black
        
        locationTextLabel.setUI(
            txt: "위치 정보 '◡'",
            txtAlignment: .left,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        LocationMapView.layer.cornerRadius = 15
        
        moveToDetailButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        moveToDetailButton.squareUI(
            bgColor: .white,
            title: "상세페이지로 이동",
            titleColor: .black,
            cornerRadius: 5,
            borderColor: UIColor.primaryBorder.cgColor,
            borderWidth: 2)
        
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 15
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.masksToBounds = true
        
        interestButton.backgroundColor = .primaryButtonBg
        interestButton.layer.cornerRadius = 5
        interestButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        interestButton.tintColor = .white
        
        reservationButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        reservationButton.squareUI(
            bgColor: .primaryButtonBg,
            title: "예약하기",
            titleColor: .white,
            cornerRadius: 5,
            borderColor: UIColor.clear.cgColor,
            borderWidth: 0)
    }
    
    private static func layout() -> UICollectionViewLayout {
        let layout  = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: 300)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        return layout
    }
}
