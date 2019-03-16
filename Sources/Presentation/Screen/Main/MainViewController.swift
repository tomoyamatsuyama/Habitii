//
//  MainViewController.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/23.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {

    // MARK:- Property

    private let repository = ChallengeRepository()
    private let disposeBag = DisposeBag()
    let didAddChallengeSubject = PublishSubject<Void>()

    // MARK: - Action

    @IBAction private func didTapAddButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Habit", message: "新しいことを始めましょう", preferredStyle: .alert)
        var textField = UITextField()
        let createAction = UIAlertAction(title: "頑張る", style: .default) { (action) in
            if textField.text != "" {
                let challenge = Challenge()
                challenge.title = textField.text
                self.repository.save(challenge: challenge)
                    .subscribe(onSuccess: {
                        self.didAddChallengeSubject.onNext(())
                    })
                    .disposed(by: self.disposeBag)
            }
        }
        let cancelAction = UIAlertAction(title: "やっぱやめる", style: .cancel, handler: nil)

        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "筋トレ"
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Lifecycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let challengeViewController = segue.destination as? ChallengesViewController {
            challengeViewController.mainViewController = self
        }
    }
}
