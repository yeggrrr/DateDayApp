//
//  PickedListViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PickedListViewModel: BaseViewModel {
    let pickedListData = PublishSubject<[ViewPost.PostData]>()
    let tokenExpiredMessage = PublishSubject<String>()
    let nextCursor = PublishSubject<String>()
    var pickedList: [ViewPost.PostData] = []
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let tableViewModelSelected: ControlEvent<ViewPost.PostData>
        let selectedCellIndex = PublishSubject<ControlEvent<IndexPath>.Element>()
        let selectedPostID = BehaviorSubject(value: "")
        let tableViewPrefetchRows: ControlEvent<[IndexPath]>
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let pickedListData: PublishSubject<[ViewPost.PostData]>
        let tokenExpiredMessage: PublishSubject<String>
        let itemSelected: ControlEvent<IndexPath>
        let selectedPostID: BehaviorSubject<String>
    }

    func transform(input: Input) -> Output {
        // 네트워크 통신
        NetworkManager.shared.viewInterestList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.pickedList.removeAll()
                    owner.pickedList.append(contentsOf: success.data)
                    owner.pickedListData.onNext(success.data)
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
                print("PickedListVC Disposed")
            }
            .disposed(by: disposeBag)
        
        // postID 전달
        input.tableViewModelSelected
            .bind(with: self) { owner, data in
                let selectedPostID = data.postId
                input.selectedPostID.onNext(selectedPostID)
            }
            .disposed(by: disposeBag)
        
        // 페이지네이션 (value.0: indexPaths / value.1: nextCursor)
        Observable.combineLatest(input.tableViewPrefetchRows, nextCursor)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                for indexPath in value.0 {
                    if indexPath.row == 4 {
                        if value.1 != "0" {
                            NetworkManager.shared.viewPost(next: value.1)
                                .subscribe(with: self) { owner, result in
                                    switch result {
                                    case .success(let success):
                                        owner.pickedList.append(contentsOf: success.data)
                                        owner.pickedListData.onNext(owner.pickedList)
                                        owner.nextCursor.onNext(success.nextCursor)
                                    case .failure(let failure):
                                        switch failure {
                                        case .accessTokenExpiration:
                                            owner.tokenExpiredMessage.onNext("토큰이 만료되었습니다.")
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
            pickedListData: pickedListData,
            tokenExpiredMessage: input.tokenExpiredMessage,
            itemSelected: input.itemSelected,
            selectedPostID: input.selectedPostID)
    }
}
