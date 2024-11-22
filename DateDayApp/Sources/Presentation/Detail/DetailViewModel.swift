//
//  DetailViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: BaseViewModel {
    let imageFiles = PublishSubject<[String]>()
    let detailData = PublishSubject<UploadPostModel>()
    let isInterestIdList = PublishSubject<[String]>()
    let isLikeIdList = PublishSubject<[String]>()
    let postID = PublishSubject<String>()
    let impUID = PublishSubject<String?>()
    
    let disposeBag = DisposeBag()
    
    struct Input { 
        let moveToDetailButtonTap: ControlEvent<Void>
        let reservationButtonTap: ControlEvent<Void>
        let interestButtonTap: ControlEvent<Void>
        let likeButtonTap: ControlEvent<Void>
        let interestStatus = PublishSubject<Bool>()
        let likeStatus = PublishSubject<Bool>()
        let paymentSuccessfulMessage = PublishSubject<String>()
        let tokenExpiredMessage = PublishSubject<String>()
        let paymentResultMessage = PublishSubject<String>()
    }
    
    struct Output {
        let imageDatas: PublishSubject<[Data]>
        let moveToDetailButtonTap: ControlEvent<Void>
        let reservationButtonTap: ControlEvent<Void>
        let interestButtonTap: ControlEvent<Void>
        let likeButtonTap: ControlEvent<Void>
        let isInterestIdList: PublishSubject<[String]>
        let isLikeIdList: PublishSubject<[String]>
        let interestStatus: PublishSubject<Bool>
        let likdStatus: PublishSubject<Bool>
        let paymentSuccessfulMessage: PublishSubject<String>
        let tokenExpiredMessage: PublishSubject<String>
        let paymentResultMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        var imageFileCount: Int?
        let imageDataList = BehaviorRelay(value: [Data]())
        let imageDatas = PublishSubject<[Data]>()
        
        imageFiles
            .bind(with: self) { owner, images in
                imageFileCount = images.count
                
                for image in images {
                    NetworkManager.shared.viewPostImage(filePath: image) { imageData in
                        var imageArray = imageDataList.value
                        imageArray.append(imageData)
                        imageDataList.accept(imageArray)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        imageDataList
            .bind(with: self) { owner, dataArray in
                guard let imageFileCount = imageFileCount else { return }
                if imageFileCount == dataArray.count {
                    imageDatas.onNext(dataArray)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(postID, impUID)
            .bind(with: self) { owner, value in
                guard let impUID = value.1 else { return }
                NetworkManager.shared.callRequest(api: Router.paymentValidation(query: PaymentValidationQuery(impUID: impUID, postID: value.0)), type: ValidationModel.self)
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(_):
                            input.paymentSuccessfulMessage.onNext("결제가 완료되었습니다 :)")
                        case .failure(let failure):
                            print(failure)
                            switch failure {
                            case .accessTokenExpiration:
                                input.tokenExpiredMessage.onNext("엑세스 토큰이 만료되었습니다.")
                            case .alreadySignedUp:
                                input.paymentResultMessage.onNext("이미 검증처리가 완료된 결제건입니다.")
                            default:
                                break
                            }
                        }
                    } onFailure: { owner, error in
                        print("error: \(error)")
                    } onDisposed: { owner in
                        print("NW paymentValidation Disposed")
                    }
                    .disposed(by: owner.disposeBag)

            }
            .disposed(by: disposeBag)
        
        return Output(
            imageDatas: imageDatas,
            moveToDetailButtonTap: input.moveToDetailButtonTap,
            reservationButtonTap: input.reservationButtonTap,
            interestButtonTap: input.interestButtonTap,
            likeButtonTap: input.likeButtonTap,
            isInterestIdList: isInterestIdList,
            isLikeIdList: isLikeIdList,
            interestStatus: input.interestStatus,
            likdStatus: input.likeStatus,
            paymentSuccessfulMessage: input.paymentSuccessfulMessage,
            tokenExpiredMessage: input.tokenExpiredMessage,
            paymentResultMessage: input.paymentResultMessage)
    }
}
