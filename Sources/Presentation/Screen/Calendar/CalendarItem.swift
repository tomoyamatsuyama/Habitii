//
//  CalendarItem.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation

struct CalendarItem {

    // MARK:- Property

    let date: Date
    let isDone: Bool

    // MARK: - Initializer

    init(date: Date, isDone: Bool) {
        self.date = date
        self.isDone = isDone
    }
}
