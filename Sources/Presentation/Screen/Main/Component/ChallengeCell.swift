//
//  ChallengeCell.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/23.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit
import SwipeCellKit

final class ChallengeCell: SwipeTableViewCell {

    // MARK: - Outlet

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var iconView: UIView! {
        didSet {
            iconView.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!

    // MARK:- Property

    var challenge: Challenge! {
        didSet {
            titleLabel.text = challenge.title
            countLabel.text = String(format: NSLocalizedString("Challenge.Count", comment: ""), challenge.count)

            switch challenge.count {
            case 0...3:
                iconImageView.image = UIImage(named: "egg")
            case 4...8:
                iconImageView.image = UIImage(named: "egg-chik")
            case 9...15:
                iconImageView.image = UIImage(named: "chik")
            default:
                iconImageView.image = UIImage(named: "bird")
            }
        }
    }
}
