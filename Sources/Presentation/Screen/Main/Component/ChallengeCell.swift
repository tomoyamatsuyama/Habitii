//
//  ChallengeCell.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/23.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit

final class ChallengeCell: UITableViewCell {

    // MARK: - Outlet

    @IBOutlet weak var challengeView: UIView! {
        didSet {
            challengeView.layer.cornerRadius = 8.0
            challengeView.layer.borderColor = UIColor.orange.cgColor
            challengeView.layer.borderWidth = 1.0
        }
    }
}
