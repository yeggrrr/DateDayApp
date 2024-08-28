//
//  PostLike.swift
//  DateDayApp
//
//  Created by YJ on 8/28/24.
//

import Foundation

struct PostLike: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
