//
//  CalendarViewController.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/27.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit
import RxSwift

final class CalendarViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK:- Property

    private var calendarSections: [CalendarSection] = []
    private var cellWidth: CGFloat {
        return (collectionView.frame.size.width) / Constant.numOfColumn
    }
    private let presenter = CalendarPresenter()
    private let disposeBag = DisposeBag()
    private let repository = (
        challenge: ChallengeRepository(),
        challengeLog: ChallengeLogRepository()
    )
    private struct Constant {
        static let dayPerWeek: Int = 7
        static let headerHight: CGFloat = 35
        static let numOfColumn:CGFloat = 7
        static let cellHeight: CGFloat = 100
        static let cellSpace: CGFloat = 1.0
    }
    var challenge: Challenge!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension CalendarViewController {
    private func setup() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true

        navigationItem.title = challenge.title

        presenter.get(challenge: challenge)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] calendarSections in
                self?.calendarSections = calendarSections
                self?.collectionView.reloadData()
                self?.scroll()
                }, onError: { error in
                    print(error)
            })
            .disposed(by: disposeBag)
    }

    private func scroll(to date: Date = Date()) {
        let calendar = Calendar(identifier: .gregorian)
        let displayItem = calendar.component(.day, from: date.firstDateOfMonth)
            + (calendarSections[CalendarPresenter.Constant.monthRange].offset)
        let indexPath = IndexPath(item: displayItem - 1, section: CalendarPresenter.Constant.monthRange)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)

        var offset = collectionView.contentOffset
        offset.y -= Constant.headerHight
        collectionView.setContentOffset(offset, animated: false)
    }

    private func markAsDone(for date: Date) {
        repository.challenge.markAsDone(challenge: challenge, for: date)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: {
                self.presenter.get(challenge: self.challenge)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { [weak self] calendarSections in
                        self?.calendarSections = calendarSections
                        }, onError: { error in
                            print(error)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    private func deleteLog(for date: Date) {
        repository.challengeLog.delete(of: challenge, date: date)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: {
                self.presenter.get(challenge: self.challenge)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onSuccess: { [weak self] calendarSections in
                        self?.calendarSections = calendarSections
                        }, onError: { error in
                            print(error)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        let offset = calendarSections[indexPath.section].offset
        let item = calendarSections[indexPath.section].items[indexPath.row - offset]

        if item.date > Date() {
            return
        }
        if cell.isDone {
            deleteLog(for: item.date)
        } else {
            markAsDone(for: item.date)
        }
        cell.isDone = !cell.isDone
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarSections[section].numberOfItems
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendarSections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let offset = calendarSections[indexPath.section].offset

        if indexPath.row < offset {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
            let item = calendarSections[indexPath.section].items[indexPath.row - offset]
            cell.item = item
            cell.width = cellWidth
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calendarHeader", for: indexPath) as! CalendarHeaderView
        header.date = calendarSections[indexPath.section].yearMonth
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
