//
//  DetailViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    // MARK: UI
    let detailView = DetailView()
    
    // MARK: Properties
    var postID = BehaviorSubject(value: "")
    let viewModel = DetailViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        // collectionView
        detailView.collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.id)
        detailView.collectionView.isPagingEnabled = true
    }
    
    private func bind() {
        let input = DetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        postID
            .bind(with: self) { owner, value in
                NetworkManager.shared.viewSpecificPost(postID: value)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            owner.viewModel.imageFiles.onNext(success.imageFiles)
                            owner.navigationItem.title = success.title
                            owner.detailView.reviewLabel.text = success.content
                        case .failure(let failure):
                            print(failure)
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("DetailVC bind - Disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.imageDatas
            .bind(to: detailView.collectionView.rx.items(cellIdentifier: DetailCell.id, cellType: DetailCell.self)) { (row, element, cell) in
                cell.postImageView.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
    }
}
