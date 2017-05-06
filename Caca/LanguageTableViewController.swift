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

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController {

            appDelegate.window?.rootViewController = tabBarController
            appDelegate.window?.makeKeyAndVisible()

        }
    }
}

//class L012Localizer: NSObject {
//    
//    class func DoTheSwizzling() {
//        // 1
//        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: Selector(("specialLocalizedStringForKey:value:table:")))
//    }
//}
//extension Bundle {
//    func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
//        /*2*/let currentLanguage = L102Language.currentAppleLanguage()
//        var bundle = Bundle()
//        /*3*/if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
//            bundle = Bundle(path: _path)!
//        } else {
//            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
//            bundle = Bundle(path: _path)!
//        }
//        /*4*/return (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
//    }
//}
///// Exchange the implementation of two methods for the same Class
//func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
//    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)
//    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)
//    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
//        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
//    } else {
//        method_exchangeImplementations(origMethod, overrideMethod)
//    }
//}
