//
//  SearchViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    let searchResultList = PublishSubject<[SearchHashTag.PostData]>()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let collectionviewModelSelected: ControlEvent<SearchHashTag.PostData>
        let collectionViewItemSelected:  ControlEvent<IndexPath>
        let selectedPostID = PublishSubject<String>()
    }
    
    struct Output {
        let searchResultList: PublishSubject<[SearchHashTag.PostData]>
        let collectionViewItemSelected:  ControlEvent<IndexPath>
        let selectedPostID: PublishSubject<String>
        let refreshTokenExpiration: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let refreshTokenExpiration = PublishSubject<Void>()
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText)
            .flatMap { value in
                return NetworkManager.shared.callRequest(api: Router.searchHashTag(next: "", hashTag: value), type: SearchHashTag.self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    owner.searchResultList.onNext(success.data)
                case .failure(let failure):
                    if failure == .refreshTokenExpiration {
                        refreshTokenExpiration.onNext(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.collectionviewModelSelected
            .bind(with: self) { owner, postData in
                let selectedPostID = postData.postId
                input.selectedPostID.onNext(selectedPostID)
            }
            .disposed(by: disposeBag)
        
        return Output(
            searchResultList: searchResultList,
            collectionViewItemSelected: input.collectionViewItemSelected,
            selectedPostID: input.selectedPostID,
            refreshTokenExpiration: refreshTokenExpiration)
    }
}
