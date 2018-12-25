//
//  TodayChallengesViewController.swift
//  30DaysChallenges
//
//  Created by 大塚悠貴 on 2018/12/23.
//  Copyright © 2018 otsuka. All rights reserved.
//

import UIKit

final class TodayChallengesViewController: UIViewController {
}

// MARK: - TableViewDelegate

extension TodayChallengesViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TableViewDataSource

extension TodayChallengesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeCell

        return cell
    }
}
