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
    
    // MARK: 포스트 좋아요 & 취소 (관심목록추가 - Like2)
    func postInterestStatus(interestStatus: Bool, postID: String) -> Single<Result<PostLike, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let query = PostLikeQuery(likeStatus: interestStatus)
                let request = try Router.postInterest(postID: postID, likeStatus: query).asURLRequest()
                
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostLike.self) { response in
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
    
    // MARK: 좋아요한 포스트 조회 - (관심목록추가 - Like2)
    func viewInterestList(next: String = "") -> Single<Result<ViewPost, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.viewInterestPost(next: next).asURLRequest()
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
    
    // MARK: 포스트 좋아요 & 취소 (좋아요 - Like)
    func postLikeStatus(likeStatus: Bool, postID: String) -> Single<Result<PostLike, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let query = PostLikeQuery(likeStatus: likeStatus)
                let request = try Router.postLike(postID: postID, likeStatus: query).asURLRequest()
                
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostLike.self) { response in
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
    
    // MARK: 해시태그 검색
    func searchHashTag(next: String = "", hashTag: String) -> Single<Result<SearchHashTag, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.searchHashTag(next: next, hashTag: hashTag).asURLRequest()
                
                AF.request(request)
                    .responseDecodable(of: SearchHashTag.self) { response in
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
    
    // MARK: 내 프로필 조회
    func viewMyProfile() -> Single<Result<ProfileModel, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.viewMyProfile.asURLRequest()
                AF.request(request)
                    .responseDecodable(of: ProfileModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
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
    
    func editProfile(nickname: String, introduce: String, profile: Data) -> Single<Result<EditProfileModel, HTTPStatusCodes>> {
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
    
    // MARK: 탈퇴
    func withdraw() -> Single<Result<WithdrawModel, HTTPStatusCodes>>{
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.withdraw.asURLRequest()
                AF.request(request)
                    .responseDecodable(of: WithdrawModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
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
    
    // MARK: 유저별 작성한 포스터 조회(내 포스터 조회)
    func viewSpecificUsersPost(userID: String, next: String = "") -> Single<Result<ViewPost, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.viewSpecificUsersPost(userID: userID, next: next).asURLRequest()
                AF.request(request)
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
    
    // MARK: 포스트 삭제
    func deletePost(postID: String, completion: @escaping (HTTPStatusCodes) -> Void) { // completion: @escaping
        do {
            let request = try Router.deletePost(postID: postID).asURLRequest()
            AF.request(request)
                .responseString { response in
                    let statusCode = response.response?.statusCode
                    switch statusCode {
                    case 200:
                        completion(.success)
                    case 401:
                        completion(.mismatchOrInvalid)
                    case 403:
                        completion(.mismatchOrInvalid)
                    case 410:
                        completion(.mismatchOrInvalid)
                    case 419:
                        completion(.mismatchOrInvalid)
                    case 445:
                        completion(.mismatchOrInvalid)
                    default:
                        break
                    }
                }
        } catch {
            print("error 발생!! - error:", error)
        }
    }
    
    // MARK: 결제 영수증 검증
    func paymentValidation(postID: String, impUID: String) -> Single<Result<ValidationModel, HTTPStatusCodes>>{
        return Single.create { observer -> Disposable in
            
            do {
                let query = PaymentValidationQuery(impUID: impUID, postID: postID)
                let request = try Router.paymentValidation(query: query).asURLRequest()
                
                AF.request(request)
                    .responseDecodable(of: ValidationModel.self) { response in
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
                            case 409:
                                observer(.success(.failure(.alreadySignedUp)))
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
    
    // MARK: 결제 내역 리스트 조회
    func viewPaymentList() -> Single<Result<PaymentListModel, HTTPStatusCodes>> {
        return Single.create { observer -> Disposable in
            
            do {
                let request = try Router.paymentList.asURLRequest()
                AF.request(request)
                    .responseDecodable(of: PaymentListModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            observer(.success(.success(success)))
                        case .failure(_):
                            let statusCode = response.response?.statusCode
                            switch statusCode {
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
}
