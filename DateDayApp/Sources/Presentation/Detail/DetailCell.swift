//
//  DetailCell.swift
//  DateDayApp
//
//  Created by YJ on 8/27/24.
//

import UIKit
import SnapKit

final class DetailCell: UICollectionViewCell {
    let postImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configure() {
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        postImageView.contentMode = .scaleAspectFill
    }
}
