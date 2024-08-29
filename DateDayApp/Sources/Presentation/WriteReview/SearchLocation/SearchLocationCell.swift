//
//  SearchLocationCell.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit
import SnapKit

final class SearchLocationCell: UITableViewCell, ViewRepresentable {
    private let verticalStackView = UIStackView()
    let placeNameLabel = UILabel()
    let categoryLabel = UILabel()
    let addressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubviews([placeNameLabel, categoryLabel, addressLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        verticalStackView.snp.makeConstraints {
            $0.centerY.equalTo(safeArea.snp.centerY)
            $0.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(10)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
    
    func configureUI() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        
        placeNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        categoryLabel.font = .systemFont(ofSize: 15, weight: .regular)
        addressLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
}
