//
//  Payment.swift
//  DateDayApp
//
//  Created by YJ on 9/2/24.
//

import Foundation

struct ValidationModel: Decodable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}

struct PaymentListModel: Decodable {
    let data: [PaymentData]
    
    struct PaymentData: Decodable {
        let buyerID: String
        let postID: String
        let merchantUID: String
        let productName: String
        let price: Int
        let paidAt: String
        
        enum CodingKeys: String, CodingKey {
            case buyerID = "buyer_id"
            case postID = "post_id"
            case merchantUID = "merchant_uid"
            case productName, price, paidAt
        }
    }
}
