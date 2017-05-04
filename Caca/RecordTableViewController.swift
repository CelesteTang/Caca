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

        self.view.backgroundColor = Palette.lightblue2

        self.navigationItem.title = NSLocalizedString("Record", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Back", comment: "")
        backItem.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""], for: .normal)
        self.navigationItem.backBarButtonItem = backItem

        self.tableView.separatorStyle = .none

        self.coverButtonTitle = NSLocalizedString("Hide", comment: "Hide caca photo")

        if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.hide) == true {

            coverButtonTitle = NSLocalizedString("Show", comment: "Show caca photo")

        } else if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.hide) == false {

            coverButtonTitle = NSLocalizedString("Hide", comment: "Hide caca photo")

        }

        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""], for: .normal)

        let coverButton = UIBarButtonItem(title: coverButtonTitle, style: .plain, target: self, action: #selector(coverCaca))
        self.navigationItem.leftBarButtonItem = coverButton

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCaca))
        self.navigationItem.rightBarButtonItem = addButton

    }

    func coverCaca() {

        if isCovered == false {

            isCovered = true
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.hide)
            self.navigationItem.leftBarButtonItem?.title = NSLocalizedString("Show", comment: "Show caca photo")
            self.tableView.reloadData()

        } else {

            isCovered = false
            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.hide)
            self.navigationItem.leftBarButtonItem?.title = NSLocalizedString("Hide", comment: "Hide caca photo")
            self.tableView.reloadData()

        }

    }

    func addCaca() {

        guard let fillinViewController = UIStoryboard(name: Constants.Storyboard.fillin, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.fillin) as? FillinTableViewController else { return }

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
        cell.rowView.cacaPhotoImageView.backgroundColor = Palette.lightblue2

        cell.rowView.separateLineView.backgroundColor = Palette.darkblue

        if isCovered == false {

            if let photoURL = cacas[indexPath.row].photoURL {

                DispatchQueue.global().async {

                    if let url = URL(string: photoURL) {

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

            cell.rowView.passOrFailLabel.text = NSLocalizedString("Pass", comment: "The caca is healthy")
            cell.rowView.passOrFailLabel.textColor = Palette.passColor
            backgroundView.backgroundColor = Palette.selectedPassColor
            cell.selectionStyle = .default

        } else {

            cell.rowView.passOrFailLabel.text = NSLocalizedString("Fail", comment: "The caca is not healthy")

            cell.rowView.passOrFailLabel.textColor = Palette.failColor
            backgroundView.backgroundColor = Palette.selectedFailColor
            cell.selectionStyle = .default

        }

        cell.selectedBackgroundView = backgroundView

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let recordDetailTableViewController = UIStoryboard(name: Constants.Storyboard.recordDetail, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.recordDetail) as? RecordDetailTableViewController else { return }

        recordDetailTableViewController.recievedCaca = [self.cacas[indexPath.row]]

        self.navigationController?.pushViewController(recordDetailTableViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            if let photoID = self.cacas[indexPath.row].photoID {

                CacaProvider.shared.deleteCaca(cacaID: self.cacas[indexPath.row].cacaID)
                CacaProvider.shared.deleteCacaPhoto(photoID: photoID)
                self.cacas.remove(at: indexPath.row)

                self.tableView.deleteRows(at: [indexPath], with: .fade)

            }
        }
    }
}
