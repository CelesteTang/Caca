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

            return "Caca"

        case .record:

            return "Record"

        case .calendar:

            return "Calendar"

        case .setting:

            return "Setting"
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

    }

}
