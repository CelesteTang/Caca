//
//  PrivacyTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class PrivacyTableViewController: UITableViewController {

    private var authentications: [Authentication] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.tableView.backgroundColor = Palette.lightblue2

        self.navigationItem.title = NSLocalizedString("Privacy", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

        if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.passwordAuthentication) == true {

            authentications = [.password, .passwordChanging, .touchID]

        } else {

            authentications = [.password]

        }

        self.tableView.register(PrivacyTableViewCell.self, forCellReuseIdentifier: "PrivacyTableViewCell")
        self.tableView.allowsSelection = true

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

        cell.rowView.switchButton.onTintColor = Palette.darkblue

        switch indexPath.row {

        case Authentication.password.rawValue:

            cell.selectionStyle = .none
            if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.passwordAuthentication) == true {

                cell.rowView.switchButton.isOn = true

            } else {

                cell.rowView.switchButton.isOn = false

            }

            cell.rowView.switchButton.addTarget(self, action: #selector(openPasswordAuthentication), for: .valueChanged)

        case Authentication.passwordChanging.rawValue:

            cell.rowView.switchButton.isHidden = true
            cell.rowView.switchButton.isEnabled = false

        case Authentication.touchID.rawValue:

            cell.selectionStyle = .none
            cell.rowView.switchButton.isOn = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.touchIDAuthentication)
            cell.rowView.switchButton.addTarget(self, action: #selector(openTouchIDAuthentication), for: .valueChanged)

        default: break

        }

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {

        case Authentication.passwordChanging.rawValue:

            guard let passwordViewController = UIStoryboard(name: Constants.Storyboard.password, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.password) as? PasswordViewController else { return }

            passwordViewController.isFromPasswordChanging = true

            present(passwordViewController, animated: true)

        default: break

        }
    }

    func openPasswordAuthentication(sender: UISwitch) {

        if sender.isOn == true {

            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.passwordAuthentication)
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.touchIDAuthentication)

            guard let passwordViewController = UIStoryboard(name: Constants.Storyboard.password, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.password) as? PasswordViewController else { return }

            passwordViewController.isFromPassword = true

            present(passwordViewController, animated: true)

            authentications.append(contentsOf: [.passwordChanging, .touchID])

            self.tableView.reloadData()

        } else {

            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.passwordAuthentication)
            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.touchIDAuthentication)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.password)

            authentications = [.password]

            self.tableView.reloadData()

        }

    }

    func openTouchIDAuthentication(sender: UISwitch) {

        if sender.isOn == true {

            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.touchIDAuthentication)

        } else {

            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.touchIDAuthentication)

        }

    }

}
