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
    private var postData: [ViewPost.PostData] = []
    private let disposeBag = DisposeBag()
    
    struct Input {
        let collectionViewItemSelected: ControlEvent<IndexPath>
        let writeButtonTap: ControlEvent<Void>
        let toastMessage = PublishSubject<String>()
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let collectionViewItemSelected: ControlEvent<IndexPath>
        let postData: BehaviorRelay<[ViewPost.PostData]>
        let writeButtonTap: ControlEvent<Void>
        let toastMessage: PublishSubject<String>
        let tokenExpiredMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let postData = BehaviorRelay(value: postData)
        let toastMessage = PublishSubject<String>()
        let tokenExpiredMessage = PublishSubject<String>()
        
        input.toastMessage
            .bind(with: self) { owner, value in
                toastMessage.onNext(value)
            }
            .disposed(by: disposeBag)
        
        input.tokenExpiredMessage
            .bind(with: self) { owner, value in
                tokenExpiredMessage.onNext(value)
            }
            .disposed(by: disposeBag)
        
        NetworkManager.shared.viewPost()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postData.accept(success.data)
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
        
        return Output(
            collectionViewItemSelected: input.collectionViewItemSelected,
            postData: postData,
            writeButtonTap: input.writeButtonTap,
            toastMessage: toastMessage,
            tokenExpiredMessage: tokenExpiredMessage)
    }
}
