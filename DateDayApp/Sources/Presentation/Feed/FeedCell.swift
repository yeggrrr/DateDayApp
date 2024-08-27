//
//  FeedCell.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class FeedCell: UICollectionViewCell, ViewRepresentable {
    // MARK: UI
    let cellBackgroundView = UIView()
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
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Functions
    func addSubviews() {
        contentView.addSubviews([cellBackgroundView, mainImageView, detailView])
        detailView.addSubviews([titleLabel, categoryLabel, reviewBackgroundView, etcInfoView])
        reviewBackgroundView.addSubview(reviewLabel)
        etcInfoView.addSubviews([likeImageView, likeLabel, markImageView, markLabel, starRatingImageView, starRatingInfoLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        cellBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(5)
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(cellBackgroundView.snp.top).offset(5)
            $0.horizontalEdges.equalTo(cellBackgroundView.snp.horizontalEdges).inset(5)
            $0.height.equalTo(mainImageView.snp.width)
        }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(cellBackgroundView.snp.horizontalEdges).inset(5)
            $0.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-5)
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
            $0.horizontalEdges.equalTo(cellBackgroundView.snp.horizontalEdges).inset(5)
            $0.bottom.equalTo(etcInfoView.snp.top)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(reviewBackgroundView.snp.top).offset(3)
            $0.horizontalEdges.equalTo(reviewBackgroundView.snp.horizontalEdges).inset(5)
            $0.bottom.lessThanOrEqualTo(reviewBackgroundView.snp.bottom).offset(-5)
        }
        
        etcInfoView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(cellBackgroundView.snp.horizontalEdges).inset(5)
            $0.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-5)
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
        backgroundColor = .clear
        cellBackgroundView.backgroundColor = .white
        cellBackgroundView.layer.opacity = 0.5
        cellBackgroundView.layer.borderColor = UIColor.primaryDark.cgColor
        cellBackgroundView.layer.borderWidth = 1

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        titleLabel.font = .systemFont(ofSize: 17, weight: .black)
        categoryLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        reviewLabel.font = .systemFont(ofSize: 13, weight: .medium)
        reviewLabel.numberOfLines = 0
        reviewLabel.textColor = .darkGray
        likeImageView.image = UIImage(systemName: "heart.fill")
        markImageView.image = UIImage(systemName: "bookmark.fill")
        starRatingImageView.image = UIImage(systemName: "star.fill")
        likeImageView.tintColor = .systemPink
        markImageView.tintColor = .systemCyan
        starRatingImageView.tintColor = .systemOrange
        likeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        markLabel.font = .systemFont(ofSize: 13, weight: .regular)
        starRatingInfoLabel.font = .systemFont(ofSize: 13, weight: .regular)
        likeLabel.text = "0"
        markLabel.text = "0"
    }
    
    func configureCell(item: ViewPost.PostData, image: Data) {
        titleLabel.text = item.title
        categoryLabel.text = item.category
        reviewLabel.text = item.content
        mainImageView.image = UIImage(data: image)
        starRatingInfoLabel.text = item.starRating
    }
}
