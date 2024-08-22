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
    }
    
    struct Output {
        let postData: BehaviorRelay<[ViewPost.PostData]>
        let imageFiles: BehaviorRelay<[Data]>
        let writeButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let postData = BehaviorRelay(value: postData)
        let imageFiles = BehaviorRelay(value: imageFiles)
        
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
                        print("잘못된 요청입니다.")
                    case .mismatchOrInvalid:
                        print("유효하지 않은 토큰입니다.")
                    case .forbidden:
                        print("접근 권한이 없습니다.")
                    case .accessTokenExpiration:
                        print("토큰 만료")
                        
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
            writeButtonTap: input.writeButtonTap)
    }
}
