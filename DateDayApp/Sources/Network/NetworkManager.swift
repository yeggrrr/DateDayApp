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
import iamport_ios

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    // MARK: 회원인증 - Token 필요X
    func requestUserVerification<T: Decodable>(api: Router, type: T.Type) -> Single<Result<T, HTTPError>> {
        return Single.create { observer -> Disposable in
                do {
                    let request = try api.asURLRequest()
                    AF.request(request)
                        .responseDecodable(of: T.self) { response in
                            switch response.result {
                            case .success(let success):
                                observer(.success(.success(success)))
                            case .failure(_):
                                let statusCode = response.response?.statusCode
                                switch statusCode {
                                case 418:
                                    observer(.success(.failure(.refreshTokenExpiration)))
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
    
    // MARK: CallRequest 메서드 - multipart 제외
    func callRequest<T: Decodable>(api: Router, type: T.Type) -> Single<Result<T, HTTPError>> {
        return Single.create { observer -> Disposable in
            self.updateToken { _ in
                do {
                    let request = try api.asURLRequest()
                    AF.request(request)
                        .responseDecodable(of: T.self) { response in
                            switch response.result {
                            case .success(let success):
                                observer(.success(.success(success)))
                            case .failure(_):
                                let statusCode = response.response?.statusCode
                                switch statusCode {
                                case 418:
                                    observer(.success(.failure(.refreshTokenExpiration)))
                                default:
                                        break
                                }
                            }
                        }
                } catch {
                    print("error 발생!! - error:", error)
                }
            }
            
            return Disposables.create()
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
    
    // MARK: 포스트 이미지 업로드
    func uploadImage(images: [UIImage]) -> Single<Result<UploadImageModel, HTTPError>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.postImage.asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
                    for image in images {
                        if let image = image.jpegData(compressionQuality: 0.5) {
                            multipartFormData.append(image, withName: "files", fileName: "yegr.jpeg", mimeType: "image/jpeg")
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
    
    // MARK: 프로필 편집
    func editProfile(nickname: String, introduce: String, profile: Data) -> Single<Result<EditProfileModel, HTTPError>> {
        return Single.create { observer -> Disposable in
            
            do {
                let query = EditProfileQuery(nick: nickname, phoneNum: introduce, profile: profile)
                let request = try Router.editMyProfile(query: query).asURLRequest()
                AF.upload(multipartFormData: { multipartFormData in
                    let nick = query.nick.data(using: .utf8) ?? Data()
                    let introduce = query.phoneNum.data(using: .utf8) ?? Data()
                    multipartFormData.append(nick, withName: "nick")
                    multipartFormData.append(introduce, withName: "phoneNum")
                    multipartFormData.append(
                        profile,
                        withName: "profile",
                        fileName: "yegr.jpeg",
                        mimeType: "image/jpeg")
                }, with: request)
                .responseDecodable(of: EditProfileModel.self) { response in
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
                        case 402:
                            observer(.success(.failure(.noSpacesAllowed)))
                        case 403:
                            observer(.success(.failure(.forbidden)))
                        case 409:
                            observer(.success(.failure(.alreadySignedUp)))
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
    
    // MARK: 포스트 삭제
    func deletePost(postID: String, completion: @escaping (HTTPError) -> Void) {
        do {
            let request = try Router.deletePost(postID: postID).asURLRequest()
            AF.request(request)
                .responseString { response in
                    let statusCode = response.response?.statusCode
                    switch statusCode {
                    case 200:
                        completion(.success)
                    default:
                        completion(.mismatchOrInvalid)
                    }
                }
        } catch {
            print("error 발생!! - error:", error)
        }
    }
    
    // MARK: 카카오 위치 검색
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
    
    // MARK: Token 갱신 API
    func tokenUpdate(completion: @escaping (Result<TokenUpdateModel, HTTPError>) -> Void) {
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
    
    // MARK: 토큰 자동 갱신 시간 계산
    func updateToken(completion: @escaping (String) -> Void) {
        // 로그인 시, 저장한 시간
        let stringSaveTime = UserDefaultsManager.shared.saveTime
        // 저장한 시간 Date로 변환
        guard let dateSaveTime = DateFormatter.containTimeDateFormatter.date(from: stringSaveTime) else { return }
        // 저장 시간 4분 45초 후, Date 정보
        let justBeforeTokenExpiration = Date(timeInterval: 285, since: dateSaveTime)
        // 만약, 4분 45초가 지났다면?
        if justBeforeTokenExpiration < Date() {
            print("곧 만료됨! 갱신 준비!")
            NetworkManager.shared.tokenUpdate { result in
                switch result {
                case .success(let success):
                    UserDefaultsManager.shared.token = success.accessToken
                    completion(success.accessToken)
                case .failure(let failure):
                    switch failure {
                    case .refreshTokenExpiration:
                        print(">>> refresh만료! 로그인 화면으로 이동")
                        completion("refresh만료!")
                    default:
                        break
                    }
                }
            }
        } else {
            completion("토큰 유효")
            print("아직 만료 안됨! 굳이 갱신 X")
        }
    }
}
