//
//  Profile.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import Foundation

// 프로필 조회
struct ProfileModel: Decodable {
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

// 프로필 수정
struct EditProfileModel: Decodable {
    let userID: String
    let nickname: String
    let myIntroduce: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname = "nick"
        case myIntroduce = "phoneNum"
        case profileImage = "profileImage"
    }
}
