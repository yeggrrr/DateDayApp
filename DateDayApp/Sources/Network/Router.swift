//
//  Router.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation
import Alamofire

enum Router {
    case signUp(query: SignUpQuery)
    case validation(query: validEmailQuery)
    case login(query: LoginQuery)
    case tokenRenewal
    case viewPost(next: String)
    case viewPostImage(filePath: String)
    case postImage
    case uploadPost(query: UploadPostQuery)
    case viewSpecificPost(postID: String)
    case postInterest(postID: String, likeStatus: PostLikeQuery)
    case viewInterestPost(next: String)
    case postLike(postID: String, likeStatus: PostLikeQuery)
    case searchHashTag(next: String, hashTag: String)
    case viewMyProfile
    case editMyProfile(query: EditProfileQuery)
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .validation, .login, .postImage, .uploadPost, .postInterest, .postLike:
            return .post
        case .tokenRenewal, .viewPost, .viewPostImage, .viewSpecificPost, .viewInterestPost, .searchHashTag, .viewMyProfile:
            return .get
        case .editMyProfile:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        case .validation:
            return "/validation/email"
        case .login:
            return "/users/login"
        case .tokenRenewal:
            return "/auth/refresh"
        case .viewPost:
            return "/posts"
        case let .viewPostImage(filePath):
            return filePath
        case .postImage:
            return "/posts/files"
        case .uploadPost:
            return "/posts"
        case let .viewSpecificPost(postID):
            return "/posts/\(postID)"
        case let .postInterest(postID, _):
            return "/posts/\(postID)/like-2"
        case .viewInterestPost:
            return "/posts/likes-2/me"
        case let .postLike(postID, _):
            return "/posts/\(postID)/like"
        case .searchHashTag:
            return "/posts/hashtags"
        case .viewMyProfile:
            return "/users/me/profile"
        case .editMyProfile(query: let query):
            return "/users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp, .validation, .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesac.rawValue: APIKey.secretkey,
            ]
        case .tokenRenewal:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.refresh.rawValue: UserDefaultsManager.shared.refresh,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        case .viewPostImage, .viewPost, .viewSpecificPost, .postInterest, .uploadPost, .viewInterestPost, .postLike, .searchHashTag, .viewMyProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        case .postImage, .editMyProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.mutipart.rawValue,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .viewPost(let next):
            return [
                "next" : next,
                "limit" : "10",
                "product_id" : "yegrDateDay"
            ]
        case .viewInterestPost(let next):
            return [
                "next" : next,
                "limit" : "10"
            ]
            
        case .searchHashTag(let next, let hashTag):
            return [
                "next" : next,
                "limit" : "10",
                "product_id" : "yegrDateDay",
                "hashTag" : hashTag
            ]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .viewPost:
            return parameters?.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        case .viewInterestPost:
            return parameters?.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        case .searchHashTag:
            return parameters?.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        default:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .signUp(let query):
            return try? encoder.encode(query)
        case .validation(let query):
            return try? encoder.encode(query)
        case .login(let query):
            return try? encoder.encode(query)
        case .uploadPost(let query):
            return try? encoder.encode(query)
        case let .postInterest(_, likeStatus):
            return try? encoder.encode(likeStatus)
        case let .postLike(_, likeStatus):
            return try? encoder.encode(likeStatus)
        case let .editMyProfile(query):
            return try? encoder.encode(query)
        default:
            return nil
        }
    }
}
