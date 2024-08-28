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
    let disposeBag = DisposeBag()
    
    struct Input { 
        let moveToDetailButtonTap: ControlEvent<Void>
        let reservationButtonTap: ControlEvent<Void>
        let interestButtonTap: ControlEvent<Void>
        let interestStatus = PublishSubject<Bool>()
    }
    
    struct Output {
        let imageDatas: PublishSubject<[Data]>
        let moveToDetailButtonTap: ControlEvent<Void>
        let interestButtonTap: ControlEvent<Void>
        let isInterestIdList: PublishSubject<[String]>
        let interestStatus: PublishSubject<Bool>
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
        
        input.reservationButtonTap
            .bind(with: self) { owner, _ in
                print("예약하기 버튼 클릭")
            }
            .disposed(by: disposeBag)
        
        return Output(
            imageDatas: imageDatas,
            moveToDetailButtonTap: input.moveToDetailButtonTap,
            interestButtonTap: input.interestButtonTap,
            isInterestIdList: isInterestIdList,
            interestStatus: input.interestStatus)
    }
}
