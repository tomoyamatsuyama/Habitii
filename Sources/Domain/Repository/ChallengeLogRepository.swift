//
//  ChallengeLogRepository.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class ChallengeLogRepository {

    // MARK:- Property

    private let realm = try! Realm()

    // MARK: - Public

    func getLogs(of challenge: Challenge) -> Single<List<ChallengeLog>> {
        return Single<List<ChallengeLog>>
            .create(subscribe: { observer in
                let objects = challenge.logs
                observer(.success(objects))
                return Disposables.create()
            })
            .subscribeOn(MainScheduler.instance)
    }

    func delete(of challenge: Challenge, date: Date) -> Single<Void> {
        return Single<Void>
            .create(subscribe: { observer in
                let object = challenge.logs.filter("date == %@", date.startOfDay)
                do {
                    try self.realm.write {
                        self.realm.delete(object)
                        challenge.count -= 1
                        if date == Date().startOfDay {
                            challenge.lastDoneDate = nil
                        }
                    }
                    observer(.success(()))
                } catch let error as NSError {
                    observer(.error(error))
                }
                return Disposables.create()
            })
            .subscribeOn(MainScheduler.instance)
    }
}
