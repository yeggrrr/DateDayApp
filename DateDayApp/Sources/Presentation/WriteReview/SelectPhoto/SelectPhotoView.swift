//
//  SelectPhotoView.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import SnapKit

final class SelectPhotoView: BaseView {
    // MARK: UI
    let descriptionLabel = UILabel()
    let AddImageButton = UIButton(type: .custom)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())

    // MARK: Functions
    override func addSubviews() {
        addSubviews([descriptionLabel, AddImageButton, collectionView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(50)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(30)
        }
        
        AddImageButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(safeArea.snp.centerX)
            $0.width.height.equalTo(100)
            
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(AddImageButton.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(50)
            $0.bottom.equalTo(safeArea.snp.bottom).offset(-100)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        descriptionLabel.setUI(
            txt: "리뷰에 남길 사진을 선택해주세요! ✿'◡'✿",
            txtAlignment: .center,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 0,
            txtColor: .black)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let addImage = UIImage(systemName: "photo.badge.plus", withConfiguration: imageConfig)
        AddImageButton.setImage(addImage, for: .normal)
        AddImageButton.tintColor = .white
        AddImageButton.layer.cornerRadius = 27
        AddImageButton.backgroundColor = .primaryBorder
        
        collectionView.backgroundColor = .primaryCustomLight
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 20
        layout.itemSize = CGSize(width: width, height: 500)
        layout.scrollDirection = .horizontal
        return layout
    }
}
