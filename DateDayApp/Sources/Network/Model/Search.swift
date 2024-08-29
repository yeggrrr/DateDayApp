//
//  Search.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import Foundation

struct SearchLocationModel: Decodable {
    let documents: [Documents]
    let meta: Meta
    
    struct Documents: Decodable {
        let addressName: String
        let categoryName: String
        let placeName: String
        let placeURL: String
        let x: String
        let y: String
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case categoryName = "category_name"
            case placeName = "place_name"
            case placeURL = "place_url"
            case x
            case y
        }
    }
    
    struct Meta: Decodable {
        let isEnd: Bool
        let pageableCount: Int
        let totalCount: Int
        
        enum CodingKeys: String, CodingKey {
            case isEnd = "is_end"
            case pageableCount = "pageable_count"
            case totalCount = "total_count"
        }
    }
}

struct SearchHashTag: Decodable {
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
        let comments: [Comments]
        
        enum CodingKeys: String, CodingKey {
            case postId = "post_id"
            case productId = "product_id"
            case starRating = "content1"
            case longitude = "content2"
            case latitude = "content3"
            case detailURL = "content4"
            case category = "content5"
            case imageFiles = "files"
            case interest = "likes2"
            case title, content, createdAt, creator, likes, hashTags, comments
        }
        
        struct Creator: Decodable {
            let userID: String?
            let nick: String?
            let profileImage: String?
            
            enum CodingKeys: String, CodingKey {
                case userID = "user_id"
                case nick, profileImage
            }
        }
        
        struct Comments: Decodable {
            let commentID: String
            let content: String
            let createdAt: String
            let creator: Creator
            
            enum CodingKeys: String, CodingKey {
                case commentID = "comment_id"
                case content, createdAt, creator
            }
            
            struct Creator: Decodable {
                let userID: String?
                let nick: String?
                let profileImage: String?
                
                enum CodingKeys: String, CodingKey {
                    case userID = "user_id"
                    case nick, profileImage
                }
            }
        }
    }
}
