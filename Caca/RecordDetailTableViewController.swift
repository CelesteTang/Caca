//
//  RecordDetailTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/5/1.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cacaPhoto: UIImageView!

    @IBOutlet weak var passOrFailView: UIView!

    @IBOutlet weak var infoTableView: UITableView!

    @IBOutlet weak var deleteButton: UIButton!

    enum Component: Int {

        case date, time, color, shape, amount, period, medicine, other

        var title: String {

            switch self {
            case .date: return NSLocalizedString("Date", comment: "")
            case .time: return NSLocalizedString("Time", comment: "")
            case .color: return NSLocalizedString("Color", comment: "")
            case .shape: return NSLocalizedString("Shape", comment: "")
            case .amount: return NSLocalizedString("Amount", comment: "")
            case .period: return NSLocalizedString("Period", comment: "")
            case .medicine: return NSLocalizedString("Medicine", comment: "")
            case .other: return NSLocalizedString("Other", comment: "")
            }
        }
    }

    // MARK: Property

    var components: [Component] = [.date, .time, .color, .shape, .amount, .other]

    var recievedCaca = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.gender) as? Int == Gender.female.rawValue && UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.medicine) as? Int == 0 {

            components = [.date, .time, .color, .shape, .amount, .period, .medicine, .other]

        } else if UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.gender) as? Int == Gender.female.rawValue {

            components = [.date, .time, .color, .shape, .amount, .period, .other]

        } else if UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.medicine) as? Int == 0 {

            components = [.date, .time, .color, .shape, .amount, .medicine, .other]

        }

        self.infoTableView.dataSource = self
        self.infoTableView.delegate = self
        self.infoTableView.register(RecordDetailTableViewCell.self, forCellReuseIdentifier: "RecordDetailTableViewCell")

        setUp()

    }

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2
        self.infoTableView.backgroundColor = Palette.lightblue2

        self.navigationItem.title = NSLocalizedString("My caca", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

        self.cacaPhoto.image = #imageLiteral(resourceName: "caca-big")
        self.cacaPhoto.backgroundColor = Palette.lightblue2

        self.infoTableView.allowsSelection = false
        self.infoTableView.separatorStyle = .none

        self.passOrFailView.isHidden = true

        if let photoURL = self.recievedCaca[0].photoURL {

            DispatchQueue.global().async {
                if let url = URL(string: photoURL) {

                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)

                        DispatchQueue.main.async {

                            self.cacaPhoto.image = image
                            self.cacaPhoto.layer.cornerRadius = self.cacaPhoto.frame.width / 2
                            self.cacaPhoto.layer.masksToBounds = true
                            self.passOrFailView.isHidden = false
                            self.passOrFailView.layer.cornerRadius = self.passOrFailView.frame.width / 2

                            if self.recievedCaca[0].grading == true {

                                self.passOrFailView.backgroundColor = Palette.passColor

                            } else {

                                self.passOrFailView.backgroundColor = Palette.failColor

                            }
                        }

                    } catch {

                        print(error.localizedDescription)

                    }
                }
            }
        }

        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editCaca))
        self.navigationItem.rightBarButtonItem = editButton

        self.deleteButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        self.deleteButton.backgroundColor = Palette.darkblue
        self.deleteButton.tintColor = Palette.cream
        self.deleteButton.layer.cornerRadius = self.deleteButton.frame.height / 2
        self.deleteButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        self.deleteButton.addTarget(self, action: #selector(deleteRecord), for: .touchUpInside)

    }

    func editCaca() {

        guard let fillinTableViewController = UIStoryboard(name: Constants.Storyboard.fillin, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.fillin) as? FillinTableViewController else { return }

        fillinTableViewController.recievedCacaFromRecordDetail = self.recievedCaca
        fillinTableViewController.isFromRecordDetail = true

        present(fillinTableViewController, animated: true)

    }

    func deleteRecord() {

        let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                message: NSLocalizedString("Do you want to delete this record?", comment: ""),
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel,
                                         handler: nil)

        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { _ in

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

                tabBarController?.selectedIndex = TabBarItemType.record.rawValue

                CacaProvider.shared.deleteCaca(cacaID: self.recievedCaca[0].cacaID)

                appDelegate.window?.rootViewController = tabBarController

            }
        }

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return components.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        switch component {

        case .date, .time, .color, .shape, .amount, .period, .medicine, .other: return 1

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = components[indexPath.section]

        switch component {

        case .date, .time, .color, .shape, .amount, .period, .medicine, .other: return 50.0

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {
        case .date:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = "\(self.recievedCaca[0].date) \(self.recievedCaca[0].time)"

            return cell

        case .time:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].consumingTime

            return cell

        case .color:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].color

            return cell

        case .shape:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].shape

            return cell

        case .amount:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].amount

            return cell

        case .period:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title

            if self.recievedCaca[0].period == 0 {

                cell.rowView.infoTextLabel.text = NSLocalizedString("Yes", comment: "")

            } else if self.recievedCaca[0].period == 1 {

                cell.rowView.infoTextLabel.text = NSLocalizedString("No", comment: "")

            }

            return cell

        case .medicine:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].medicine

            return cell

        case .other:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordDetailTableViewCell", for: indexPath) as! RecordDetailTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].otherInfo

            return cell

        }

    }

}
