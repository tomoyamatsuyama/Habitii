//
//  CalendarPresenter.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation
import RxSwift

struct CalendarPresenter {

    // MARK:- Property

    private let repository = ChallengeLogRepository()
    private let disposeBag = DisposeBag()
    private let calendar = Calendar(identifier: .gregorian)

    struct Constant {
        static let monthRange = 24
    }

    // MARK: - Public

    func get(challenge: Challenge, today: Date = Date()) -> Single<[CalendarSection]> {
        return repository.getLogs(of: challenge)
            .flatMap { logs -> Single<[CalendarSection]> in
                var calendarSections: [CalendarSection] = []
                var date: Date

                for month in -Constant.monthRange...Constant.monthRange {
                    date = self.calendar.date(byAdding: .month, value: month, to: today)!
                    let firstDayOfMonth = date.firstDateOfMonth
                    let daysCountInMonth = self.calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count

                    var items: [CalendarItem] = []

                    for day in 0..<daysCountInMonth! {
                        let day = self.calendar.date(byAdding: .day, value: day, to: firstDayOfMonth)!
                        let challengeLog = logs.filter { self.calendar.isDate($0.date, inSameDayAs: day) }.first
                        let isDone = (challengeLog != nil)
                        items.append(CalendarItem(date: day , isDone: isDone))
                    }
                    calendarSections.append(CalendarSection(yearMonth: date, items: items))
                }

                return .just(calendarSections)
            }
    }
}
