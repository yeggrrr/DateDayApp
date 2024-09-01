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
