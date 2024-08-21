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
        let viewPostNetwork: Single<Result<ViewPost, HTTPStatusCodes>>
    }
    
    struct Output {
        let writeButtonTap: ControlEvent<Void>
        let viewPostNetwork: Single<Result<ViewPost, HTTPStatusCodes>>
    }
    
    func transform(input: Input) -> Output {
        return Output(writeButtonTap: input.writeButtonTap,
                      viewPostNetwork: input.viewPostNetwork)
    }
}
