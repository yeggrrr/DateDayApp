//
//  MyPostCell.swift
//  DateDayApp
//
//  Created by YJ on 9/1/24.
//

import UIKit
import SnapKit

final class MyPostCell: UITableViewCell, ViewRepresentable {    
    let menuButton = UIButton(type: .system)
    
    let posterImageView = UIImageView()
    
    private let etcStackView = UIStackView()
    private let likeImageView = UIImageView()
    let likeCountLabel = UILabel()
    private let interestImageView = UIImageView()
    let interestCountLabel = UILabel()
    private let starImageView = UIImageView()
    let starRatingLabel = UILabel()
    
    private let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let hashTagLabel = UILabel()
    
    let contentLabel = UILabel()
    let createdAtLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        contentView.addSubviews([menuButton, posterImageView, etcStackView, createdAtLabel, titleStackView, contentLabel])
        etcStackView.addArrangedSubviews([likeImageView, likeCountLabel, interestImageView, interestCountLabel, starImageView, starRatingLabel])
        titleStackView.addArrangedSubviews([titleLabel, hashTagLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        menuButton.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(10)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-16)
            $0.height.width.equalTo(20)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.equalTo(menuButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
            $0.height.equalTo(posterImageView.snp.width)
        }
        
        etcStackView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(7)
            $0.leading.equalTo(safeArea.snp.leading).offset(16)
            $0.height.equalTo(20)
        }
        
        createdAtLabel.snp.makeConstraints {
            $0.centerY.equalTo(etcStackView.snp.centerY)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-16)
        }
        
        likeImageView.snp.makeConstraints {
            $0.width.equalTo(likeImageView.snp.height)
        }
        
        interestImageView.snp.makeConstraints {
            $0.width.equalTo(interestImageView.snp.height)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(etcStackView.snp.bottom).offset(7)
            $0.leading.equalTo(safeArea.snp.leading).offset(16)
            $0.trailing.lessThanOrEqualTo(safeArea.snp.trailing).offset(-16)
            $0.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(7)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(16)
            $0.bottom.lessThanOrEqualTo(safeArea.snp.bottom).offset(-16)
        }
    }
    
    func configureUI() {
        
        etcStackView.basicUI()
        titleStackView.basicUI()
        
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.tintColor = .black
        
        likeImageView.image = UIImage(systemName: "heart.fill")
        likeImageView.tintColor = .systemPink
        interestImageView.image = UIImage(systemName: "bookmark.fill")
        interestImageView.tintColor = .systemCyan
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemOrange
        
        likeCountLabel.setUI(
            txt: "0",
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .regular),
            numOfLines: 1,
            txtColor: .black)
        
        interestCountLabel.setUI(
            txt: "0",
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .regular),
            numOfLines: 1,
            txtColor: .black)
        
        starRatingLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .regular),
            numOfLines: 1,
            txtColor: .black)
        
        createdAtLabel.setUI(
            txtAlignment: .right,
            font: .systemFont(ofSize: 15, weight: .regular),
            numOfLines: 1,
            txtColor: .darkGray)
        
        titleLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .semibold),
            numOfLines: 1,
            txtColor: .black)
        
        hashTagLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 15, weight: .regular),
            numOfLines: 1,
            txtColor: .primaryDark)
        
        contentLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 14, weight: .regular),
            numOfLines: 3,
            txtColor: .black)
    }
}
