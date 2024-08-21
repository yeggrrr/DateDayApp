//
//  FeedViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: didSet 코드 Rx로 변경하기
final class FeedViewController: UIViewController {
    // MARK: UI
    let feedView = FeedView()
    let cellSpacing: CGFloat = 5
    
    // MARK: Properties
    var postData: [ViewPost.PostData] = []
    var imageFiles: [Data] = [] {
        didSet {
            if imageFiles.count == postData.count {
                feedView.collectionView.reloadData()
            }
        }
    }
    
    var isAfterLoggedIn = false
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
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
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
        let input = FeedViewModel.Input(writeButtonTap: feedView.writeButton.rx.tap,
                                        viewPostNetwork: NetworkManager.shared.viewPost())
        let output = viewModel.transform(input: input)
        
        output.writeButtonTap
            .bind(with: self) { owner, _ in
                let vc = SelectPhotoViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.viewPostNetwork
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.postData = success.data
                    owner.imageFiles = []
                    owner.postData.forEach { postData in
                        if let image = postData.images.first {
                            NetworkManager.shared.image(filePath: image) { data in
                                self.imageFiles.append(data)
                            }
                        }
                    }
                case .failure(let failure):
                    switch failure {
                    case .missingRequiredValue:
                        owner.showToast(message: "잘못된 요청입니다.")
                    case .mismatchOrInvalid:
                        owner.showToast(message: "유효하지 않은 토큰입니다.")
                    case .forbidden:
                        owner.showToast(message: "접근 권한이 없습니다.")
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

// MARK: UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        cell.configureCell(item: postData[indexPath.item], image: imageFiles[indexPath.item])
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
