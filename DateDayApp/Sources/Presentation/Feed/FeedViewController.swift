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
    var showLoginAlert: Bool?
    private let viewModel = FeedViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureNavigation()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showLoginAlert == true {
            showToast(message: "로그인 성공! :)", heightY: 500, delayTime: 0.5)
            self.showLoginAlert = false
        }
    }
    
    // MARK: Functions
    private func configureCollectionView() {
        feedView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        feedView.collectionView.showsVerticalScrollIndicator = false
    }
    
    private func configureNavigation() {
        let logoImage = UIImage(named: "DateDayBlackText")
        let imageView = UIImageView()
        let logoWidth = imageView.widthAnchor.constraint(equalToConstant: 140)
        let logoHeight = imageView.heightAnchor.constraint(equalToConstant: 70)
        imageView.contentMode = .scaleAspectFit
        imageView.image = logoImage
        logoWidth.isActive = true
        logoHeight.isActive = true
        navigationItem.titleView = imageView
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func bind() {
        let input = FeedViewModel.Input(
            collectionViewItemSelected: feedView.collectionView.rx.itemSelected,
            writeButtonTap: feedView.writeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.writeButtonTap
            .bind(with: self) { owner, _ in
                let vc = SelectPhotoViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.postData
            .bind(to: feedView.collectionView.rx.items(cellIdentifier: FeedCell.id, cellType: FeedCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.categoryLabel.text = element.category
                cell.reviewLabel.text = element.content
                cell.starRatingInfoLabel.text = element.starRating
                
                if let image = element.imageFiles.first {
                    NetworkManager.shared.viewPostImage(filePath: image) { data in
                        cell.mainImageView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)

        
        Observable.combineLatest(feedView.collectionView.rx.prefetchItems, output.nextCursor)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                for indexPath in value.0 {
                    if indexPath.item == 3 {
                        if value.1 != "0" {
                            NetworkManager.shared.viewPost(next: value.1)
                                .subscribe(with: self) { owner, result in
                                    switch result {
                                    case .success(let success):
                                        owner.viewModel.append(items: success.data)
                                        input.nextCursor.onNext(success.nextCursor)
                                    case .failure(let failure):
                                        switch failure {
                                        case .accessTokenExpiration:
                                            owner.updateToken()
                                        default:
                                            break
                                        }
                                    }
                                } onFailure: { owner, error in
                                    print("error: \(error)")
                                } onDisposed: { owner in
                                    print("Disposed")
                                }
                                .disposed(by: owner.disposeBag)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.postData, output.collectionViewItemSelected)
            .bind(with: self) { owner, value in
                if !value.0.isEmpty {
                    let vc = DetailViewController()
                    vc.postID.onNext(value.0[value.1.item].postId)
                    vc.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    owner.showToast(message: "잠시후 다시 시도해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        output.toastMessage
            .bind(with: self) { owner, value in
                owner.showToast(message: value)
            }
            .disposed(by: disposeBag)
        
        output.tokenExpiredMessage
            .bind(with: self) { owner, value in
                owner.updateToken()
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
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}
