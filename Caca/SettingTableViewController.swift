//
//  SettingTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import MessageUI

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    enum Component: Int {

        case profile, privacy, notification, language, email

        var title: String {

            switch self {

            case .profile: return NSLocalizedString("Profile", comment: "")

            case .privacy: return NSLocalizedString("Privacy", comment: "")

            case .notification: return NSLocalizedString("Notification", comment: "")

            case .language: return NSLocalizedString("Language", comment: "")

            case .email: return NSLocalizedString("Problem Report", comment: "")

            }
        }

    }

    let components: [Component] = [.profile, .privacy, .language, .email]

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

        return components.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.titleLabel.text = components[indexPath.row].title

        let backgroundView = UIView()
        backgroundView.backgroundColor = Palette.lightblue
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .default

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let component = components[indexPath.row]

        switch component {

        case .profile:

            guard let profileViewController = UIStoryboard(name: Constants.Storyboard.profile, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.profile) as? ProfileTableViewController else { return }

            self.navigationController?.pushViewController(profileViewController, animated: true)

        case .privacy:

            guard let privacyTableViewController = UIStoryboard(name: Constants.Storyboard.privacy, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.privacy) as? PrivacyTableViewController else { return }

            self.navigationController?.pushViewController(privacyTableViewController, animated: true)

        case .language:

            guard let languageTableViewController = UIStoryboard(name: Constants.Storyboard.language, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.language) as? LanguageTableViewController else { return }

            self.navigationController?.pushViewController(languageTableViewController, animated: true)

        case .email:

            sendEmail()

        default: break

        }
    }

    func sendEmail() {

        if MFMailComposeViewController.canSendMail() {

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["caca.team.tw@gmail.com"])
            mail.setSubject(NSLocalizedString("Problem Report", comment: ""))

            self.present(mail, animated: true)

        } else {

            let alertController = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("Your iPhone could not send mail.", comment: ""), preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alertController, animated: true, completion: nil)

        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true)

    }

}
