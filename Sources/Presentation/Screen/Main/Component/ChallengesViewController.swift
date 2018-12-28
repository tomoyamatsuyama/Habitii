//
//  TodayChallengesViewController.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/23.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import SwipeCellKit
import ChameleonFramework

final class ChallengesViewController: UIViewController {

    // MARK: - Outlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK:- Property

    private var challenges: Results<Challenge>? {
        didSet {
            setEmptyView(for: "新しいこと\n始めますか？")
        }
    }
    private let realm = try! Realm()
    private let repository = ChallengeRepository()
    private let disposeBag = DisposeBag()
    private var mode: Mode = .today
    var mainViewController: MainViewController!

    // MARK: - Action

    @IBAction private func didSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mode = .today
            findTodayChallenges()
        case 1:
            mode = .all
            setupAllChallenges()
        default: break
        }
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        findTodayChallenges()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension ChallengesViewController {

    private enum Mode {
        case today
        case all
    }

    private func setup() {
        mainViewController.didAddChallengeSubject.subscribe(onNext: {
            switch self.mode {
            case .today: self.findTodayChallenges()
            case .all: self.setupAllChallenges()
            }
        })
        .disposed(by: disposeBag)
    }

    private func findTodayChallenges() {
        repository.findTodayChallenges()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] challenges in
                self?.challenges = challenges
                self?.tableView.reloadData()
                }, onError: { error in
                    // TODO: - error handling
                    print(error)
            })
            .disposed(by: disposeBag)
    }

    private func setupAllChallenges() {
        repository.findAll()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] challenges in
                self?.challenges = challenges
                self?.tableView.reloadData()
                }, onError: { error in
                    // TODO: - error handling
                    print(error)
            })
            .disposed(by: disposeBag)
    }

    private func markAsDone(of challenge: Challenge) {
        repository.markAsDone(challenge: challenge)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: {
            })
            .disposed(by: disposeBag)
    }

    private func delete(challenge: Challenge) {
        repository.delete(challenge: challenge)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: {
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    private func setEmptyView(for title: String) {
        if challenges?.isEmpty ?? true {
            let emptyView = EmptyView(frame: tableView.frame)
            emptyView.title = title
            tableView.tableHeaderView = emptyView
            tableView.tableFooterView = nil
        } else {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            tableView.tableHeaderView = nil
            tableView.tableFooterView = footerView
        }
    }
}

// MARK: - TableViewDelegate

extension ChallengesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateInitialViewController() as! CalendarViewController
        viewController.challenge = challenges?[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - TableViewDataSource

extension ChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeCell
        cell.delegate = self
        if let challenge = challenges?[indexPath.row] {
            cell.challenge = challenge
        }
        return cell
    }
}

// MARK: - SwipeTableViewCellDelegate

extension ChallengesViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        if orientation == .right && mode == .today {
            let doneAction = SwipeAction(style: .destructive, title: "完了") { (action, indexPath) in
                guard let challenge = self.challenges?[indexPath.row] else { fatalError("Error in donAction") }
                self.markAsDone(of: challenge)
                self.setEmptyView(for: "お疲れ！")
            }
            doneAction.image = UIImage(named: "check-mark")
            doneAction.backgroundColor = UIColor.flatOrange
            return [doneAction]
        } else if orientation == .left {
            var cancelFlag = false

            let deleteAction = SwipeAction(style: .destructive, title: "削除") { (action, indexPath) in
                let alert = UIAlertController(title: "削除", message: "本当に削除しますか？", preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "はい", style: .destructive, handler: { (deleteAction) in
                    guard let challenge = self.challenges?[indexPath.row] else { fatalError("Error in the doneAction") }
                    self.delete(challenge: challenge)
                    self.setEmptyView(for: "新しいこと\n始めますか？")
                })
                let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: { (cancelAction) in
                    cancelFlag = true
                })

                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            deleteAction.image = UIImage(named: "delete-icon")
            if cancelFlag {
                return nil
            }
            return [deleteAction]
        }

        return nil
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        if orientation == .right {
            options.expansionStyle = .destructive
        }
        return options
    }
}
