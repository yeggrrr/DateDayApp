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
    }
    
    func transform(input: Input) -> Output {
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, value in
                NetworkManager.shared.searchHashTag(hashTag: value)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            print(success.data)
                            owner.searchResultList.onNext(success.data)
                        case .failure(let failure):
                            switch failure {
                            case .accessTokenExpiration:
                                print("토큰 만료")
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("SearchVC Disposed")
                    }
                    .disposed(by: owner.disposeBag)
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
            selectedPostID: input.selectedPostID)
    }
}
