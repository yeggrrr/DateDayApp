//
//  WriteCell.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit
import SnapKit

final class WriteCell: UICollectionViewCell, ViewRepresentable {
    private let hashTagBackgroundView = UIView()
    let hashTagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        hashTagBackgroundView.layer.cornerRadius = hashTagBackgroundView.frame.height / 2
    }
    
    func addSubviews() {
        contentView.addSubviews([hashTagBackgroundView, hashTagLabel])
    }
    
    func setConstraints() {
        hashTagBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(3)
        }
        
        hashTagLabel.snp.makeConstraints {
            $0.edges.equalTo(hashTagBackgroundView).inset(2)
        }
    }
    
    func configureUI() {
        hashTagBackgroundView.layer.borderColor = UIColor.primaryDark.cgColor
        hashTagBackgroundView.layer.borderWidth = 1
        
        hashTagLabel.textAlignment = .center
        hashTagLabel.textColor = .darkGray
    }
}
