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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
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
            $0.bottom.equalTo(bottomView.snp.top)
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
            $0.top.equalTo(reviewBgView.snp.bottom).offset(16)
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
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(120)
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
        
        contentView.backgroundColor = .white
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
        
        reviewBgView.layer.cornerRadius = 10
        reviewBgView.layer.borderColor = UIColor.primaryDark.cgColor
        reviewBgView.layer.borderWidth = 2
        
        reviewLabel.numberOfLines = 0
        
        locationIconImageView.image = UIImage(systemName: "location")
        locationIconImageView.tintColor = .black
        
        locationTextLabel.setUI(
            txt: "위치 정보 '◡'",
            txtAlignment: .left,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        LocationMapView.layer.cornerRadius = 15
        
        moveToDetailButton.setTitle("상세페이지로 이동", for: .normal)
        moveToDetailButton.setTitleColor(.black, for: .normal)
        moveToDetailButton.backgroundColor = .white
        moveToDetailButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        moveToDetailButton.layer.cornerRadius = 5
        moveToDetailButton.layer.borderWidth = 2
        moveToDetailButton.layer.borderColor = UIColor.primaryBorder.cgColor
        
        bottomView.backgroundColor = .primaryCustomLight
        
        interestButton.backgroundColor = .primaryButtonBg
        interestButton.layer.cornerRadius = 5
        interestButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        interestButton.tintColor = .white
        
        reservationButton.setTitle("예약하기", for: .normal)
        reservationButton.setTitleColor(.white, for: .normal)
        reservationButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        reservationButton.backgroundColor = .primaryButtonBg
        reservationButton.layer.cornerRadius = 5
        
        // 임시
        collectionView.backgroundColor = .systemGray
        reviewLabel.text =  "6월 2일에 다녀왔어요. 향료가 80개나 되서 고르는데 너무 힘들었지만, 선생님이 조언을 잘해주셔서..ㅎㅎ 딱 맘에 드는 향수를 고를 수 있었어요!! 선택 장애라 오래걸렸는데도 너무너무 친절하게 해주시고, 향수병도 고를 수 있었고, 조향을 3번 해보고 가장 맘에 드는 향으로 선택할 수 있어서 정말 좋았습니다!!^0^ 당장 사용하고 싶지만, 1-2주 정도 숙성시키고 사용하라고 말씀해주셔서 다담주부터 잘 쓰고 다닐 것 같아요~! 다음에 또 조향하러 오면 여기 올 것 같아요! #투데이이즈조이 #향수공방"
    }
}
