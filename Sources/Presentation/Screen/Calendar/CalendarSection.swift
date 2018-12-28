//
//  CalendarSection.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation

struct CalendarSection {

    // MARK:- Property

    private let calendar = Calendar(identifier: .gregorian)

    let yearMonth: Date
    let offset: Int
    let items: [CalendarItem]

    var numberOfItems: Int {
        return items.count + offset
    }

    // MARK: - Initializer

    init(yearMonth: Date, items: [CalendarItem]) {
        self.yearMonth = yearMonth
        self.offset = calendar.component(.weekday, from: yearMonth.firstDateOfMonth) - 1
        self.items = items
    }
}
