//
//  CalendarHeaderView.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit

final class CalendarHeaderView: UICollectionReusableView {

    // MARK: - Outlet

    @IBOutlet private weak var yearMonthLabel: UILabel!

    // MARK:- Property

    var date: Date! {
        didSet {
            yearMonthLabel.text = TextFormatter.japaneseYearMonthText(from: date.firstDateOfMonth)
        }
    }
}
