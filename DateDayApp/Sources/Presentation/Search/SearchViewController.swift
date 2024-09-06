//
//  SearchViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    // MARK: UI
    private let searchView = SearchView()
    
    // MARK: Properties
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configure()
        bind()
    }
    
    // MARK: Functions
    private func configure() {
        // navigation
        navigationItem.title = "리뷰 검색"
        
        // collectionView
        searchView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        searchView.collectionView.showsVerticalScrollIndicator = false
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            searchButtonClicked: searchView.searchBar.rx.searchButtonClicked,
            searchText: searchView.searchBar.rx.text.orEmpty,
            collectionviewModelSelected: searchView.collectionView.rx.modelSelected(SearchHashTag.PostData.self),
            collectionViewItemSelected: searchView.collectionView.rx.itemSelected)
        
        let output = viewModel.transform(input: input)
        
        output.searchResultList
            .bind(to: searchView.collectionView.rx.items(cellIdentifier: FeedCell.id, cellType: FeedCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.categoryLabel.text = element.category
                cell.reviewLabel.text = element.content
                cell.likeLabel.text = "\(element.likes.count)"
                cell.markLabel.text = "\(element.interest.count)"
                cell.starRatingInfoLabel.text = element.starRating
                
                if let image = element.imageFiles.first {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        cell.mainImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.collectionViewItemSelected
            .withLatestFrom(output.selectedPostID)
            .bind(with: self) { owner, value in
                let vc = DetailViewController()
                vc.postID.onNext(value)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
