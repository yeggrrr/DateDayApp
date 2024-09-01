//
//  SearchView.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    // MARK: UI
    let searchBar = UISearchBar()
    private let backgroundImageView = UIImageView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: Functions
    override func addSubviews() {
        addSubviews([backgroundImageView, searchBar, collectionView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea).inset(5)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundImageView.image = UIImage(resource: .seaBackground)
        backgroundImageView.layer.opacity = 0.8
        collectionView.backgroundColor = .clear
        searchBar.setUI(placeholder: "해시태그 검색")
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
