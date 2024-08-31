//
//  Withdraw.swift
//  DateDayApp
//
//  Created by YJ on 8/31/24.
//

import Foundation

struct WithdrawModel: Decodable {
    let userId: String
    let email: String
    let nickname: String
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname = "nick"
    }
}
