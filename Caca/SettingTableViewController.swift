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

            case .profile: return NSLocalizedString("Profile", comment: "")

            case .privacy: return NSLocalizedString("Privacy", comment: "")

            case .notification: return NSLocalizedString("Notification", comment: "")

            case .language: return NSLocalizedString("Language", comment: "")

            }
        }

    }

    private let settings: [Setting] = [.profile, .privacy]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Palette.lightblue2

        self.navigationItem.title = NSLocalizedString("Setting", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Back", comment: "")
        backItem.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""], for: .normal)
        self.navigationItem.backBarButtonItem = backItem

        self.tableView.separatorStyle = .none
        self.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.iconImageView.image = #imageLiteral(resourceName: "caca-big")
        cell.rowView.titleLabel.text = settings[indexPath.row].title
        cell.rowView.titleLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        cell.rowView.separateLineView.backgroundColor = Palette.darkblue

        let backgroundView = UIView()
        backgroundView.backgroundColor = Palette.lightblue
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .default

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {

        case Setting.profile.rawValue:

            guard let profileViewController = UIStoryboard(name: Constants.Storyboard.profile, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.profile) as? ProfileTableViewController else { return }

            self.navigationController?.pushViewController(profileViewController, animated: true)

        case Setting.privacy.rawValue:

            guard let privacyTableViewController = UIStoryboard(name: Constants.Storyboard.privacy, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.privacy) as? PrivacyTableViewController else { return }

            self.navigationController?.pushViewController(privacyTableViewController, animated: true)

        default: break

        }
    }
}
