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
    case postInterest(postID: String, likeStatus: PostInterestQuery)
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .validation, .login, .postImage, .uploadPost, .postInterest:
            return .post
        case .tokenRenewal, .viewPost, .viewPostImage, .viewSpecificPost:
            return .get
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
        case let .postInterest(postID, likeStatus):
            return "/posts/\(postID)/like-2"
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
        case .viewPostImage, .viewPost, .viewSpecificPost, .postInterest, .uploadPost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        case .postImage:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.mutipart.rawValue,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .viewPost(let query):
            return [
                "next": query,
                "limit" : "10",
                "product_id" : "yegrDateDay"
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
        case let .postInterest(postID, likeStatus):
            return try? encoder.encode(likeStatus)
        default:
            return nil
        }
    }
}
