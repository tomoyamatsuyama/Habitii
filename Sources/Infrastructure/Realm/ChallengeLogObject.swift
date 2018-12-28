//
//  ChallengeLog.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/26.
//  Copyright © 2018 otsuka. All rights reserved.
//

import RealmSwift

final class ChallengeLog: Object {
    @objc dynamic var date: Date!
    let challenges = LinkingObjects(fromType: Challenge.self, property: "logs")
}
