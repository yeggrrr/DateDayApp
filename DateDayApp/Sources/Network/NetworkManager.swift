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

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    // MARK: 회원가입
    func createSignUp(nickname: String, email: String, password: String) -> Single<Result<SignUpModel, HTTPStatusCodes>> {
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
                                observer(.success(.failure(.noSpacesAllowed)))
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
    }
    
    // MARK: 이메일 중복 확인
    func validationEmail(email: String) -> Single<Result<ValidationEmailModel, HTTPStatusCodes>> {
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
    }
    
    // MARK: 로그인
    func createLogin(email: String, password: String) -> Single<Result<LoginModel, HTTPStatusCodes>> {
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
                                observer(.success(.failure(.mismatchOrInvalid)))
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
    }
    
    // MARK: Token 갱신
    func tokenUpdate(completion: @escaping (Result<TokenUpdateModel, HTTPStatusCodes>) -> Void) {
        do {
            let request = try Router.tokenRenewal.asURLRequest()
            
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TokenUpdateModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(_):
                        let statusCode = response.response?.statusCode
                        switch statusCode {
                        case 401:
                            completion(.failure(.mismatchOrInvalid))
                        default:
                            break
                        }
                    }
                }
        } catch {
            print("error 발생!! - error:", error)
        }
    }
    
    // MARK: 게시글 조회
    func viewPost() -> Single<Result<ViewPost, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try Router.viewPost.asURLRequest()
                
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: ViewPost.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
                            case 400:
                                observer(.success(.failure(.missingRequiredValue)))
                            case 401:
                                observer(.success(.failure(.mismatchOrInvalid)))
                            case 403:
                                observer(.success(.failure(.forbidden)))
                            case 419:
                                observer(.success(.failure(.accessTokenExpiration)))
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
        .debug("viewPost 네트워크 통신")
    }
}
