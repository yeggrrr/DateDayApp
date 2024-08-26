//
//  ViewPost.swift
//  DateDayApp
//
//  Created by YJ on 8/21/24.
//

import Foundation

struct ViewPost: Decodable {
    let data: [PostData]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    struct PostData: Decodable {
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
        let buyers: [String]
        let hashTags: [String]
        
        enum CodingKeys: String, CodingKey {
            case postId = "post_id"
            case productId = "product_id"
            case title
            case price
            case content
            case starRating = "content1"
            case longitude = "content2"
            case latitude = "content3"
            case detailURL = "content4"
            case category = "content5"
            case createdAt
            case creator
            case imageFiles = "files"
            case likes
            case interest = "likes2"
            case buyers
            case hashTags
        }
        
        struct Creator: Decodable {
            let userID: String
            let nick: String
            
            enum CodingKeys: String, CodingKey {
                case userID = "user_id"
                case nick
            }
        }
    }
}
