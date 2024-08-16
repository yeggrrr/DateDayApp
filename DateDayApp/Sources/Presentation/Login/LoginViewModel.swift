//
//  LoginViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    struct Input {
        let loginButtonTap: ControlEvent<Void>
        let signUpButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let loginButtonTap: ControlEvent<Void>
        let signUpButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(loginButtonTap: input.loginButtonTap,
                      signUpButtonTap: input.signUpButtonTap)
    }
}
