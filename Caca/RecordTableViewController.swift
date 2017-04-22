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

    var isCovered = false

    var coverButtonTitle = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordTableViewCell")

        CacaProvider.shared.getCaca { (cacas, _) in

            if let cacas = cacas {
                self.cacas = cacas
            }

            self.tableView.reloadData()

        }

    }

    // MARK: Set Up

    private func setUp() {

        self.navigationItem.title = "Record"
        self.view.backgroundColor = Palette.lightblue2

        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem

        self.tableView.separatorStyle = .none

        if UserDefaults.standard.bool(forKey: "Hide") == true {

            coverButtonTitle = "Show"

        } else {

            coverButtonTitle = "Hide"

        }

        let coverButton = UIBarButtonItem(title: coverButtonTitle, style: .plain, target: self, action: #selector(coverCaca))
        self.navigationItem.leftBarButtonItem = coverButton

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCaca))
        self.navigationItem.rightBarButtonItem = addButton

//        let image = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = image
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.view.backgroundColor = UIColor.clear
    }

    func coverCaca() {

        if isCovered == false {

            isCovered = true
            UserDefaults.standard.set(isCovered, forKey: "Hide")
            coverButtonTitle = "Show"
            self.tableView.reloadData()

        } else {

            isCovered = false
            UserDefaults.standard.set(isCovered, forKey: "Hide")
            coverButtonTitle = "Hide"
            self.tableView.reloadData()

        }

    }

    func addCaca() {

        let fillinStorybard = UIStoryboard(name: "Fillin", bundle: nil)
        guard let fillinViewController = fillinStorybard.instantiateViewController(withIdentifier: "FillinTableViewController") as? FillinTableViewController else { return }

        fillinViewController.isFromRecord = true

        present(fillinViewController, animated: true)

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

        cell.rowView.cacaPhotoImageView.image = #imageLiteral(resourceName: "caca-small")

        cell.rowView.separateLineView.backgroundColor = Palette.darkblue

        if UserDefaults.standard.bool(forKey: "Hide") == false {

            if cacas[indexPath.row].photo != "" {

                DispatchQueue.global().async {

                    if let url = URL(string: self.cacas[indexPath.row].photo) {

                        do {
                            let data = try Data(contentsOf: url)
                            let image = UIImage(data: data)

                            DispatchQueue.main.async {

                                cell.rowView.cacaPhotoImageView.image = image
                                cell.rowView.cacaPhotoImageView.layer.cornerRadius = cell.rowView.cacaPhotoImageView.frame.width / 2
                                cell.rowView.cacaPhotoImageView.layer.masksToBounds = true

                            }

                        } catch {

                            print(error.localizedDescription)

                        }
                    }
                }
            }
        }

        cell.rowView.dateLabel.text = self.cacas[indexPath.row].date
        cell.rowView.timeLabel.text = self.cacas[indexPath.row].time

        let backgroundView = UIView()

        if self.cacas[indexPath.row].grading == true {

            cell.rowView.passOrFailLabel.text = "Pass"
            cell.rowView.passOrFailLabel.textColor = Palette.passColor
            backgroundView.backgroundColor = Palette.selectedPassColor
            cell.selectionStyle = .default

        } else {

            cell.rowView.passOrFailLabel.text = "Fail"
            cell.rowView.passOrFailLabel.textColor = Palette.failColor
            backgroundView.backgroundColor = Palette.selectedFailColor
            cell.selectionStyle = .default

        }

        cell.selectedBackgroundView = backgroundView

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyBoard = UIStoryboard(name: "RecordDetail", bundle: nil)
        guard let recordDetailViewController = storyBoard.instantiateViewController(withIdentifier: "RecordDetailViewController") as? RecordDetailViewController else {
            return
        }

        recordDetailViewController.recievedCaca = [self.cacas[indexPath.row]]
        recordDetailViewController.indexPath = indexPath

        self.navigationController?.pushViewController(recordDetailViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            CacaProvider.shared.deleteCaca(of: self.cacas[indexPath.row].cacaID)
            CacaProvider.shared.deleteCacaPhoto(of: self.cacas[indexPath.row].photoID)
            self.cacas.remove(at: indexPath.row)

            self.tableView.deleteRows(at: [indexPath], with: .fade)

        }

    }

}
