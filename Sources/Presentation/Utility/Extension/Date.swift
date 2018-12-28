//
//  Date.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation

extension Date {
    var firstDateOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }

    var lastDateOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDateOfMonth)!
    }

    var isFirstDateOfMonth: Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(self, inSameDayAs: self.firstDateOfMonth)
    }

    var endOfDay: Date {
        let calendar = Calendar(identifier: .gregorian)
        let nextDate = calendar.date(byAdding: .day, value: 1, to: self.startOfDay)!
        return calendar.date(byAdding: .second, value: -1, to: nextDate)!
    }

    var startOfDay: Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.startOfDay(for: self)
    }
}
