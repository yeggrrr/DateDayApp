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
    }
    
    struct Output {
        let myPostData: PublishSubject<[ViewPost.PostData]>
        let profileName: BehaviorSubject<String>
        let profileImage: BehaviorSubject<String>
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
        
        return Output(
            myPostData: input.myPostData,
            profileName: profileName,
            profileImage: profileImage)
    }
}
