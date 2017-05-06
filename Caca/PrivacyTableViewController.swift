//
//  PrivacyTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import KeychainAccess

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

        let authentication = authentications[indexPath.row]

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell", for: indexPath) as! PrivacyTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.privacyLabel.text = authentications[indexPath.row].title

        switch authentication {

        case .password:

            cell.selectionStyle = .none
            if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.passwordAuthentication) == true {

                cell.rowView.switchButton.isOn = true

            } else {

                cell.rowView.switchButton.isOn = false

            }

            cell.rowView.switchButton.addTarget(self, action: #selector(openPasswordAuthentication), for: .valueChanged)

        case .passwordChanging:

            cell.rowView.switchButton.isHidden = true
            cell.rowView.switchButton.isEnabled = false

        case .touchID:

            cell.selectionStyle = .none
            cell.rowView.switchButton.isOn = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.touchIDAuthentication)
            cell.rowView.switchButton.addTarget(self, action: #selector(openTouchIDAuthentication), for: .valueChanged)

        default: break

        }

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let authentication = authentications[indexPath.row]

        switch authentication {

        case .passwordChanging:

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

            let keychain = Keychain(service: "tw.hsinyutang.Caca-user")
            keychain[Constants.KeychainKey.password] = nil

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
