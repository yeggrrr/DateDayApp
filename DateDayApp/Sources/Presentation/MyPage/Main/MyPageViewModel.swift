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
    private let disposeBag = DisposeBag()

    struct Input {
        let interestButtonTap: ControlEvent<Void>
        let editProfileButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let interestButtonTap: ControlEvent<Void>
        let editProfileButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            interestButtonTap: input.interestButtonTap,
            editProfileButtonTap: input.editProfileButtonTap)
    }
}
