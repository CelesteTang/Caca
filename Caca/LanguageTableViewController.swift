//
//  LanguageTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/5/6.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

enum Language {

    case English, 繁體中文

    var title: String {

        switch self {

        case .English: return "English"

        case .繁體中文: return "繁體中文"

        }
    }
}

class LanguageTableViewController: UITableViewController {

    private let languages: [Language] = [.繁體中文, .English]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.tableView.backgroundColor = Palette.lightblue2

        self.navigationItem.title = NSLocalizedString("Language", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

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

        return languages.count

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell", for: indexPath) as! PrivacyTableViewCell
        // swiftlint:enable force_cast

        cell.rowView.privacyLabel.text = languages[indexPath.row].title
        cell.rowView.switchButton.isHidden = true
        cell.rowView.switchButton.isEnabled = false

        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let language = languages[indexPath.row]

        switch language {

        case .繁體中文:

            setLanguage(to: .繁體中文)

        case .English:

            setLanguage(to: .English)

        }
    }

    func setLanguage(to language: Language) {

        switch language {
        case .English: UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        case .繁體中文: UserDefaults.standard.set(["zh-Hant"], forKey: "AppleLanguages")
        }
    }
    
    func showAlert() {
    
        let alertController = UIAlertController(title: "Note", message: "Please restart", preferredStyle: .actionSheet)
    }
}
