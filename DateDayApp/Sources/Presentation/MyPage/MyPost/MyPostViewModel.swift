//
//  MyPostViewModel.swift
//  DateDayApp
//
//  Created by YJ on 9/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPostViewModel: BaseViewModel {
    let profileName = BehaviorSubject(value: "")
    let profileImage = BehaviorSubject(value: "")
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let myPostData = PublishSubject<[ViewPost.PostData]>()
        let nextCursor = PublishSubject<String>()
        let tableViewItemSelected: ControlEvent<IndexPath>
        let selectedPostID = BehaviorSubject(value: "")
    }
    
    struct Output {
        let myPostData: PublishSubject<[ViewPost.PostData]>
        let profileName: BehaviorSubject<String>
        let profileImage: BehaviorSubject<String>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let selectedPostID: BehaviorSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        NetworkManager.shared.viewSpecificUsersPost(userID: UserDefaultsManager.shared.saveLoginUserID, next: "")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    print(success)
                    input.myPostData.onNext(success.data)
                    input.nextCursor.onNext(success.nextCursor)
                case .failure(let failure):
                    switch failure {
                    case .accessTokenExpiration:
                        print("accessToken만료")
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("NW viewSpecificUsersPost Disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.myPostData, input.tableViewItemSelected)
            .bind(with: self) { owner, value in
                guard value.1.row < value.0.count else { return }
                let selectedPostID = value.0[value.1.row].postId
                input.selectedPostID.onNext(selectedPostID)
            }
            .disposed(by: disposeBag)
        
        return Output(
            myPostData: input.myPostData,
            profileName: profileName,
            profileImage: profileImage,
            tableViewItemSelected: input.tableViewItemSelected,
            selectedPostID: input.selectedPostID)
    }
}
