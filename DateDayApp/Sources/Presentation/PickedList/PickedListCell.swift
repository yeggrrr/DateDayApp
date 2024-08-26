//
//  PickedListCell.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import UIKit
import SnapKit

final class PickedListCell: UITableViewCell, ViewRepresentable {
    // MARK: UI
    let backgroundContentView = UIView()
    let detailStackView = UIStackView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    private let starRatingStackView = UIStackView()
    private let starImageView = UIImageView()
    let starRatingLabel = UILabel()
    let mainImageView = UIImageView()
    
    // MARK: View Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Functions
    func addSubviews() {
        contentView.addSubview(backgroundContentView)
        backgroundContentView.addSubviews([detailStackView, mainImageView])
        detailStackView.addArrangedSubviews([titleLabel, categoryLabel, starRatingStackView])
        starRatingStackView.addArrangedSubviews([starImageView, starRatingLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        backgroundContentView.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(7)
        }
        
        detailStackView.snp.makeConstraints {
            $0.centerY.equalTo(backgroundContentView.snp.centerY)
            $0.leading.equalTo(backgroundContentView.snp.leading).offset(10)
            $0.trailing.equalTo(mainImageView.snp.leading).offset(-10)
        }
        
        starImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        mainImageView.snp.makeConstraints {
            $0.trailing.equalTo(backgroundContentView.snp.trailing)
            $0.verticalEdges.equalTo(backgroundContentView.snp.verticalEdges)
            $0.width.equalTo(110)
        }
    }
    
    func configureUI() {
        backgroundColor = .clear
        backgroundContentView.backgroundColor = .white
        backgroundContentView.layer.opacity = 0.8
        backgroundContentView.layer.borderColor = UIColor.primaryDark.cgColor
        backgroundContentView.layer.borderWidth = 2
        backgroundContentView.layer.cornerRadius = 10
        
        detailStackView.axis = .vertical
        detailStackView.distribution = .fillProportionally
        detailStackView.spacing = 5
        
        starRatingStackView.axis = .horizontal
        starRatingStackView.distribution = .fillProportionally
        starRatingStackView.spacing = 5
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemOrange
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        categoryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        starRatingLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        // 임시
        mainImageView.image = UIImage(named: "seaBackground")
        starRatingLabel.text = "5.0"
        categoryLabel.text = "문화,예술 > 미술,공예 > 목공예"
    }
}
