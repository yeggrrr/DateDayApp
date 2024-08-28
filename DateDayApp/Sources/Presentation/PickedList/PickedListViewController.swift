//
//  PickedListViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PickedListViewController: UIViewController {
    // MARK: UI
    let pickedListView = PickedListView()
    
    // MARK: Properties
    let viewModel = PickedListViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = pickedListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configure()
        bind()
        
        NetworkManager.shared.viewInterestList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    print(">>> success: \(success)")
                case .failure(let failure):
                    print(failure)
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("PickedListVC Disposed")
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Functions
    private func configure() {
        // navigation
        navigationItem.title = "관심 목록"
        
        // tableView
        pickedListView.tableView.register(PickedListCell.self, forCellReuseIdentifier: PickedListCell.id)
        pickedListView.tableView.showsVerticalScrollIndicator = false
        pickedListView.tableView.rowHeight = 150
    }
    
    private func bind() {
        let input = PickedListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.testInterestedList
            .bind(to: pickedListView.tableView.rx.items(cellIdentifier: PickedListCell.id, cellType: PickedListCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.titleLabel.text = element
            }
            .disposed(by: disposeBag)
    }
}
