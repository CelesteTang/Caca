//
//  PrivacyTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

enum Authentication: Int {

    case password, passwordChanging, touchID

    var title: String {

        switch self {

        case .password: return "Password"
        case .passwordChanging: return "New password"
        case .touchID: return "TouchID"

        }
    }

    var switchButton: UISwitch {

        switch self {

        case .password:

            let passwordSwitch = UISwitch()

            passwordSwitch.center = CGPoint(x: PrivacyRowView.create().bounds.width * 0.9, y: PrivacyRowView.create().bounds.height * 0.5)

            return passwordSwitch

        case .passwordChanging:

            let passwordChangingSwitch = UISwitch()

            passwordChangingSwitch.isHidden = true

            return passwordChangingSwitch

        case .touchID:

            let touchIDSwitch = UISwitch()

            touchIDSwitch.center = CGPoint(x: PrivacyRowView.create().bounds.width * 0.9, y: PrivacyRowView.create().bounds.height * 0.5)

            return touchIDSwitch
        }
    }
}

class PrivacyTableViewController: UITableViewController {

    private var authentications: [Authentication] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if UserDefaults.standard.bool(forKey: "PasswordAuthentication") == true {

            authentications = [.password, .passwordChanging, .touchID]

        } else {

            authentications = [.password]

        }

        tableView.register(PrivacyTableViewCell.self, forCellReuseIdentifier: "PrivacyTableViewCell")

        tableView.allowsSelection = true

        tabBarController?.tabBar.isHidden = true

    }

    // MARK: Set Up

    private func setUp() {

        navigationItem.title = "Privacy"

        tableView.backgroundColor = Palette.backgoundColor

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

            cell.selectionStyle = .none
            switchButton.isOn = UserDefaults.standard.bool(forKey: "PasswordAuthentication")
            switchButton.addTarget(self, action: #selector(openPasswordAuthentication), for: .valueChanged)

        case Authentication.passwordChanging.rawValue:
            break

        case Authentication.touchID.rawValue:

            cell.selectionStyle = .none
            switchButton.isOn = UserDefaults.standard.bool(forKey: "TouchIDAuthentication")
            switchButton.addTarget(self, action: #selector(openTouchIDAuthentication), for: .valueChanged)

        default: break

        }
        cell.rowView.addSubview(switchButton)

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case Authentication.passwordChanging.rawValue:

            UserDefaults.standard.removeObject(forKey: "Password")

            let passwordStorybard = UIStoryboard(name: "Password", bundle: nil)
            let passwordViewController = passwordStorybard.instantiateViewController(withIdentifier: "PasswordViewController")

            present(passwordViewController, animated: true)

        default: break

        }
    }

    func openPasswordAuthentication(sender: UISwitch) {

        if sender.isOn == true {

            UserDefaults.standard.removeObject(forKey: "Password")
            UserDefaults.standard.set(true, forKey: "PasswordAuthentication")

            let passwordStorybard = UIStoryboard(name: "Password", bundle: nil)
            let passwordViewController = passwordStorybard.instantiateViewController(withIdentifier: "PasswordViewController")

            present(passwordViewController, animated: true)

            authentications.append(contentsOf: [.passwordChanging, .touchID])

            UserDefaults.standard.set(true, forKey: "TouchIDAuthentication")

            tableView.reloadData()

        } else {

            UserDefaults.standard.set(false, forKey: "PasswordAuthentication")
            UserDefaults.standard.set(false, forKey: "TouchIDAuthentication")
            UserDefaults.standard.removeObject(forKey: "Password")

            authentications = [.password]
            self.tableView.reloadData()

        }

    }

    func openTouchIDAuthentication(sender: UISwitch) {

        if sender.isOn == true {

            UserDefaults.standard.set(true, forKey: "TouchIDAuthentication")

        } else {

            UserDefaults.standard.set(false, forKey: "TouchIDAuthentication")

        }

    }

}
