//
//  PrivacyTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

enum Authentication: Int {

    case password, touchID

    var title: String {

        switch self {

        case .password: return "Password"
        case .touchID: return "TouchID"

        }
    }

    var switchButton: UISwitch {

        switch self {

        case .password:

            let passwordSwitch = UISwitch()

            passwordSwitch.center = CGPoint(x: PrivacyRowView.create().bounds.width * 0.9, y: PrivacyRowView.create().bounds.height * 0.5)

            return passwordSwitch

        case .touchID:

            let touchIDSwitch = UISwitch()

            touchIDSwitch.center = CGPoint(x: PrivacyRowView.create().bounds.width * 0.9, y: PrivacyRowView.create().bounds.height * 0.5)

            return touchIDSwitch
        }
    }
}

class PrivacyTableViewController: UITableViewController {

    private let authentications: [Authentication] = [.password, .touchID]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PrivacyTableViewCell.self, forCellReuseIdentifier: "PrivacyTableViewCell")

        tableView.allowsSelection = false
        tableView.backgroundColor = Palette.backgoundColor

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return authentications.count

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell", for: indexPath) as! PrivacyTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.privacyLabel.text = authentications[indexPath.row].title

        let switchButton = authentications[indexPath.row].switchButton
        switchButton.onTintColor = Palette.textColor

        switch indexPath.row {

        case Authentication.password.rawValue:

            switchButton.addTarget(self, action: #selector(openPasswordAuthentication), for: .valueChanged)

        case Authentication.touchID.rawValue:

            switchButton.addTarget(self, action: #selector(openTouchIDAuthentication), for: .valueChanged)

        default: break

        }
        cell.rowView.addSubview(switchButton)

        return cell

    }

    func openPasswordAuthentication(sender: UISwitch) {
//
//        guard let cell = sender.superview?.superview?.superview as? PrivacyTableViewCell, let indexPath = tableView.indexPath(for: cell) else {
//
//            return
//
//        }

        if sender.isOn == true {

            // to-do: launch with password
            UserDefaults.standard.set(true, forKey: "PasswordAuthentication")

        } else {

            UserDefaults.standard.set(false, forKey: "PasswordAuthentication")

        }

    }

    func openTouchIDAuthentication(sender: UISwitch) {

        if sender.isOn == true {

            // to-do: launch with TouchID
            UserDefaults.standard.set(true, forKey: "TouchIDAuthentication")

        } else {

            UserDefaults.standard.set(false, forKey: "TouchIDAuthentication")

        }

    }

}
