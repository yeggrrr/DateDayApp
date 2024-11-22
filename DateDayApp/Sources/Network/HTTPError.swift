//
//  HTTPError.swift
//  DateDayApp
//
//  Created by YJ on 8/21/24.
//

import Foundation

enum HTTPError: Error {
    /// 200
    case success
    /// 400 - 잘못된 요청 & 필수값 필요
    case missingRequiredValue
    /// 401 - 계정 확인 & 유효하지 않음
    case mismatchOrInvalid
    /// 402
    case noSpacesAllowed
    /// 403
    case forbidden
    /// 409 - 사용 불가
    case alreadySignedUp
    /// 410 - DB서버 장애로 포스트가 저장되지 않음
    case serverErrorNotSavedOrCannotSearch
    /// 418
    case refreshTokenExpiration
    /// 419
    case accessTokenExpiration
    /// 420
    case checkPrimaryKey
    /// 429
    case overcall
    /// 444
    case invalidURL
    /// 445
    case noPermission
    /// 500
    case serverError
}
