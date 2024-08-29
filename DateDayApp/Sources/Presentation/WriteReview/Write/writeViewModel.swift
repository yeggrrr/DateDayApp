//
//  writeViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class writeViewModel: BaseViewModel {
    private var hashTag: [HashTagModel] = [
        HashTagModel(atelierName: "#그림공방"),
        HashTagModel(atelierName: "#도자기공방"),
        HashTagModel(atelierName: "#뜨개공방"),
        HashTagModel(atelierName: "#목공방"),
        HashTagModel(atelierName: "#베이킹공방"),
        HashTagModel(atelierName: "#유리공방"),
        HashTagModel(atelierName: "#자개공방"),
        HashTagModel(atelierName: "#주얼리공방"),
        HashTagModel(atelierName: "#캔들공방"),
        HashTagModel(atelierName: "#플라워공방"),
        HashTagModel(atelierName: "#향수공방"),
        HashTagModel(atelierName: "#기타")
    ]
    
    struct Input {
        let searchLocationButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let searchLocationButtonTap: ControlEvent<Void>
        let hashTagList: Observable<[HashTagModel]>
    }
    
    func transform(input: Input) -> Output {
        let hashTagList = BehaviorSubject(value: hashTag)
        
        return Output(
            searchLocationButtonTap: input.searchLocationButtonTap,
            hashTagList: hashTagList)
    }
}
