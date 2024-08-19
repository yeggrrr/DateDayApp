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
    
    struct Input {
        let writeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let writeButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(writeButtonTap: input.writeButtonTap)
    }
}
