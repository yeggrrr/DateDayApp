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
    let disposeBag = DisposeBag()
    
    struct Input { 
        let moveToDetailButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let imageDatas: PublishSubject<[Data]>
        let moveToDetailButtonTap: ControlEvent<Void>
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
        
        return Output(
            imageDatas: imageDatas,
            moveToDetailButtonTap: input.moveToDetailButtonTap)
    }
}
