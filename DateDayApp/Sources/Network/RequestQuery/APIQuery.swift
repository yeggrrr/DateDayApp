//
//  APIQuery.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation

struct SignUpQuery: Encodable {
    let nick: String
    let email: String
    let password: String
}

struct validEmailQuery: Encodable {
    let email: String
}

struct LoginQuery: Encodable {
    let email: String
    let password: String
}

struct UploadPostQuery: Encodable {
    let title: String
    let price: Int = 100
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let product_id: String = "TestProcutID" // yegrDateDay: DummyID
    let files: [String]
}

struct PostLikeQuery: Encodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

struct EditProfileQuery: Encodable {
    let nick: String
    let phoneNum: String
    let profile: Data
}
