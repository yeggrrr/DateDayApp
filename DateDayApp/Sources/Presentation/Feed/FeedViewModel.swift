//
//  FeedViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel: BaseViewModel {
    private var postData: [ViewPost.PostData] = []
    private var imageFiles: [Data] = []
    private let disposeBag = DisposeBag()
    
    struct Input {
        let writeButtonTap: ControlEvent<Void>
        let toastMessage = PublishSubject<String>()
    }
    
    struct Output {
        let postData: BehaviorRelay<[ViewPost.PostData]>
        let imageFiles: BehaviorRelay<[Data]>
        let writeButtonTap: ControlEvent<Void>
        let toastMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let postData = BehaviorRelay(value: postData)
        let imageFiles = BehaviorRelay(value: imageFiles)
        let toastMessage = PublishSubject<String>()
        
        input.toastMessage
            .bind(with: self) { owner, value in
                toastMessage.onNext(value)
            }
            .disposed(by: disposeBag)
        
        NetworkManager.shared.viewPost()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postData.accept(success.data)
                    imageFiles.accept([])
                    postData.value.forEach { postData in
                        if let image = postData.images.first {
                            NetworkManager.shared.viewPostImage(filePath: image) { data in
                                owner.imageFiles.append(data)
                            }
                        }
                    }
                    imageFiles.accept(owner.imageFiles)                    
                case .failure(let failure):
                    switch failure {
                    case .missingRequiredValue:
                        input.toastMessage.onNext("잘못된 요청입니다.")
                    case .mismatchOrInvalid:
                        input.toastMessage.onNext("유효하지 않은 토큰입니다.")
                    case .forbidden:
                        input.toastMessage.onNext("접근 권한이 없습니다.")
                    case .accessTokenExpiration:
                        input.toastMessage.onNext("토큰 만료") // 나중에 go
                    default:
                        break
                    }
                }
            } onFailure: { owner, error in
                print("error: \(error)")
            } onDisposed: { owner in
                print("Disposed")
            }
            .disposed(by: disposeBag)
        
        return Output(
            postData: postData,
            imageFiles: imageFiles,
            writeButtonTap: input.writeButtonTap,
            toastMessage: toastMessage)
    }
}
