//
//  SettingTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    enum Setting: Int {

        case profile, privacy, notification, language

        var title: String {

            switch self {

            case .profile: return "Profile"
            case .privacy: return "Privacy"
            case .notification: return "Notification"
            case .language: return "Language"

            }
        }

    }

    private let setting: [Setting] = [.profile, .privacy, .notification, .language]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Setting"
        view.backgroundColor = Palette.backgoundColor

        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.titleLabel.text = setting[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
            
        case Setting.profile.rawValue:

            let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }

            self.navigationController?.pushViewController(viewController, animated: true)

        case Setting.privacy.rawValue:

            let storyBoard = UIStoryboard(name: "Privacy", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "PrivacyTableViewController") as? PrivacyTableViewController else { return }

            self.navigationController?.pushViewController(viewController, animated: true)

//        case Setting.notification.rawValue:
//
//            let storyBoard = UIStoryboard(name: "Notification", bundle: nil)
//            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController else { return }
//
//            self.navigationController?.pushViewController(viewController, animated: true)
//
//        case Setting.language.rawValue:
//
//            let storyBoard = UIStoryboard(name: "Language", bundle: nil)
//            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as? LanguageViewController else { return }
//
//            self.navigationController?.pushViewController(viewController, animated: true)

        default: break

        }

    }

}
