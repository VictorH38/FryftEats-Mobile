//
//  DateExtensions.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation

extension DateFormatter {
    static let customISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let flexibleISO8601 = custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        if let date = DateFormatter.customISO8601.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
    }
}
