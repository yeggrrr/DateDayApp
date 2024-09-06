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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let profileData = PublishSubject<ProfileModel>()
        let tokenExpiredMessage = PublishSubject<String>()
        let setProfileImageButtonTap: ControlEvent<Void>
        let editingCompleteButtonTap: ControlEvent<Void>
        let setDefaultImageButtonTap: ControlEvent<Void>
        let editedProfileData = PublishSubject<EditProfileModel>()
    }
    
    struct Output {
        let profileData: PublishSubject<ProfileModel>
        let profileImageData: BehaviorSubject<Data>
        let tokenExpiredMessage: PublishSubject<String>
        let setProfileImageButtonTap: ControlEvent<Void>
        let setDefaultImageButtonTap: ControlEvent<Void>
        let editingCompleteButtonTap: ControlEvent<Void>
        let editedProfileData: PublishSubject<EditProfileModel>
    }
    
    func transform(input: Input) -> Output {
        
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
            profileData: input.profileData,
            profileImageData: profileImageData,
            tokenExpiredMessage: input.tokenExpiredMessage,
            setProfileImageButtonTap: input.setProfileImageButtonTap,
            setDefaultImageButtonTap: input.setDefaultImageButtonTap,
            editingCompleteButtonTap: input.editingCompleteButtonTap,
            editedProfileData: input.editedProfileData)
    }
}
