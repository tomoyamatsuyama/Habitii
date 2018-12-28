//
//  EmptyView.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/28.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit
import ChameleonFramework

final class EmptyView: UIView {

    // MARK: - Property

    private var label: UILabel!

    var title: String? {
        didSet {
            label.text = title
        }
    }

    override var frame: CGRect {
        didSet {
            label?.frame = frame
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: frame)
        setup()
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        label = UILabel(coder: aDecoder)
        setup()
        addSubview(label)
    }

    private func setup() {
        label.textColor = .flatOrange
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
    }
}
