//
//  FeedCell.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import SnapKit

final class FeedCell: UICollectionViewCell, ViewRepresentable {
    // MARK: UI
    let mainImageView = UIImageView()
    private let detailView = UIView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    private let reviewBackgroundView = UIView()
    let reviewLabel = UILabel()
    private let etcInfoView = UIView()
    private let likeImageView = UIImageView()
    let likeLabel = UILabel()
    private let markImageView = UIImageView()
    let markLabel = UILabel()
    private let starRatingImageView = UIImageView()
    let starRatingInfoLabel = UILabel()
    
    
    // MARK: View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Functions
    func addSubviews() {
        contentView.addSubviews([mainImageView, detailView])
        detailView.addSubviews([titleLabel, categoryLabel, reviewBackgroundView, etcInfoView])
        reviewBackgroundView.addSubview(reviewLabel)
        etcInfoView.addSubviews([likeImageView, likeLabel, markImageView, markLabel, starRatingImageView, starRatingInfoLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        mainImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea).inset(5)
            $0.height.equalTo(mainImageView.snp.width)
        }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(5)
            $0.horizontalEdges.bottom.equalTo(safeArea).inset(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.top)
            $0.horizontalEdges.equalTo(detailView.snp.horizontalEdges).inset(5)
            $0.height.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.horizontalEdges.equalTo(detailView.snp.horizontalEdges).inset(5)
            $0.height.equalTo(20)
        }
        
        reviewBackgroundView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea).inset(5)
            $0.bottom.equalTo(etcInfoView.snp.top)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(reviewBackgroundView.snp.top).offset(3)
            $0.horizontalEdges.equalTo(reviewBackgroundView.snp.horizontalEdges).inset(5)
            $0.bottom.lessThanOrEqualTo(reviewBackgroundView.snp.bottom).offset(-5)
        }
        
        etcInfoView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(safeArea).inset(5)
            $0.height.equalTo(20)
        }
        
        likeImageView.snp.makeConstraints {
            $0.leading.equalTo(etcInfoView.snp.leading).offset(5)
            $0.verticalEdges.equalTo(etcInfoView.snp.verticalEdges).inset(2)
            $0.width.equalTo(likeImageView.snp.height)
        }
        
        likeLabel.snp.makeConstraints {
            $0.leading.equalTo(likeImageView.snp.trailing).offset(3)
            $0.verticalEdges.equalTo(etcInfoView.snp.verticalEdges).inset(2)
        }
        
        markImageView.snp.makeConstraints {
            $0.leading.equalTo(likeLabel.snp.trailing).offset(10)
            $0.verticalEdges.equalTo(etcInfoView.snp.verticalEdges).inset(2)
            $0.width.equalTo(markImageView.snp.height)
        }
        
        markLabel.snp.makeConstraints {
            $0.leading.equalTo(markImageView.snp.trailing).offset(3)
            $0.verticalEdges.equalTo(etcInfoView.snp.verticalEdges).inset(2)
        }
        
        starRatingImageView.snp.makeConstraints {
            $0.leading.equalTo(markLabel.snp.trailing).offset(10)
            $0.verticalEdges.equalTo(etcInfoView.snp.verticalEdges).inset(2)
            $0.width.equalTo(starRatingImageView.snp.height)
        }
        
        starRatingInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(starRatingImageView.snp.trailing).offset(3)
            $0.verticalEdges.equalTo(etcInfoView.snp.verticalEdges).inset(2)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        categoryLabel.font = .systemFont(ofSize: 15, weight: .medium)
        reviewLabel.numberOfLines = 0
        reviewLabel.font = .systemFont(ofSize: 13, weight: .thin)
        reviewLabel.textColor = .darkGray
        likeImageView.image = UIImage(systemName: "heart.fill")
        likeImageView.tintColor = .systemPink
        markImageView.image = UIImage(systemName: "bookmark.fill")
        markImageView.tintColor = .systemCyan
        starRatingImageView.image = UIImage(systemName: "star.fill")
        starRatingImageView.tintColor = .systemOrange
        likeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        markLabel.font = .systemFont(ofSize: 13, weight: .regular)
        starRatingInfoLabel.font = .systemFont(ofSize: 13, weight: .regular)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.primaryBorder.cgColor
        mainImageView.backgroundColor = .systemBrown
        
        // 임시
        titleLabel.text = "공방 이름"
        categoryLabel.text = "문화,예술 > 미술,공예 > 화방"
        reviewLabel.text = "제가 가본 새얀뜨개 공방은 우선 층고가 꽤 높은 신축 상가 건물 1층이었어요. 위치도 환경도 깔끔했습니다. 층고가 높은 덕에 폭이 좁았지만 답답한 느낌이 전혀 없었고, 상가 주차장 잘 되어있고 입점 가게가 부담하는 주차비용도 저렴한 편이라고 하셨어요. 아직 상가 입점이 모두 완료 된 것이 아니라 비어있는 자리도 있었지만 꽤 많은 가게들이 활발하게 영업을 하고 있었습니다. 전체적으로 깔끔하고 짙은 갈색의 원목 가구들로 통일감을 줘서 분위기 있는 공방이었어요."
        likeLabel.text = "3"
        markLabel.text = "12"
        starRatingInfoLabel.text = "5.0"
    }
}
