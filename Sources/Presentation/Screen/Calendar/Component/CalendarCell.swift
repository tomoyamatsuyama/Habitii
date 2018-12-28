//
//  CalendarCell.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit
import ChameleonFramework

final class CalendarCell: UICollectionViewCell {

    // MARK: - Outlet
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var doneView: UIView!

    // MARK:- Property

    var item: CalendarItem! {
        didSet {
            let calendar = Calendar(identifier: .gregorian)
            dateLabel.text = String(calendar.component(.day, from: item.date))

            isDone = item.isDone
        }
    }

    var width: CGFloat! {
        didSet {
            doneView.layer.cornerRadius = (width - 16) / 2
            doneView.layer.masksToBounds = true
        }
    }

    var isDone: Bool! {
        didSet {
            if isDone {
                doneView.backgroundColor = .flatOrange
            } else {
                doneView.backgroundColor = .clear
            }
        }
    }
}
