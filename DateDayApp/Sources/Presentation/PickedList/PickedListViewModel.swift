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
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
        let selectedCellIndex = PublishSubject<ControlEvent<IndexPath>.Element>()
        let selectedPostID = BehaviorSubject(value: "")
    }
    
    struct Output {
        let pickedListData: PublishSubject<[ViewPost.PostData]>
        let tokenExpiredMessage: PublishSubject<String>
        let itemSelected: ControlEvent<IndexPath>
        let selectedPostID: BehaviorSubject<String>
    }

    func transform(input: Input) -> Output {
        let tokenExpiredMessage = PublishSubject<String>()
        
        NetworkManager.shared.viewInterestList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.pickedListData.onNext(success.data)
                case .failure(let failure):
                    switch failure {
                    case .accessTokenExpiration:
                        tokenExpiredMessage.onNext("토큰이 만료되었습니다.")
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
        
        Observable.combineLatest(pickedListData, input.selectedCellIndex)
            .bind(with: self) { owner, value in
                let selectedPostID = value.0[value.1.row].postId
                input.selectedPostID.onNext(selectedPostID)
            }
            .disposed(by: disposeBag)
        
        return Output(
            pickedListData: pickedListData,
            tokenExpiredMessage: tokenExpiredMessage,
            itemSelected: input.itemSelected,
            selectedPostID: input.selectedPostID)
    }
}
