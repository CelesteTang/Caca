//
//  RecordTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Record"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        view.backgroundColor = Palette.backgoundColor

        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordTableViewCell")
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Caca.cacas.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.dateLabel.text = Caca.cacas[indexPath.row].date
        cell.rowView.passOrFailLabel.text = "Pass"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let currentCell = tableView.cellForRow(at: indexPath) as? RecordTableViewCell else {
                return
        }
        print(currentCell.rowView.dateLabel.text ?? "")

        let storyBoard = UIStoryboard(name: "RecordDetail", bundle: nil)
        guard let recordDetailViewController = storyBoard.instantiateViewController(withIdentifier: "RecordDetailViewController") as? RecordDetailViewController else { return }

        recordDetailViewController.recievedCaca = [Caca.cacas[indexPath.row]]

        self.navigationController?.pushViewController(recordDetailViewController, animated: true)
    }

    func setUp() {

    }

}
