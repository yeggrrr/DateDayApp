//
//  PickedListViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PickedListViewModel: BaseViewModel {
    let testList = ["test1", "test2", "test3", "test4", "test5", "test6", "text7"]
    lazy var interestedList = BehaviorSubject(value: testList)
    
    struct Input {
        
    }
    
    struct Output {
        let testInterestedList: BehaviorSubject<[String]>
    }

    func transform(input: Input) -> Output {
        
        return Output(testInterestedList: interestedList)
    }
}
