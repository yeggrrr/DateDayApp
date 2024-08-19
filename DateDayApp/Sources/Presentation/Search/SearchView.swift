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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    // MARK: Functions
    override func addSubviews() {
        addSubviews([searchBar, collectionView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        collectionView.backgroundColor = .primaryCustomLight
        searchBar.setUI(placeholder: "검색")
    }
}
