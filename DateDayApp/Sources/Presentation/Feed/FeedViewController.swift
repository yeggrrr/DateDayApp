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
    let feedView = FeedView()
    let cellSpacing: CGFloat = 5
    
    // MARK: Properties
    var isAfterLoggedIn = false
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAfterLoggedIn = true
        configureCollectionView()
        configure()
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
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
        feedView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        feedView.collectionView.showsVerticalScrollIndicator = false
    }
    
    private func configure() {
        // navigation
        navigationItem.rightBarButtonItem = rightBarButtonItem()
        navigationItem.title = "DATE DAY"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
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

// MARK: UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        return cell
    }
}

// MARK: UICollectionViewDataSource
extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - cellSpacing
        let size = CGSize(width: width / 2, height: 320)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
