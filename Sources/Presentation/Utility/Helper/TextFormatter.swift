//
//  TextFormatter.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation

struct TextFormatter {
    static func japaneseYearMonthText(from date: Date) -> String {
        let formatter = DateFormatter()
        let year = NSLocalizedString("Unit.Year", comment: "")
        let month = NSLocalizedString("Unit.Month", comment: "")
        formatter.dateFormat = "y\(year)M\(month)"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}
