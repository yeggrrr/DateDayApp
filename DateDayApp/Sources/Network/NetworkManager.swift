//
//  NetworkManager.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit
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
    
    // MARK: 게시글 이미지 조회
    func viewPostImage(filePath: String, completion: @escaping (Data) -> Void) {
        do {
            let request = try Router.viewPostImage(filePath: filePath).asURLRequest()
            AF.request(request).responseString { response in
                if let imageData = response.data {
                    completion(imageData)
                }
            }
        } catch {
            print("error!!: \(error)")
        }
    }
    
    // MARK: 게시글 조회
    func viewPost(next: String = "") -> Single<Result<ViewPost, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            do {
                let request = try Router.viewPost(next: next).asURLRequest()
                
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
    }
    
    // MARK: 특정 포스트 조회
    func viewSpecificPost(postID: String) -> Single<Result<UploadPostModel, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.viewSpecificPost(postID: postID).asURLRequest()
                AF.request(request)
                    .responseDecodable(of: UploadPostModel.self) { response in
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
    }
    
    // MARK: 위치 검색
    func searchLocation(query: String) -> Single<SearchLocationModel> {
        let url = APIKey.kakaoURL
        
        let header: HTTPHeaders = [
            "Authorization" : APIKey.kakaoKey
        ]
        
        let param: Parameters = [
            "query": query
        ]
        
        return Single.create { observer in
            AF.request(url, method: .get, parameters: param, headers: header)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SearchLocationModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer(.success(success))
                    case .failure(let failure):
                        observer(.failure(failure))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    // MARK: 포스트 이미지 업로드
    func uploadImage(images: [UIImage]) -> Single<Result<UploadImageModel, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.postImage.asURLRequest()
                
                AF.upload(multipartFormData: { mulitpartFormData in
                    for image in images {
                        if let image = image.pngData() {
                            mulitpartFormData.append(image, withName: "files", fileName: "yegr.png", mimeType: "image/png")
                        }
                    }
                }, with: request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UploadImageModel.self) { response in
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
    }
    
    // MARK: 포스트 작성
    func uploadPost(uploadQuery: UploadPostQuery) -> Single<Result<UploadPostModel, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.uploadPost(query: uploadQuery).asURLRequest()
                
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: UploadPostModel.self) { response in
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
                            case 410:
                                observer(.success(.failure(.serverErrorNotSavedOrCannotSearch)))
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
    }
}
