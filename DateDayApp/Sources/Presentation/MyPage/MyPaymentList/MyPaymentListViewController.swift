//
//  MyPaymentListViewController.swift
//  DateDayApp
//
//  Created by YJ on 9/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPaymentListViewController: UIViewController {
    // MARK: UI
    private let myPaymentListView = MyPaymentListView()
    
    // MARK: Properties
    let viewModel = MyPaymentListViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = myPaymentListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        // navigation
        navigationItem.title = "결제 내역"
        
        // tableView
        myPaymentListView.tableView.register(PaymentListCell.self, forCellReuseIdentifier: PaymentListCell.id)
    }
    
    private func bind() {
        let input = MyPaymentListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.paymentListData
            .bind(to: myPaymentListView.tableView.rx.items(cellIdentifier: PaymentListCell.id, cellType: PaymentListCell.self)) { (row, element, cell) in
                
                cell.productNameLabel.text = element.productName
                cell.paidAtLabel.text = DateFormatter.dateToContainHour(dateString: element.paidAt)
                cell.priceLabel.text = "\(element.price)원"
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.refreshTokenExpiration
            .bind(with: self) { owner, _ in
                let nav = UINavigationController(rootViewController: LoginViewController())
                owner.setRootViewController(nav)
            }
            .disposed(by: disposeBag)
    }
}
