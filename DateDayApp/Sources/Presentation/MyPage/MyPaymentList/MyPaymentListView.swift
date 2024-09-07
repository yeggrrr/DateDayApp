//
//  MyPaymentListView.swift
//  DateDayApp
//
//  Created by YJ on 9/7/24.
//

import UIKit
import SnapKit

final class MyPaymentListView: BaseView {
    let tableView = UITableView()
    
    override func addSubviews() {
        addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
    
    override func configureUI() {
        backgroundColor = .white
    }
}
