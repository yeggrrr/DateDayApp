//
//  Profile.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import Foundation

struct ViewMyProfileModel: Decodable {
    let userID: String
    let email: String
    let nickname: String
    let myIntroduce: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email = "email"
        case nickname = "nick"
        case myIntroduce = "phoneNum"
        case profileImage = "profileImage"
    }
}
