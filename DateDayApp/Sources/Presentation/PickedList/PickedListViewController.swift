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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // tableView
        pickedListView.tableView.register(PickedListCell.self, forCellReuseIdentifier: PickedListCell.id)
        pickedListView.tableView.showsVerticalScrollIndicator = false
        pickedListView.tableView.rowHeight = 140
    }
    
    private func bind() {
        let input = PickedListViewModel.Input(itemSelected: pickedListView.tableView.rx.itemSelected)
        let output = viewModel.transform(input: input)
        
        // 관심 목록 collectionView
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
        
        // 클릭한 셀 인덱스 뷰모델 전달
        output.itemSelected
            .bind(with: self) { owner, index in
                input.selectedCellIndex.onNext(index)
            }
            .disposed(by: disposeBag)
        
        // 셀 클릭 시, DetailVC 이동
        output.itemSelected
            .withLatestFrom(output.selectedPostID)
            .bind(with: self) { owner, postID in
                let vc = DetailViewController()
                vc.postID.onNext(postID)
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
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
