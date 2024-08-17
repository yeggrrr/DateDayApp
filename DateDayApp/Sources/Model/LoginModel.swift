//
//  LoginModel.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import Foundation

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
