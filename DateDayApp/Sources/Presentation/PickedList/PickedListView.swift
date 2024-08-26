//
//  PickedListView.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import UIKit
import SnapKit

final class PickedListView: BaseView {
    // MARK: UI
    private let backgroundImageView = UIImageView()
    let tableView = UITableView()
    
    // MARK: Functions
    override func addSubviews() {
        addSubviews([backgroundImageView, tableView])
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundImageView.image = UIImage(named: "paperTextureBackground")
        backgroundImageView.layer.opacity = 0.8
        tableView.backgroundColor = .clear
    }
}
