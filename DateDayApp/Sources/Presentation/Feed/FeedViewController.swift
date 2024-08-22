//
//  FeedViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: UIViewController {
    // MARK: UI
    private let feedView = FeedView()

    // MARK: Properties
    private var isAfterLoggedIn = false
    private let viewModel = FeedViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAfterLoggedIn = true
        configureCollectionView()
        configureNavigation()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAfterLoggedIn  {
            showToast(message: "로그인 성공! :)", heightY: 500, delayTime: 0.5)
            isAfterLoggedIn = false
        }
    }
    
    // MARK: Functions
    private func configureCollectionView() {
        feedView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        feedView.collectionView.showsVerticalScrollIndicator = false
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.title = "DATE DAY"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func bind() {
        let input = FeedViewModel.Input(writeButtonTap: feedView.writeButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.writeButtonTap
            .bind(with: self) { owner, _ in
                let vc = SelectPhotoViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(to: feedView.collectionView.rx.items(cellIdentifier: FeedCell.id, cellType: FeedCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.categoryLabel.text = element.category
                cell.reviewLabel.text = element.content
                cell.starRatingInfoLabel.text = element.starRating
                
                if let image = element.images.first {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        cell.mainImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SearchViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}
