//
//  MembershipVerification.swift
//  DateDayApp
//
//  Created by YJ on 8/21/24.
//

import Foundation

// MARK: 회원가입
struct SignUpModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case nick = "nick"
    }
}

// MARK: 이메일 중복 확인
struct ValidationEmailModel: Decodable {
    let message: String
}

// MARK: 로그인
struct LoginModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case nick = "nick"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
}
