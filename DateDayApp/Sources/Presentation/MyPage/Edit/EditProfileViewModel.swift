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
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let profileData = PublishSubject<ViewMyProfileModel>()
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let profileData: PublishSubject<ViewMyProfileModel>
        let tokenExpiredMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        NetworkManager.shared.viewMyProfile()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    input.profileData.onNext(success)
                    print(success)
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
            tokenExpiredMessage: input.tokenExpiredMessage)
    }
}
