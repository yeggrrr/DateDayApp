//
//  SearchLocationView.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit
import SnapKit

final class SearchLocationView: BaseView {
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override func addSubviews() {
        addSubviews([searchBar, tableView])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(10)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    override func configureUI() {
        super.configureUI()  
        
        searchBar.setUI(placeholder: "공방 이름을 입력해주세요")
        tableView.backgroundColor = .systemGray
    }
}
