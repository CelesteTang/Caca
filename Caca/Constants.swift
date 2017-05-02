//
//  Constants.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/5/2.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

struct Constants {

    struct Storyboard {
        static let landing = "Landing"
        static let opening = "Opening"
        static let caca = "Caca"
        static let timing = "Timing"
        static let fillin = "Fillin"
        static let record = "Record"
        static let recordDetail = "RecordDetail"
        static let calendar = "Calendar"
        static let setting = "Setting"
        static let profile = "Profile"
        static let privacy = "Privacy"
        static let password = "Password"
        static let tabBar = "TabBar"
    }

    struct Identifier {
        static let start = "StartViewController"
        static let signIn = "SignInViewController"
        static let signUp = "SignUpViewController"
        static let openingPage = "OpeningPageViewController"
        static let opening = "OpeningViewController"
        static let caca = "CacaViewController"
        static let timing = "TimingViewController"
        static let fillin = "FillinTableViewController"
        static let record = "RecordTableViewController"
        static let recordDetail = "RecordDetailTableViewController"
        static let calendar = "CalendarViewController"
        static let setting = "SettingTableViewController"
        static let profile = "ProfileTableViewController"
        static let privacy = "PrivacyTableViewController"
        static let password = "PasswordViewController"
        static let tabBar = "TabBarController"
    }

    struct UserDefaultsKey {
        static let name = "Name"
        static let age = "Age"
        static let gender = "Gender"
        static let medicine = "Medicine"
        static let isViewedWalkThrough = "IsViewedWalkThrough"
    }

    struct UIFont {
        static let futuraBold = "Futura-Bold"
    }

}
