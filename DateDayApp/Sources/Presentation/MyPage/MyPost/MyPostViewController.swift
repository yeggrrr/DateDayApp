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
    
    // MARK: Function
    private func configure() {
        // navigation
        navigationItem.title = "내 게시글"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        // tableView
        myPostView.myPostTableView.register(MyPostCell.self, forCellReuseIdentifier: MyPostCell.id)
        myPostView.myPostTableView.rowHeight = 580
    }
    
    private func bind() {
        let input = MyPostViewModel.Input(
            tableViewItemSelected: myPostView.myPostTableView.rx.itemSelected,
            tableViewModelSelected: myPostView.myPostTableView.rx.modelSelected(ViewPost.PostData.self),
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
                cell.menuButton.rx.tap
                    .bind(with: self) { owner, _ in
                        input.menuButtonTap.onNext(row)
                    }
                    .disposed(by: cell.disposeBag)
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
        
        output.menuButtonTap
            .bind(with: self) { owner, index in
                owner.okCanelShowAlert(title: "해당 게시물을 삭제하시겠습니까?") { _ in
                    NetworkManager.shared.deletePost(postID: owner.viewModel.myPostDataList[index].postId) { result in
                        switch result {
                        case .success:
                            owner.showToast(message: "해당 게시물이 삭제되었습니다.")
                            input.deleteComplete.onNext(())
                        case .accessTokenExpiration:
                            owner.updateToken()
                        default:
                            break
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.myPostData
            .bind(with: self) { owner, postData in
                if postData.count == 0 {
                    owner.myPostView.noticeLabel.isHidden = false
                } else {
                    owner.myPostView.noticeLabel.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        output.tokenExpiredMessage
            .bind(with: self) { owner, _ in
                owner.updateToken()
            }
            .disposed(by: disposeBag)
    }
}
