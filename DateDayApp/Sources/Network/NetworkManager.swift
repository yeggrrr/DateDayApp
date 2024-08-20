//
//  NetworkManager.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum ValidationError: Error {
    case missingRequiredValue
    case unavailable
    case accountVerificationRequired
    case alreadySignedUp
    case nicknamesContainingSpaces
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func createSignUp(nickname: String, email: String, password: String) -> Single<Result<SignUpModel, ValidationError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = SignUpQuery(nick: nickname, email: email, password: password)
                let request = try Router.signUp(query: query).asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: SignUpModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
                            case 400:
                                observer(.success(.failure(.missingRequiredValue)))
                            case 402:
                                observer(.success(.failure(.nicknamesContainingSpaces)))
                            case 409:
                                observer(.success(.failure(.alreadySignedUp)))
                            default:
                                break
                            }
                        }
                    }
            } catch {
                print("error 발생!! - error:", error)
            }
            
            return Disposables.create()
        }
        .debug("signUp 네트워크 통신")
        
    }
    
    func validationEmail(email: String) -> Single<Result<ValidationEmailModel, ValidationError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = validEmailQuery(email: email)
                let request = try Router.validation(query: query).asURLRequest()
                
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ValidationEmailModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
                            case 400:
                                observer(.success(.failure(.missingRequiredValue)))
                            case 409:
                                observer(.success(.failure(.unavailable)))
                            default:
                                break
                            }
                        }
                    }
                
            } catch {
                print("error 발생!! - error:", error)
            }
            
            return Disposables.create()
        }
        .debug("validationEmail 네트워크 통신")
    }
    
    func createLogin(email: String, password: String) -> Single<Result<LoginModel, ValidationError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = LoginQuery(email: email, password: password)
                let request = try Router.login(query: query).asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
                            case 400:
                                observer(.success(.failure(.missingRequiredValue)))
                            case 401:
                                observer(.success(.failure(.accountVerificationRequired)))
                            default:
                                break
                            }
                        }
                    }
            } catch {
                print("error 발생!! - error:", error)
            }
            return Disposables.create()
        }
        .debug("createLogin 네트워크 통신")
    }
}
