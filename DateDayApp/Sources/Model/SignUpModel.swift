//
//  SignUpModel.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation

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
