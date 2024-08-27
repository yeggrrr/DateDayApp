//
//  DetailCell.swift
//  DateDayApp
//
//  Created by YJ on 8/27/24.
//

import UIKit
import SnapKit

final class DetailCell: UICollectionViewCell {
    let bgView = UIView()
    let postImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configure() {
        contentView.addSubviews([bgView, postImageView])
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-2)
        }
        
        postImageView.snp.makeConstraints {
            $0.edges.equalTo(bgView.snp.edges)
        }
        
        backgroundColor = .primaryBorder
        
        postImageView.contentMode = .scaleAspectFill
        postImageView.layer.masksToBounds = true
    }
}
