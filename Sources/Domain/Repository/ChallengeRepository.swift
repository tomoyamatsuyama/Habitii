//
//  ChallengeRepository.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/26.
//  Copyright © 2018 otsuka. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class ChallengeRepository {

    // MARK:- Property

    private let realm = try! Realm()

    // MARK: - Public

    func findAll() -> Single<Results<Challenge>> {
        return Single<Results<Challenge>>
            .create(subscribe: { observer in
                let objects = self.realm.objects(Challenge.self).sorted(byKeyPath: "createdDate")
                observer(.success(objects))

                return Disposables.create()
            })
            .subscribeOn(MainScheduler.instance)
    }

    func findTodayChallenges() -> Single<Results<Challenge>> {
        return Single<Results<Challenge>>
            .create(subscribe: { observer in
                let calendar = Calendar(identifier: .gregorian)
                let objects = self.realm.objects(Challenge.self).filter("lastDoneDate == nil OR lastDoneDate =< %@",
                                                                        calendar.startOfDay(for: Date()))
                    .sorted(byKeyPath: "createdDate")
                observer(.success(objects))
                return Disposables.create()
            })
            .subscribeOn(MainScheduler.instance)
    }

    func markAsDone(challenge: Challenge, for date: Date = Date()) -> Single<Void> {
        return Single<Void>
            .create(subscribe: { observer in
                do {
                    try self.realm.write {
                        let log = ChallengeLog()
                        log.date = date
                        challenge.lastDoneDate = date
                        challenge.count += 1
                        challenge.logs.append(log)
                    }
                    observer(.success(()))
                } catch let error as NSError {
                    observer(.error(error))
                }

                return Disposables.create()
            })
            .subscribeOn(MainScheduler.instance)
    }

    func save(challenge: Challenge) -> Single<Void> {
        return Single<Void>
            .create(subscribe: { observer in
                do {
                    try self.realm.write {
                        self.realm.add(challenge)
                    }
                    observer(.success(()))
                } catch let error as NSError {
                    observer(.error(error))
                }

                return Disposables.create()
            })
            .subscribeOn(MainScheduler.instance)
    }

    func delete(challenge: Challenge) -> Single<Void> {
        return Single<Void>
            .create(subscribe: { observer in
                do {
                    try self.realm.write {
                        self.realm.delete(challenge)
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
