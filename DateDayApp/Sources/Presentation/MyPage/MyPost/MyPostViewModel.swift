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
    let myPostData = PublishSubject<[ViewPost.PostData]>()
    let nextCursor = PublishSubject<String>()
    var myPostDataList: [ViewPost.PostData] = []
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let tableViewItemSelected: ControlEvent<IndexPath>
        let tableViewModelSelected: ControlEvent<ViewPost.PostData>
        let selectedPostID = BehaviorSubject(value: "")
        let tableViewPrefetchRows: ControlEvent<[IndexPath]>
        let tokenExpiredMessage = PublishSubject<String>()
        let menuButtonTap = PublishSubject<Int>()
        let deleteComplete = PublishSubject<Void>()
    }
    
    struct Output {
        let myPostData: PublishSubject<[ViewPost.PostData]>
        let profileName: BehaviorSubject<String>
        let profileImage: BehaviorSubject<String>
        let tableViewItemSelected: ControlEvent<IndexPath>
        let selectedPostID: BehaviorSubject<String>
        let tokenExpiredMessage: PublishSubject<String>
        let menuButtonTap: PublishSubject<Int>
    }
    
    func transform(input: Input) -> Output {
        NetworkManager.shared.callRequest(api: Router.viewSpecificUsersPost(userID: UserDefaultsManager.shared.saveLoginUserID, next: ""), type: ViewPost.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.myPostDataList.removeAll()
                    owner.myPostDataList.append(contentsOf: success.data)
                    owner.myPostData.onNext(success.data)
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
                print("NW viewSpecificUsersPost Disposed")
            }
            .disposed(by: disposeBag)
        
        input.deleteComplete
            .bind(with: self) { owner, _ in
                NetworkManager.shared.callRequest(api: Router.viewSpecificUsersPost(userID: UserDefaultsManager.shared.saveLoginUserID, next: ""), type: ViewPost.self)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let success):
                            owner.myPostDataList.removeAll()
                            owner.myPostDataList.append(contentsOf: success.data)
                            owner.myPostData.onNext(success.data)
                            owner.nextCursor.onNext(success.nextCursor)
                            UserDefaultsManager.shared.isChangedPostData = true
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
                        print("deleteComplete Disposed")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.tableViewModelSelected
            .bind(with: self) { owner, value in
                let selectedPostID = value.postId
                input.selectedPostID.onNext(selectedPostID)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.tableViewPrefetchRows, nextCursor)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                for indexPath in value.0 {
                    if indexPath.row == 4 {
                        if value.1 != "0" {
                            NetworkManager.shared.callRequest(api: Router.viewSpecificUsersPost(userID: UserDefaultsManager.shared.saveLoginUserID, next: ""), type: ViewPost.self)
                                .subscribe(with: self) { owner, result in
                                    switch result {
                                    case .success(let success):
                                        owner.myPostDataList.append(contentsOf: success.data)
                                        owner.myPostData.onNext(owner.myPostDataList)
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
                                    print("NW viewSpecificUsersPost Disposed")
                                }
                                .disposed(by: owner.disposeBag)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            myPostData: myPostData,
            profileName: profileName,
            profileImage: profileImage,
            tableViewItemSelected: input.tableViewItemSelected,
            selectedPostID: input.selectedPostID,
            tokenExpiredMessage: input.tokenExpiredMessage,
            menuButtonTap: input.menuButtonTap)
    }
    
    func updateData() {
        NetworkManager.shared.callRequest(api: Router.viewSpecificUsersPost(userID: UserDefaultsManager.shared.saveLoginUserID, next: ""), type: ViewPost.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.myPostDataList.removeAll()
                    owner.myPostDataList.append(contentsOf: success.data)
                    owner.myPostData.onNext(success.data)
                    owner.nextCursor.onNext(success.nextCursor)
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
                print("NW viewSpecificUsersPost Disposed")
            }
            .disposed(by: disposeBag)
    }
}
