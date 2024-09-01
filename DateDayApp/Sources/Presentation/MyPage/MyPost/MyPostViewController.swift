//
//  MyPostViewController.swift
//  DateDayApp
//
//  Created by YJ on 9/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPostViewController: UIViewController {
    // MARK: UI
    private let myPostView = MyPostView()
    
    // MARK: Properties    
    private let disposeBag = DisposeBag()
    let viewModel = MyPostViewModel()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = myPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        // navigation
        navigationItem.title = "내 게시글"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // tableView
        myPostView.myPostTableView.register(MyPostCell.self, forCellReuseIdentifier: MyPostCell.id)
        myPostView.myPostTableView.rowHeight = 610
    }
    
    private func bind() {
        let input = MyPostViewModel.Input(
            tableViewItemSelected: myPostView.myPostTableView.rx.itemSelected,
            tableViewPrefetchRows: myPostView.myPostTableView.rx.prefetchRows)
        
        let output = viewModel.transform(input: input)
        
        output.profileName
            .bind(with: self) { owner, value in
                owner.myPostView.userNameLabel.text = value
            }
            .disposed(by: disposeBag)
        
        output.profileImage
            .bind(with: self) { owner, value in    
                NetworkManager.shared.viewPostImage(filePath: value) { data in
                    owner.myPostView.userProfileImageView.image = UIImage(data: data)
                }
            }
            .disposed(by: disposeBag)
        
        output.myPostData
            .bind(to: myPostView.myPostTableView.rx.items(cellIdentifier: MyPostCell.id, cellType: MyPostCell.self)) { (row, element, cell) in
                
                if let mainImage = element.imageFiles.first {
                    NetworkManager.shared.viewPostImage(filePath: mainImage) { data in
                        cell.posterImageView.image = UIImage(data: data)
                    }
                }
                
                var hagTags: String = ""
                for hagTag in element.hashTags {
                    hagTags += " #\(hagTag)"
                }
                
                cell.hashTagLabel.text = hagTags
                cell.likeCountLabel.text = "\(element.likes.count)"
                cell.interestCountLabel.text = "\(element.interest.count)"
                cell.starRatingLabel.text = element.starRating
                cell.titleLabel.text = element.title
                cell.contentLabel.text = element.content
                cell.createdAtLabel.text = DateFormatter.dateToContainLetter(dateString: element.createdAt)
                
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.tableViewItemSelected
            .withLatestFrom(output.selectedPostID)
            .bind(with: self) { owner, postID in
                let vc = DetailViewController()
                vc.postID.onNext(postID)
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.tokenExpiredMessage
            .bind(with: self) { owner, _ in
                owner.updateToken()
            }
            .disposed(by: disposeBag)
    }
}
