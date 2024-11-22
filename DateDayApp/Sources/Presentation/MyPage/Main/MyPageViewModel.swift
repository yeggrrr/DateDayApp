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
    let editedIntroduce = PublishSubject<String?>()
    let profileData = PublishSubject<ProfileModel>()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let interestButtonTap: ControlEvent<Void>
        let editProfileButtonTap: ControlEvent<Void>
        let logoutButtonTap: ControlEvent<Void>
        let myPostListButtonTap: ControlEvent<Void>
        let myIntroduceButtonTap: ControlEvent<Void>
        let myPaymentListButtonTap: ControlEvent<Void>
        let tokenExpiredMessage = PublishSubject<String>()
    }
    
    struct Output {
        let interestButtonTap: ControlEvent<Void>
        let editProfileButtonTap: ControlEvent<Void>
        let logoutButtonTap: ControlEvent<Void>
        let myPostListButtonTap: ControlEvent<Void>
        let myIntroduceButtonTap: ControlEvent<Void>
        let myPaymentListButtonTap: ControlEvent<Void>
        let tokenExpiredMessage: PublishSubject<String>
        let profileData: PublishSubject<ProfileModel>
        let editedProfileData: PublishSubject<EditProfileModel>
        let editedIntroduce: PublishSubject<String?>
    }
    
    func transform(input: Input) -> Output {
        // 네트워크 통신
        NetworkManager.shared.callRequest(api: Router.viewMyProfile, type: ProfileModel.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.profileData.onNext(success)
                    owner.editedIntroduce.onNext(success.myIntroduce)
                case .failure(let failure):
                    switch failure {
                    case .refreshTokenExpiration:
                        print(">>> refreshToken 만료")
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
            myPaymentListButtonTap: input.myPaymentListButtonTap,
            tokenExpiredMessage: input.tokenExpiredMessage,
            profileData: profileData,
            editedProfileData: editedProfileData,
            editedIntroduce: editedIntroduce)
    }
    
    func updateData() {
        NetworkManager.shared.callRequest(api: Router.viewMyProfile, type: ProfileModel.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.profileData.onNext(success)
                    owner.editedIntroduce.onNext(success.myIntroduce)
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
                print("NW viewMyProfile Disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func withdraw(completion: @escaping (WithdrawModel) -> Void) {
        NetworkManager.shared.callRequest(api: Router.withdraw, type: WithdrawModel.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completion(success)
                case .failure(let failure):
                    switch failure {
                    case .refreshTokenExpiration:
                        print("refreshToken 만료")
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("MyPageVC withdraw Disposed")
            }
            .disposed(by: self.disposeBag)
    }
}
