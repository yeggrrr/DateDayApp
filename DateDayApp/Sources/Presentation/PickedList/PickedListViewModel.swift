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
    let disposeBag = DisposeBag()
    
    struct Input {
        let pickedListData = PublishSubject<[ViewPost.PostData]>()
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let pickedListData: PublishSubject<[ViewPost.PostData]>
        let tokenExpiredMessage: PublishSubject<String>
    }

    func transform(input: Input) -> Output {
        let tokenExpiredMessage = PublishSubject<String>()
        
        NetworkManager.shared.viewInterestList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    input.pickedListData.onNext(success.data)
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
        
        return Output(
            pickedListData: input.pickedListData,
            tokenExpiredMessage: tokenExpiredMessage)
    }
}
