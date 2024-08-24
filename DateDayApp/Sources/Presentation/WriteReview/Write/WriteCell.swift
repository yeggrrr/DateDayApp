//
//  WriteCell.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit
import SnapKit

final class WriteCell: UICollectionViewCell {
    let hashTagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configureUI() {
        contentView.addSubview(hashTagLabel)
        hashTagLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide).inset(2)
        }
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.primaryDark.cgColor
        
        hashTagLabel.textAlignment = .center
        hashTagLabel.textColor = .darkGray
    }
}
