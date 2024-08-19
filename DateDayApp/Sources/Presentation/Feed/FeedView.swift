//
//  FeedView.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import SnapKit

final class FeedView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func addSubviews() {
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
