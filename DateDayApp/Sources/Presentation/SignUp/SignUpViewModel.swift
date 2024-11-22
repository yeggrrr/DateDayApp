//
//  SignUpViewModel.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    struct Input {
        let signUpButtonTap: ControlEvent<Void>
        let nicknameText: ControlProperty<String>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let signUpButtonTap: ControlEvent<Void>
        let nicknameValidation: Observable<Bool>
        let emailValidation: Observable<Bool>
        let passwordValidation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let nicknameValidation = input.nicknameText
            .map { self.validateNickname($0) }
        let emailValidation = input.emailText
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { self.validateEmail($0) }
        let passwordValidation = input.passwordText
            .map { self.validatePassword($0) }
        
        return Output(signUpButtonTap: input.signUpButtonTap,
                      nicknameValidation: nicknameValidation,
                      emailValidation: emailValidation,
                      passwordValidation: passwordValidation)
    }
    
    func validateNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "[A-Za-z][A-Za-z0-9]{2,}"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return nicknamePredicate.evaluate(with: nickname)
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "[A-Z][A-Za-z0-9!?#*]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
