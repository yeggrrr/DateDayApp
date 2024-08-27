//
//  SearchLocation.swift
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
