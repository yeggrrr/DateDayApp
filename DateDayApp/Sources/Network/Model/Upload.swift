//
//  Upload.swift
//  DateDayApp
//
//  Created by YJ on 8/25/24.
//

import Foundation

struct UploadImageModel: Decodable {
    let files: [String]
}
// 포스트 업로드 & 특정 포스트 조회
struct UploadPostModel: Decodable {
    let postId: String
    let productId: String
    let title: String
    let price: Int
    let content: String
    let starRating: String
    let longitude: String
    let latitude: String
    let detailURL: String
    let category: String
    let createdAt: String
    let creator: Creator
    let imageFiles: [String]
    let likes: [String]
    let interest: [String]
    let hashTags: [String]
    let comments: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case starRating = "content1"
        case longitude = "content2"
        case latitude = "content3"
        case detailURL = "content4"
        case category = "content5"
        case imageFiles = "files"
        case interest  = "likes2"
        case title, price, content, createdAt, creator, likes, hashTags, comments
    }
    
    struct Creator: Decodable {
        let userId: String
        let nick: String
        let profileImage: String?
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case nick, profileImage
        }
    }
}
