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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let writeView = UIView()
    let writeButton = UIButton(type: .system)
    
    // MARK: View Life Cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        writeView.layer.cornerRadius = writeView.frame.width / 2
    }
    
    override func addSubviews() {
        addSubviews([collectionView, writeView])
        writeView.addSubview(writeButton)
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
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
        
        collectionView.backgroundColor = .primaryCustomLight
        writeView.backgroundColor = .primaryCustom
        writeButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        writeButton.tintColor = .black
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 5
        layout.itemSize = CGSize(width: width / 2, height: 320)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }
}
