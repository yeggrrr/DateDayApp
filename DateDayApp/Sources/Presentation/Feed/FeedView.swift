//
//  FeedView.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import SnapKit

final class FeedView: BaseView {
    // MARK: UI
    private let backgroundImageView = UIImageView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let writeView = UIView()
    let writeButton = UIButton(type: .system)
    
    // MARK: View Life Cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        writeView.layer.cornerRadius = writeView.frame.width / 2
    }
    
    override func addSubviews() {
        addSubviews([backgroundImageView, collectionView, writeView])
        writeView.addSubview(writeButton)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(5)
        }
        
        writeView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(safeArea).inset(10)
            $0.height.width.equalTo(50)
        }
        
        writeButton.snp.makeConstraints {
            $0.edges.equalTo(writeView.snp.edges)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundImageView.image = UIImage(resource: .seaBackground)
        backgroundImageView.layer.opacity = 0.8
        collectionView.backgroundColor = .clear
        writeView.backgroundColor = .primaryButtonBg
        writeButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        writeButton.tintColor = .white
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 10
        layout.itemSize = CGSize(width: width / 2, height: 320)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}
