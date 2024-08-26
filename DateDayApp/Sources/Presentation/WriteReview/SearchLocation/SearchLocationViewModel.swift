//
//  SearchLocationViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchLocationViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let tableViewModelSelected: ControlEvent<SearchLocationModel.Documents>
    }
    
    struct Output {
        let searchResult: PublishSubject<[SearchLocationModel.Documents]>
        let tableViewModelSelected: ControlEvent<SearchLocationModel.Documents>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = PublishSubject<[SearchLocationModel.Documents]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap { value in
                NetworkManager.shared.searchLocation(query: value)
                    .catch { error in
                        return Single<SearchLocationModel>.never()
                    }
            }
            .subscribe(with: self) { owner, result in
                searchResult.onNext(result.documents)
                
            } onError: { owner, error in
                print("error: \(error)")
            } onCompleted: { owner in
                print("Completed")
            } onDisposed: { owner in
                print("Disposed")
            }
            .disposed(by: disposeBag)
        
        return Output(
            searchResult: searchResult,
            tableViewModelSelected: input.tableViewModelSelected)
    }
}
