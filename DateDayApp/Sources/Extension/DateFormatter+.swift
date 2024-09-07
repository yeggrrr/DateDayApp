//
//  DateFormatter+.swift
//  DateDayApp
//
//  Created by YJ on 8/21/24.
//

import Foundation

extension DateFormatter {
    static let containTimeDateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        return dateFormat
    }()
    
    static let koreanDateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        return dateFormat
    }()
    
    static let stringToDateFormatter: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_KR")
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormat
    }()
    
    static func dateToContainLetter(dateString: String) -> String {
        guard let date = DateFormatter.stringToDateFormatter.date(from: dateString) else { return "-" }
        return DateFormatter.koreanDateFormatter.string(from: date)
    }
    
    static func dateToContainHour(dateString: String) -> String {
        guard let date = DateFormatter.stringToDateFormatter.date(from: dateString) else { return "-" }
        return DateFormatter.containTimeDateFormatter.string(from: date)
    }
}
