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
