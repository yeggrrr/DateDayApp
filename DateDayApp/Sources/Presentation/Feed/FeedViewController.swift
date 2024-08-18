//
//  FeedViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit

// TODO: 로그인 경로로 들어온 경우에만 toast 나오도록 수정
final class FeedViewController: UIViewController {
    // MARK: UI
    let feedView = FeedView()
    let cellSpacing: CGFloat = 5
    
    // MARK: Properties
    
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
        feedView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.id)
        feedView.collectionView.showsVerticalScrollIndicator = false
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
        let size = CGSize(width: width / 2, height: 250)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
