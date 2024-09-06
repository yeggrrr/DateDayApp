//
//  FeedViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel: BaseViewModel {
    let postData = PublishSubject<[ViewPost.PostData]>()
    let nextCursor = PublishSubject<String>()
    var feedDataList: [ViewPost.PostData] = []
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let collectionViewItemSelected: ControlEvent<IndexPath>
        let collectionViewModelSelected: ControlEvent<ViewPost.PostData>
        let collectionViewPrefetchItems: ControlEvent<[IndexPath]>
        let writeButtonTap: ControlEvent<Void>
        let selectedPostID = BehaviorSubject(value: "")
        let toastMessage = PublishSubject<String>()
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let collectionViewItemSelected: ControlEvent<IndexPath>
        let postData: PublishSubject<[ViewPost.PostData]>
        let writeButtonTap: ControlEvent<Void>
        let selectedPostID: BehaviorSubject<String>
        let toastMessage: PublishSubject<String>
        let tokenExpiredMessage: PublishSubject<String>
        let nextCursor: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        // 네트워크 통신
        NetworkManager.shared.viewPost()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.feedDataList.removeAll()
                    owner.feedDataList.append(contentsOf: success.data)
                    owner.postData.onNext(success.data)
                    owner.nextCursor.onNext(success.nextCursor)
                case .failure(let failure):
                    switch failure {
                    case .missingRequiredValue:
                        input.toastMessage.onNext("잘못된 요청입니다.")
                    case .mismatchOrInvalid:
                        input.toastMessage.onNext("유효하지 않은 토큰입니다.")
                    case .forbidden:
                        input.toastMessage.onNext("접근 권한이 없습니다.")
                    case .accessTokenExpiration:
                        input.tokenExpiredMessage.onNext("토큰이 만료되었습니다.")
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("FeedVC viewPost - Disposed")
            }
            .disposed(by: disposeBag)
        
        input.collectionViewModelSelected
            .bind(with: self) { owner, postData in
                let selectedPostID = postData.postId
                input.selectedPostID.onNext(selectedPostID)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.collectionViewPrefetchItems, nextCursor)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                for indexPath in value.0 {
                    if indexPath.item == 3 {
                        if value.1 != "0" {
                            NetworkManager.shared.viewPost(next: value.1)
                                .subscribe(with: self) { owner, result in
                                    switch result {
                                    case .success(let success):
                                        owner.feedDataList.append(contentsOf: success.data)
                                        owner.postData.onNext(owner.feedDataList)
                                        owner.nextCursor.onNext(success.nextCursor)
                                    case .failure(let failure):
                                        switch failure {
                                        case .accessTokenExpiration:
                                            input.tokenExpiredMessage.onNext("토큰이 만료되었습니다.")
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
        
        return Output(
            collectionViewItemSelected: input.collectionViewItemSelected,
            postData: postData,
            writeButtonTap: input.writeButtonTap,
            selectedPostID: input.selectedPostID,
            toastMessage: input.toastMessage,
            tokenExpiredMessage: input.tokenExpiredMessage,
            nextCursor: nextCursor)
    }
}
