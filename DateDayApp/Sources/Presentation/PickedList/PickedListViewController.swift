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
    }
    
    // MARK: Functions
    private func configure() {
        // navigation
        navigationItem.title = "관심 목록"
        
        // tableView
        pickedListView.tableView.register(PickedListCell.self, forCellReuseIdentifier: PickedListCell.id)
        pickedListView.tableView.showsVerticalScrollIndicator = false
        pickedListView.tableView.rowHeight = 140
    }
    
    private func bind() {
        let input = PickedListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.pickedListData
            .bind(to: pickedListView.tableView.rx.items(cellIdentifier: PickedListCell.id, cellType: PickedListCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                cell.titleLabel.text = element.title
                cell.categoryLabel.text = element.category
                cell.starRatingLabel.text = element.starRating
                if let image = element.imageFiles.first {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        cell.mainImageView.image = UIImage(data: data)
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        // 토큰 만료 - 업데이트
        output.tokenExpiredMessage
            .bind(with: self) { owner, value in
                owner.updateToken()
            }
            .disposed(by: disposeBag)
    }
}
