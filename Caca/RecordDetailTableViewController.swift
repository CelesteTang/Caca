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

    @IBOutlet weak var infoTableView: UITableView!

    @IBOutlet weak var passOrFailLabel: UILabel!

    enum Component: Int {

        case date, time, color, shape, amount, period, medicine, other

        var title: String {

            switch self {
            case .date: return "Date"
            case .time: return "Time"
            case .color: return "Color"
            case .shape: return "Shape"
            case .amount: return "Amount"
            case .period: return "Period"
            case .medicine: return "Medicine"
            case .other: return "Other"
            }
        }
    }

    // MARK: Property

    var components: [Component] = [.date, .time, .color, .shape, .amount, .other]

    var recievedCaca = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: "Gender") as? Int == Gender.female.rawValue && UserDefaults.standard.value(forKey: "Medicine") as? Int == 0 {

            components = [.date, .time, .color, .shape, .amount, .period, .medicine, .other]

        } else if UserDefaults.standard.value(forKey: "Gender") as? Int == Gender.female.rawValue {

            components = [.date, .time, .color, .shape, .amount, .period, .other]

        } else if UserDefaults.standard.value(forKey: "Medicine") as? Int == 0 {

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
        
        self.navigationItem.title = "My caca"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""]

        self.cacaPhoto.image = #imageLiteral(resourceName: "caca-big")
        self.cacaPhoto.backgroundColor = Palette.lightblue2

        self.infoTableView.allowsSelection = false
        self.infoTableView.separatorStyle = .none

        if self.recievedCaca[0].photo != "" {

            DispatchQueue.global().async {
                if let url = URL(string: self.recievedCaca[0].photo) {

                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)

                        DispatchQueue.main.async {

                            self.cacaPhoto.image = image
                            self.cacaPhoto.layer.cornerRadius = self.cacaPhoto.frame.width / 2
                            self.cacaPhoto.layer.masksToBounds = true
                        }

                    } catch {

                        print(error.localizedDescription)

                    }
                }
            }
        }

        if self.recievedCaca[0].grading == true {

            self.passOrFailLabel.text = "Pass"
            self.passOrFailLabel.backgroundColor = Palette.passColor

        } else {

            self.passOrFailLabel.text = "Fail"
            self.passOrFailLabel.backgroundColor = Palette.failColor

        }

        self.passOrFailLabel.textColor = Palette.cream

        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editCaca))
        self.navigationItem.rightBarButtonItem = editButton
    }

    func editCaca() {

        guard let fillinTableViewController = UIStoryboard(name: "Fillin", bundle: nil).instantiateViewController(withIdentifier: "FillinTableViewController") as? FillinTableViewController else { return }

        fillinTableViewController.recievedCacaFromRecordDetail = self.recievedCaca
        fillinTableViewController.isFromRecordDetail = true

        present(fillinTableViewController, animated: true)

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
            cell.rowView.infoTextLabel.text = self.recievedCaca[0].date

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

                cell.rowView.infoTextLabel.text = "Yes"

            } else if self.recievedCaca[0].period == 1 {

                cell.rowView.infoTextLabel.text = "No"

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
