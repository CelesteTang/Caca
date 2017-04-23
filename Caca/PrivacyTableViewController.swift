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

        if UserDefaults.standard.bool(forKey: "PasswordAuthentication") == true {

            authentications = [.password, .passwordChanging, .touchID]

        } else {

            authentications = [.password]

        }

        self.tableView.register(PrivacyTableViewCell.self, forCellReuseIdentifier: "PrivacyTableViewCell")

        self.tableView.allowsSelection = true

        tabBarController?.tabBar.isHidden = true

    }

    // MARK: Set Up

    private func setUp() {

        self.tableView.backgroundColor = Palette.lightblue2

        self.navigationItem.title = "Privacy"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""]

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
        switchButton.onTintColor = Palette.darkblue

        switch indexPath.row {

        case Authentication.password.rawValue:

            cell.selectionStyle = .none
            switchButton.isOn = UserDefaults.standard.bool(forKey: "PasswordAuthentication")
            switchButton.addTarget(self, action: #selector(openPasswordAuthentication), for: .valueChanged)

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

//            UserDefaults.standard.removeObject(forKey: "Password")

            let passwordStorybard = UIStoryboard(name: "Password", bundle: nil)
            guard let passwordViewController = passwordStorybard.instantiateViewController(withIdentifier: "PasswordViewController") as? PasswordViewController else { return }

            passwordViewController.isFromPasswordChanging = true

            present(passwordViewController, animated: true)

        default: break

        }
    }

    func openPasswordAuthentication(sender: UISwitch) {

        if sender.isOn == true {

            UserDefaults.standard.set(true, forKey: "PasswordAuthentication")

            let passwordStorybard = UIStoryboard(name: "Password", bundle: nil)
            guard let passwordViewController = passwordStorybard.instantiateViewController(withIdentifier: "PasswordViewController") as? PasswordViewController else { return }

            passwordViewController.isFromPassword = true

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
