//
//  Challenge.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/25.
//  Copyright © 2018 otsuka. All rights reserved.
//

import RealmSwift

final class Challenge: Object {
    @objc dynamic var title: String!
    @objc dynamic var count: Int = 0
    @objc dynamic var lastDoneDate: Date?
    @objc dynamic var createdDate = Date()
    let logs = List<ChallengeLog>()
}
