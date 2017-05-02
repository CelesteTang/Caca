//
//  TabBarController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

// MARK: - TabBarItemType

enum TabBarItemType: Int {

    case caca, record, calendar, setting

    var item: UITabBarItem {

        return UITabBarItem(title: title, image: image, tag: rawValue)

    }

    var title: String {

        switch self {

        case .caca:

            return NSLocalizedString("Caca", comment: "")

        case .record:

            return NSLocalizedString("Record", comment: "")

        case .calendar:

            return NSLocalizedString("Calendar", comment: "")

        case .setting:

            return NSLocalizedString("Setting", comment: "")
        }

    }

    var image: UIImage {

        switch self {

        case .caca:

            return #imageLiteral(resourceName: "caca").withRenderingMode(.alwaysTemplate)

        case .record:

            return #imageLiteral(resourceName: "record").withRenderingMode(.alwaysTemplate)

        case .calendar:

            return #imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysTemplate)

        case .setting:

            return #imageLiteral(resourceName: "setting").withRenderingMode(.alwaysTemplate)

        }

    }

}

// MARK: - TabBarController

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = Palette.darkblue
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 15) ?? ""], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 15) ?? ""], for: .selected)

    }

}
