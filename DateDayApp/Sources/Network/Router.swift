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
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
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
        case .tokenRenewal:
            return nil
        }
    }
}
