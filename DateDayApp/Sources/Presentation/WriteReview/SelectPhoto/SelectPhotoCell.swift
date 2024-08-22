//
//  SelectPhotoCell.swift
//  DateDayApp
//
//  Created by YJ on 8/23/24.
//

import UIKit
import SnapKit

final class SelectPhotoCell: UICollectionViewCell {
    // MARK: UI
    let selectedImageView = UIImageView()
    
    // MARK: View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Functions
    func configure() {
        contentView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide.snp.edges)
        }
        
        selectedImageView.contentMode = .scaleAspectFill
        selectedImageView.layer.masksToBounds = true
    }
}
