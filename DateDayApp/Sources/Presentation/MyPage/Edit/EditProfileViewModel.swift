//
//  EditProfileViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: BaseViewModel {
    let profileImageData = BehaviorSubject(value: Data())
    let profileData = PublishSubject<ProfileModel>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let tokenExpiredMessage = PublishSubject<String>()
        let setProfileImageButtonTap: ControlEvent<Void>
        let editingCompleteButtonTap: ControlEvent<Void>
        let setDefaultImageButtonTap: ControlEvent<Void>
        let editedProfileData = PublishSubject<EditProfileModel>()
        let nicknameText: ControlProperty<String>
        let introduceText: ControlProperty<String>
    }
    
    struct Output {
        let profileData: PublishSubject<ProfileModel>
        let profileImageData: BehaviorSubject<Data>
        let tokenExpiredMessage: PublishSubject<String>
        let setProfileImageButtonTap: ControlEvent<Void>
        let setDefaultImageButtonTap: ControlEvent<Void>
        let editingCompleteButtonTap: ControlEvent<Void>
        let editedProfileData: PublishSubject<EditProfileModel>
        let refreshTokenExpiration: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let refreshTokenExpiration = PublishSubject<Void>()
        
        // viewDidLoadTrigger
        input.viewDidLoadTrigger
            .flatMap { _ in
                return NetworkManager.shared.callRequest(api: Router.viewMyProfile, type: ProfileModel.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.profileData.onNext(success)
                case .failure(let failure):
                    switch failure {
                    case .refreshTokenExpiration:
                        refreshTokenExpiration.onNext(())
                    default: break
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            profileData: profileData,
            profileImageData: profileImageData,
            tokenExpiredMessage: input.tokenExpiredMessage,
            setProfileImageButtonTap: input.setProfileImageButtonTap,
            setDefaultImageButtonTap: input.setDefaultImageButtonTap,
            editingCompleteButtonTap: input.editingCompleteButtonTap,
            editedProfileData: input.editedProfileData, refreshTokenExpiration: refreshTokenExpiration)
    }
    
    // func updateData() {
    //     NetworkManager.shared.viewMyProfile()
    //         .subscribe(with: self) { owner, result in
    //             switch result {
    //             case .success(let success):
    //                 owner.profileData.onNext(success)
    //             case .failure(let failure):
    //                 switch failure {
    //                 case .accessTokenExpiration:
    //                     print("토큰 만료")
    //                 default:
    //                     break
    //                 }
    //             }
    //         } onFailure: { owner, error in
    //             print("error: \(error)")
    //         } onDisposed: { owner in
    //             print("NW viewMyProfile Disposed")
    //         }
    //         .disposed(by: disposeBag)
    // }
}
