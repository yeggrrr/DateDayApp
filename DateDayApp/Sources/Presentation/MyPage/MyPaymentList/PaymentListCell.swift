//
//  PaymentListCell.swift
//  DateDayApp
//
//  Created by YJ on 9/7/24.
//

import UIKit
import SnapKit

final class PaymentListCell: UITableViewCell, ViewRepresentable {
    private let paymentDataView = UIView()
    private let verticalStackView = UIStackView()
    let productNameLabel = UILabel()
    let priceLabel = UILabel()
    let paidAtLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() {
        contentView.addSubview(paymentDataView)
        paymentDataView.addSubviews([verticalStackView, priceLabel])
        verticalStackView.addArrangedSubviews([productNameLabel, paidAtLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        paymentDataView.snp.makeConstraints {
            $0.edges.equalTo(safeArea.snp.edges).inset(15)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(paymentDataView.snp.verticalEdges)
            $0.leading.equalTo(paymentDataView.snp.leading)
            $0.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(paymentDataView.snp.centerY)
            $0.trailing.equalTo(paymentDataView.snp.trailing)
            $0.height.equalTo(20)
            $0.width.equalTo(80)
        }
    }
    
    func configureUI() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10
        
        productNameLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 20, weight: .bold),
            numOfLines: 1,
            txtColor: .black)
        
        paidAtLabel.setUI(
            txtAlignment: .left,
            font: .systemFont(ofSize: 17, weight: .semibold),
            numOfLines: 1,
            txtColor: .darkGray)
        
        priceLabel.setUI(
            txtAlignment: .right,
            font: .systemFont(ofSize: 16, weight: .semibold),
            numOfLines: 1,
            txtColor: .primaryDark)
    }
}
