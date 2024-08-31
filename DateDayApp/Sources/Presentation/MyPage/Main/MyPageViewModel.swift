//
//  MyPageViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel: BaseViewModel {
    let editedProfileData = PublishSubject<EditProfileModel>()
    
    private let disposeBag = DisposeBag()

    struct Input {
        let interestButtonTap: ControlEvent<Void>
        let editProfileButtonTap: ControlEvent<Void>
        let logoutButtonTap: ControlEvent<Void>
        let myPostListButtonTap: ControlEvent<Void>
        let myIntroduceButtonTap: ControlEvent<Void>
        let tokenExpiredMessage = PublishSubject<String>()
        let profileData = PublishSubject<ProfileModel>()
    }
    
    struct Output {
        let interestButtonTap: ControlEvent<Void>
        let editProfileButtonTap: ControlEvent<Void>
        let logoutButtonTap: ControlEvent<Void>
        let myPostListButtonTap: ControlEvent<Void>
        let myIntroduceButtonTap: ControlEvent<Void>
        let tokenExpiredMessage: PublishSubject<String>
        let profileData: PublishSubject<ProfileModel>
        let editedProfileData: PublishSubject<EditProfileModel>
    }
    
    func transform(input: Input) -> Output {
        // 네트워크 통신
        NetworkManager.shared.viewMyProfile()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    input.profileData.onNext(success)
                case .failure(let failure):
                    switch failure {
                    case .accessTokenExpiration:
                        input.tokenExpiredMessage.onNext("엑세스 토큰이 만료되었습니다.")
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("NW viewMyProfile Disposed")
            }
            .disposed(by: disposeBag)

        return Output(
            interestButtonTap: input.interestButtonTap,
            editProfileButtonTap: input.editProfileButtonTap,
            logoutButtonTap: input.logoutButtonTap,
            myPostListButtonTap: input.myPostListButtonTap,
            myIntroduceButtonTap: input.myIntroduceButtonTap,
            tokenExpiredMessage: input.tokenExpiredMessage,
            profileData: input.profileData,
            editedProfileData: editedProfileData)
    }
}
