//
//  DateFormatter+.swift
//  DateDayApp
//
//  Created by YJ on 8/21/24.
//

import Foundation

extension DateFormatter {
    static let dateToStringFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        return dateFormat
    }()
    
    static let stringToDateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        return dateFormat
    }()
}
