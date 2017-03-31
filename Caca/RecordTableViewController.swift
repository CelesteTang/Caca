//
//  RecordTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class RecordTableViewController: UITableViewController {

    var cacas = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Record"

        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        view.backgroundColor = Palette.backgoundColor

        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordTableViewCell")

        let provider = CacaProvider.shared

        provider.getCaca { (cacas, _) in

            if let cacas = cacas {
                self.cacas = cacas
            }
            self.tableView.reloadData()

        }

    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cacas.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        // swiftlint:enable force_cast

        if cacas[indexPath.row].photo != "" {
            if let url = URL(string: cacas[indexPath.row].photo) {

                do {
                    let data = try Data(contentsOf: url)
                    cell.rowView.cacaPhotoImageView.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            }
        } else {

            cell.rowView.cacaPhotoImageView.image = #imageLiteral(resourceName: "poo-icon")

        }

        cell.rowView.dateLabel.text = self.cacas[indexPath.row].date
        cell.rowView.timeLabel.text = self.cacas[indexPath.row].time
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

        recordDetailViewController.recievedCaca = [self.cacas[indexPath.row]]

        self.navigationController?.pushViewController(recordDetailViewController, animated: true)
    }

}
