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
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL + "v1"
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .validation:
            return .post
        case .login:
            return .post
        case .tokenRenewal:
            return .get
        case .viewPost:
            return .get
        case .viewPostImage:
            return .get
        case .postImage:
            return .post
        case .uploadPost:
            return .post
        case .viewSpecificPost:
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
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesac.rawValue: APIKey.secretkey,
            ]
        case .validation:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        case .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        case .tokenRenewal:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.refresh.rawValue: UserDefaultsManager.shared.refresh,
                Header.sesac.rawValue: APIKey.secretkey
            ]
        case .viewPost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.sesac.rawValue: APIKey.secretkey
            ]
            
        case .viewPostImage:
            return [
                Header.sesac.rawValue: APIKey.secretkey,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .postImage:
            return [
                Header.sesac.rawValue: APIKey.secretkey,
                Header.contentType.rawValue: Header.mutipart.rawValue,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .uploadPost:
            return [
                Header.sesac.rawValue: APIKey.secretkey,
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .viewSpecificPost:
            return [
                Header.sesac.rawValue: APIKey.secretkey,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
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
        default:
            return nil
        }
    }
}
